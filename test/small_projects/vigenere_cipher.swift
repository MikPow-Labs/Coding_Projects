import Foundation

//Vignere cipher, WIP

func encrypt(_ message: [String], _ key: [String]) -> String{
    var new_message = ""
    var i = 0 
    var j = 0
    for char in message{
        var uppercase = 0
        let character = Character(message[i])
        let key_character = Character(key[j])
        var ascii = (character.asciiValue)!
        var ascii_key = (key_character.asciiValue)!
        var value = 0
        if ascii >= 65, ascii <= 90{
            ascii = ascii - 64
            uppercase = 1
        } else if ascii >= 97, ascii <= 122{
            ascii = ascii - 96
        } else {
            new_message.append(character)
            i += 1
            continue
        }
        if ascii_key >= 65, ascii_key <= 90{
            ascii_key = ascii_key - 64
        } else if ascii_key >= 97, ascii_key <= 122{
            ascii_key = ascii_key - 96
        } 
        value = Int(exactly: ascii)! + Int(exactly: ascii_key)! - 1
        while value > 26{
            value -= 26
        }
        while value < 1{
            value += 26
        }
        switch uppercase {
            case 0:
                value += 96
            case 1:
                value += 64
            default:
                break
        }
        if let scalar = UnicodeScalar(value) {
            let character = Character(scalar)
            new_message.append(character)
        }
        i += 1
        if character.isLetter{
            j += 1
        } 
        if j == key.count{
            j = 0
        }
    }
    return(new_message)
}
func decrypt(_ message: [String], _ key: [String]) -> String{
    var new_message = ""
    var i = 0 
    var j = 0
    for char in message{
        var uppercase = 0
        let character = Character(message[i])
        let key_character = Character(key[j])
        var ascii = (character.asciiValue)!
        var ascii_key = (key_character.asciiValue)!
        var value = 0
        if ascii >= 65, ascii <= 90{
            ascii = ascii - 64
            uppercase = 1
        } else if ascii >= 97, ascii <= 122{
            ascii = ascii - 96
        } else {
            new_message.append(character)
            i += 1
            continue
        }
        if ascii_key >= 65, ascii_key <= 90{
            ascii_key = ascii_key - 64
        } else if ascii_key >= 97, ascii_key <= 122{
            ascii_key = ascii_key - 96
        } 
        value = Int(exactly: ascii)! - Int(exactly: ascii_key)!
        while value > 26{
            value -= 26
        }
        while value < 1{
            value += 26
        }
        switch uppercase {
            case 0:
                value += 96
            case 1:
                value += 64
            default:
                print("None")
        }
        if let scalar = UnicodeScalar(value) {
            let character = Character(scalar)
            new_message.append(character)
        }
        i += 1
        if character.isLetter{
            j += 1
        } 
        if j == key.count{
            j = 0
        }
    }
    return(new_message)
}
print("Do you want to Encrypt(E) or Decrypt(D) (E/D): ", terminator: "")
let response = readLine() ?? ""
if response == "E"{
    print("Enter text: ")
    let message = readLine() ?? ""
    print("Enter key: ")
    let key = readLine() ?? ""
    var array_message: Array = message.map {String($0)}
    var array_key: Array = key.map {String($0)}
    let encrypted = encrypt(array_message, array_key)
    print("Encrypted message:", encrypted)
} else if response == "D"{
    print("Enter text: ")
    let message = readLine() ?? ""
    print("Enter key: ")
    let key = readLine() ?? ""
    var array_message: Array = message.map {String($0)}
    var array_key: Array = key.map {String($0)}
    let decrypted = decrypt(array_message, array_key)
    print("Decrypted message:", decrypted)
}