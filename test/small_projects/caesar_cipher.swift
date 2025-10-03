import Foundation
//Caesar cipher (Work In Progress)

print("Enter the message you want to encrypt: ")
let message = readLine() ?? ""
print("Enter shift value: ")
let shift = Int(readLine() ?? "0") ?? 0
let length = message.count
var new_message = ""
func caesar_cipher(){
    for char in message{
        if 65 <= Character(message[message.index(message.startIndex, offsetBy: number)]).asciiValue && Character(message[message.index(message.startIndex, offsetBy: number)]).asciiValue <= 90{
            var value = Character(message[number]).asciiValue - 65
            value = value % 26 + 65
            new_message.append(Character(UnicodeScalar(value))) 
        } else if 97 <= Character(message[message.index(message.startIndex, offsetBy: number)]).asciiValue && Character(message[message.index(message.startIndex, offsetBy: number)]).asciiValue <= 122{
            var value = Character(message[number]).asciiValue - 97
            value = value % 26 + 97
            new_message.append(Character(UnicodeScalar(value)))
        } else {
            var value = Character(message[number]).asciiValue - 97
            new_message.append(Character(UnicodeScalar(value)))
        }

    }
    return(new_message)
}
caesar_cipher()

