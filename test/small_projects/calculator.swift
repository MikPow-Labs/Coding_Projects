import Foundation

//Calculator for two numbers WIP
enum CalcError: Error{
    case divideByZero(String)
    case invalidOperator(String)
    case invalidForm(String)
}

func calculate(_ array: [String], _ equation: String) throws -> Double{
    var array = array
    if array.count < 3 || array.count % 2 == 0{
        throw CalcError.invalidForm("Equation must be like 5 + 3 * 2")
    }
    func application(_ first: Double, _ operation: String, _ second: Double) throws -> Double{
        switch operation{
            case "+":
                return(first + second)
            case "-":
                return(first - second)
            case "*":
                return(first * second)
            case "/":
                if second != 0{
                    return(first / second)
                } else {
                    throw CalcError.divideByZero("Cannot divide by zero")
                }
            case "^":
                return(pow(first, second))
            default:
                throw CalcError.invalidOperator("Invalid operator \(operation)")
            }
    }

    let precedence: [[String]] = [
        ["^"],
        ["*", "/"],
        ["+", "-"]
    ]

    for step in precedence{
        var i = 0
        while i < array.count{
            if step.contains(array[i]){
                guard let first = Double(array[i - 1])
                else {
                    throw CalcError.invalidForm("Invalid number near operator \(array[i])")
                }
                guard let second = Double(array[i + 1])
                else{
                    throw CalcError.invalidForm("Invalid number near operator \(array[i])")
                }
                let value = try application(first, array[i], second)
                array.replaceSubrange((i - 1) ... (i + 1), with: [String(value)])
                i = 0
            } else {
            i += 1
            }
        }  
    }
    guard let result = Double(array.first ?? "")
        else{
            throw CalcError.invalidForm("Could not evaluate expression")
        }
    return(result)
}
while true{
    print("Enter your equation with a spaces (or type 'quit' to exit): ")
    let equation = readLine() ?? ""
    if equation.lowercased() == "quit"{
        print("Goodbye!")
        break
    }
    let array: Array = equation.split(separator: " ").map {String($0)}
    do{
        let result = try calculate(array, equation)
        print(equation, "=", result)
    } catch CalcError.divideByZero(let message){
        print("Error: \(message)")
    } catch CalcError.invalidForm(let message){
        print("Error: \(message)")
    } catch CalcError.invalidOperator(let message){
        print("Invalid operator at", message)
    } catch {
        print("Unexpected error: \(error)")
    }
}

