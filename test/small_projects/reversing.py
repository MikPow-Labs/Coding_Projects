def transformFlag(flag):
    """
    Original Kotlin function but remade in python
    """
    res = ""
    
    alphabet = "abcdefghijklmnopqrstuvwxyz"
    digits = "0123456789"
    special = "!@#$%^&*()_+{}[]|"
    
    for i in range(len(flag)):
        char = flag[i]
        
        # Check alphabet
        if char in alphabet:
            c = alphabet.index(char)
            ind = c + i
            res += alphabet[ind % len(alphabet)]
        
        # Check digits
        elif char in digits:
            c = digits.index(char)
            ind = (i * 2) + c
            res += digits[ind % len(digits)]
        
        # Check special characters
        elif char in special:
            c = special.index(char)
            ind = (i * i) + c
            res += special[ind % len(special)]
    
    return res


def reverseFlag(transformed):
    length = len(transformed)
    reversed = ""
    alphabet = "abcdefghijklmnopqrstuvwxyz"
    digits = "0123456789"
    special = "!@#$%^&*()_+{}[]|"
    for i in range(length):
        charIndex = transformed[i]
        if charIndex in alphabet:
            c = alphabet.index(charIndex)
            ind = c - i
            reversed += alphabet[ind % len(alphabet)]
        elif charIndex in digits:
            c = digits.index(charIndex)
            ind = c - int(i * 2)
            reversed += digits[ind % len(digits)]
        elif charIndex in special:
            c = special.index(charIndex)
            ind = c - (i * i)
            reversed += special[ind % len(special)]
    return reversed

def main():
    #tranFlag = transformFlag("flag{m0d1fy!}")
    #print(tranFlag)
    #print(reverseFlag(tranFlag))
    print(reverseFlag("idvi+1{s6e3{)arg2zv[moqa905+"))

main()