import Foundation
//Caesar cipher WIP
func caesar_cipher_encrypt(message: String, shift: Int) -> String{
    var new_message = ""
    let new_shift = (shift % 26 + 26) % 26
    for char in message{
        if let ascii = char.asciiValue{
            var shifted: UInt8
            if ascii >= 65 && ascii <= 90{
                shifted = ((ascii - 65 + UInt8(new_shift)) % 26) + 65
                new_message.append(Character(UnicodeScalar(shifted))) 
            } else if ascii >= 97 && ascii <= 122{
                shifted = ((ascii - 97 + UInt8(new_shift)) % 26) + 97
                new_message.append(Character(UnicodeScalar(shifted)))
            } else {
                new_message.append(char)
            }
        }
    }
    return(new_message)
}

func caesar_cipher_decrypt(message: String, shift: Int) -> String{
    var new_message = ""
    let new_shift = (shift % 26 + 26) % 26
    for char in message{
        if let ascii = char.asciiValue{
            var shifted: UInt8
            if ascii >= 65 && ascii <= 90{
                shifted = ((ascii - 65 - UInt8(new_shift)) % 26) + 65
                new_message.append(Character(UnicodeScalar(shifted))) 
            } else if ascii >= 97 && ascii <= 122{
                shifted = ((ascii - 97 - UInt8(new_shift)) % 26) + 97
                new_message.append(Character(UnicodeScalar(shifted)))
            } else {
                new_message.append(char)
            }
        }
    }
    return(new_message)
}

func main(){
    print("Do you wish to encrypt(E) or decrypt(D) a function? (E/D):")
    let method = readLine() ?? ""
    print("Enter shift value: ")
    let shift = Int(readLine() ?? "0") ?? 0
    if method == "E"{
        print("Enter the message you want to encrypt: ")
        let message = readLine() ?? ""
        let encrypted = caesar_cipher_encrypt(message: message, shift: shift)
        print("Encrypted message: \(encrypted)")
    } else if method == "D"{
        print("Enter the message you want to decrypt: ")
        let message = readLine() ?? ""
        let decrypted = caesar_cipher_decrypt(message: message, shift: shift)
        print("Decrypted message: \(decrypted)")
    }
}
main()
