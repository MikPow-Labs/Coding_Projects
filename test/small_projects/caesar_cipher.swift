import Foundation
//Caesar cipher WIP

print("Enter the message you want to encrypt: ")
let message = readLine() ?? ""
print("Enter shift value: ")
let shift = Int(readLine() ?? "0") ?? 0
func caesar_cipher(message: String, shift: Int) -> String{
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
let encrypted = caesar_cipher(message: message, shift: shift)
print("Encrypted message: \(encrypted)")
