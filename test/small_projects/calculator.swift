import Foundation

//Calculator for two numbers WIP
enum CalcError: Error{
    case divideByZero(String)
    case invalidOperator(String)
    case invalidForm(String)
}

func calculate(array: [String], equation: String) throws -> Double{
    if array.count < 3 || array.count % 2 == 0{
        throw CalcError.invalidForm("Equation must be like 5 + 3 * 2")
    }
    guard var result = Double(array[0]) else {
        throw CalcError.invalidForm("First value is not a valid number")
    }

    var index = 1

    while index < array.count {
        let subject = array[index]
        guard let next_index = Double(array[index + 1]) else {
            throw CalcError.invalidOperator("Invalid value \(array[index + 1])")
        }
        switch subject{
            case "+":
                result += next_index
            case "-":
                result -= next_index
            case "*":
                result *= next_index
            case "/":
                if next_index != 0{
                    result /= next_index
                } else {
                    throw CalcError.divideByZero("Cannot divide by zero")
                }
            case "^":
                result = pow(result, next_index)
            default:
                throw CalcError.invalidOperator("Invalid operator \(array[index])")
        }
        index += 2
    }
    return(result)
}

print("Enter your equation with a space inbetween operators (5 + 3 * 2): ")
let equation = readLine() ?? ""
let array: Array = equation.split(separator: " ").map {String($0)}

do{
    let result = try calculate(array: array, equation: equation)
    print("Result:", result)
} catch CalcError.divideByZero(let message){
    print("Error: \(message)")
} catch CalcError.invalidForm(let message){
    print("Error: \(message)")
} catch CalcError.invalidOperator(let message){
    print("Invalid operator at", message)
}

