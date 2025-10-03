import Foundation
let comment = """
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

//Calculator for two numbers

print("Enter your first number: ", terminator: "")
let numb1 = Double(readLine() ?? "0") ?? 0
print("Enter your second number: ", terminator: "")
let numb2 = Double(readLine() ?? "0") ?? 0
print("What operation do you want (+, /, -, *, ^): ")
let operation = readLine() ?? "/"
var result: Double = 0

switch operation{
    case "+":
        result = numb1 + numb2
    case "-":
        result = numb1 - numb2
    case "*":
        result = numb1 * numb2
    case "/":
        if numb2 != 0{
            result = numb1 / numb2
        } else {
            print("Cannot divide by zero")
        }

    case "^":
        result = pow(numb1, numb2)
    default:
        print("Incorrect syntax")
}
print("Result:", result)

//Guessing the number game

let number = Int.random(in: 1..<100)
var number_guess = 0
while number_guess < 6{
    print("Guess a number between 1 and 100: ", terminator: "")
    let guess = Int(readLine() ?? "") ?? 0
    if guess == number{
        print("Congradulations! You guessed the number!")
    } else if guess > number{
        print("Too high")
    } else if guess < number{
        print("Too low")
    } else {
        print("Invalid input")
    }
    number_guess = number_guess + 1
}


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


//Are you smarter than a fifth grader
var score = 0
print("Welcome to are you smarter than a fifth grader?")
print("Get ready to answer some questions!")
var questions = ["What is the capital of New York?", "What is the capital of Japan?", "Who was the 16th president of the United States?", "What is the largest land animal?", "Which country is closest to the Great Barrier Reef? "]
var answers = ["albany", "tokyo", "abraham lincoln", "elephant", "australia"]
var iteration = 0
var number = 0
var response = ""
func game() {
    while iteration < 5{
        let place = questions.randomElement()!
        let number = questions.firstIndex(of: place)!
        print(questions[number])
        response = readLine() ?? ""
        if response.lowercased() == answers[number]{
            print("Correct!")
            score = score + 1
            iteration = iteration + 1
        } else {
            print("Incorrect.")
            print("The correct answer is", answers[number])
            iteration = iteration + 1
        }
        questions.remove(at: number)
        answers.remove(at: number)
    }
    print("You got a score of", score, "out of 5")
    if score < 3{
        print("You are not smarter than a fifth grader. Try again.")
    } else {
        print("Congratulations! You are smarter than a fifth grader!")
    }
}
game()


//Banking simulator

print("Welcome to Evan's Bank!")
print("Enter username: ")
let username = readLine() ?? ""
print("Create a password: ")
let password = readLine() ?? ""
var balance = 0.00
var stop = 0
while stop == 0 { 
    print("Select action from below by entering number")
    print(" 1. Deposit money \n 2. Withdraw money \n 3. Check balance \n 4. exit")
    let choice = Int(readLine() ?? "") ?? 4
    switch choice{
        case 1:
            print("Enter password: ")
            let attempt = readLine() ?? ""
            if attempt == password{
                print("How much would you like to depsoit:$ ")
                balance = balance + Double(readLine() ?? "0.0")!
                print("You have successfully deposited", Double(readLine()?? 0.0), "to your account. Your new balance is:$", balance)
            }
        case 2:
        print("Enter password: ")
            let attempt = readLine() ?? ""
            if attempt == password {
                print("How much would you like to withdraw: $")
                if balance == balance - Double(readLine() ?? "0.0")! > 0.00{
                    balance = balance - Double(readLine() ?? "0.0")!
                    print("You have successfully withdrawn", Double(readLine() ?? 0.0)!, "from your account. Your new balancec is:$", balance)
                } else {
                    print("Insufficent funds")
                }
            }
        case 3:
            print("Your balance is: $", balance)
        default:
            stop = 1
    }
}
"""

//Vignere cipher

var array: [Character] = []

print("Enter text: ")
let message = readLine() ?? ""
print("Enter key: ")
let key = readLine() ?? ""

var number = 0

func encrypt(){
    while number < message.count{
        let letterIndex = message.index(message.startIndex, offsetBy: number)
        let letter = message[letterIndex]
        array.append(letter)
        number += 1
    }
    number = 0
    for letter in array{
        if array[number].isUppercase{
            let first_letter = array[number].asciiValue! - 64
        }
    }
    print(first_letter)
}
func main(){
    encrypt()
}
let test = """
func unpack(message: array){
    encrypt = ""
    let letterIndex = message.index(message.startIndex, offsetBy: number)
    let letter = message[letterIndex]
}
"""
encrypt()