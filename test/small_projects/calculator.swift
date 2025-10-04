import Foundation
//Calculator for two numbers WIP
var proceed = 0
var numb1 = 0.0
var numb2 = 0.0
var operation = ""
func transform(from ASCIIValue: Int) -> Double {
    return Double(UnicodeScalar(ASCIIValue)!)
}   
while proceed == 0{
    print("Enter your first number: ", terminator: "")
    numb1 = Double(readLine() ?? "0")!
    numb1 = transform(numb1)
    if numb1 < 47{
        print("Incorrect syntax")
    }
    else if numb1 > 57{
        print("Incorrect syntax")
    } else {
        proceed += 1
    }
}
while proceed == 1{
    print("Enter your second number: ", terminator: "")
    numb2 = Double(readLine() ?? "0")!
    numb2 = transform(numb1)
    if numb2 < 47{
        print("Incorrect syntax")
    }
    else if numb2 > 57{
        print("Incorrect syntax")
    } else {
        proceed += 1
    }
}
while proceed == 2{
    print("Enter your first number: ", terminator: "")
    numb1 = Double(readLine() ?? "0")!
    numb1 = transform(numb1)
    let allowed: [UInt8] = [42, 43, 45, 47, 94]
    if let value = numb1, !allowed.contains(value){
        print("Incorrect syntax")
    } else {
        proceed += 1
    }
}
print("What operation do you want (+, /, -, *, ^): ")
operation = readLine() ?? ""
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