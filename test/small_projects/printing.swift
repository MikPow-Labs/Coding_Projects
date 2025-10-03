import Foundation
//Prints full name from inputs

print("Enter your first name: ", terminator: "")
let word1 = readLine() ?? ""
print("Enter your middle name: ", terminator: "")
let word2 = readLine() ?? ""
print("Enter your last name: ", terminator: "")
let word3 = readLine() ?? ""

func hello(word1: String, word2: String, word3: String) {
    let list = [word1, word2, word3]
    let number = list.count
    var i = 0
    var full = ""
    while i < number{
        full = full + list[i] + " "
        i = i + 1
    }
    print(full)
}
hello(word1: word1, word2: word2, word3: word3)