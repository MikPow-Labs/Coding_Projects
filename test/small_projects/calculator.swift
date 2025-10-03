import Foundation
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