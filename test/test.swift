import Foundation

//Vignere cipher, WIP

var array: [Character] = []

print("Enter text: ")
let message = readLine() ?? ""
print("Enter key: ")
let key = readLine() ?? ""

var number = 0

func letter_to_number(message: String){
    let letterIndex = message.index(message.startIndex, offsetBy: number)
    let letter = message[letterIndex]
    array.append(letter.asciiValue)
}


let random = """
func encrypt(){
    var first_letter = ""Character""
    while number < message.count{
        let letterIndex = message.index(message.startIndex, offsetBy: number)
        let letter = message[letterIndex]
        array.append(letter)
        number += 1
    }
    number = 0
    for letter in array{
        if array[number].isUppercase{
            first_letter = String(Unicodescalar(array[number].asciiValue! - 64)!)
        }
    }
    print(first_letter)
}
func main(){
    encrypt()
}
"""
let test = """
func unpack(message: array){
    encrypt = ""
    let letterIndex = message.index(message.startIndex, offsetBy: number)
    let letter = message[letterIndex]
}
"""