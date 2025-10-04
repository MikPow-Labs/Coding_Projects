import Foundation
//Calculator for two numbers WIP

func number(prompt: String) -> Double{
    while true{
        print(prompt, terminator: "")
        if let input = readLine(), let number = Double(input) {
            return(number)
        } else {
            print("Please enter a valid number.")
        }
    }
}
let numb1 = number(prompt: "Enter your first number: ")
let numb2 = number(prompt: "Enter your second number: ")

func operation_input(prompt: String) -> String{
    let allowed: [Character] = ["+", "-", "/", "*", "^"]
    while true{
        print(prompt, terminator: "")
        if let input = readLine(), let op = input.first, allowed.contains(op){
            return (String(op))
        } else{
            print("Please enter a valid operator (+, /, -, *, ^).")
        }
    }
}

let operation = operation_input(prompt: "What operation do you want (+, /, -, *, ^): ")

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
            exit(1)
        }

    case "^":
        result = pow(numb1, numb2)
    default:
        print("Invalid operator")
}
print("Result:", result)

