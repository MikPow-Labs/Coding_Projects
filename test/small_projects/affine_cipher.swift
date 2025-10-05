import Foundation

func encrypt(_ message: String, _ a: Character, _ b: Character){
    print(message)
}

func decrypt(_ message: String, _ a: Character, _ b: Character){
    print(message)
}

print("Do you want to Encrypt() or Decrypt(D)? (E/D): ", terminator: "")
let response = readLine() ?? ""
if response == "E"{
    encrypt("Hello", "a", "b")
} else if response == "D"{
    decrypt("Goodbye", "b", "a")
}