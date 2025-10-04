import Foundation

print("Input the number of the project you wish to run: \n(1) Input Print \n(2) Guess the number \n(3) Caesar Cipher \n(4) Are you smarter than a fifth grader? \n(5) Banking Simulator \n(6) Calculator")
let program = readLine() ?? ""
switch program{
    case "1":
        inputs()
    case "2":
        guess()
    case "3":
        cipher()
    case "4":
        quiz()
    case "5":
        banking()
    case "6":
        calculator()
    default:
        print("Invalid input")
}

//Prints full name from inputs
func inputs() {
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
}

//Guessing the number game
func guess() {
    let number = Int.random(in: 1..<100)
    var number_guess = 0
    var correct = 0
    while number_guess < 6{
        print("Guess a number between 1 and 100: ", terminator: "")
        let guess = Int(readLine() ?? "") ?? 0
        if guess == number{
            print("Congradulations! You guessed the number!")
            correct += 1
        } else if guess > number{
            print("Too high")
        } else if guess < number{
            print("Too low")
        } else {
            print("Invalid input")
        }
        number_guess = number_guess + 1
    }
    if correct == 0{
        print("The correct answer was:", number)
    }
}

//Caesar cipher
func cipher() {
    func caesar_cipher_encrypt(message: String, shift: Int) -> String{
        var new_message = ""
        let new_shift = (shift % 26 + 26) % 26
        for char in message{
            if let ascii = char.asciiValue{
                var shifted: UInt8
                if ascii >= 65 && ascii <= 90{
                    shifted = ((ascii - 65 + UInt8(new_shift)) % 26) + 65
                    new_message.append(Character(UnicodeScalar(shifted))) 
                } else if ascii >= 97 && ascii <= 122{
                    shifted = ((ascii - 97 + UInt8(new_shift)) % 26) + 97
                    new_message.append(Character(UnicodeScalar(shifted)))
                } else {
                    new_message.append(char)
                }
            }
        }
        return(new_message)
    }

    func caesar_cipher_decrypt(message: String, shift: Int) -> String{
        var new_message = ""
        let new_shift = (shift % 26 + 26) % 26
        for char in message{
            if let ascii = char.asciiValue{
                var shifted: UInt8
                if ascii >= 65 && ascii <= 90{
                    shifted = ((ascii - 65 - UInt8(new_shift)) % 26) + 65
                    new_message.append(Character(UnicodeScalar(shifted))) 
                } else if ascii >= 97 && ascii <= 122{
                    shifted = ((ascii - 97 - UInt8(new_shift)) % 26) + 97
                    new_message.append(Character(UnicodeScalar(shifted)))
                } else {
                    new_message.append(char)
                }
            }
        }
        return(new_message)
    }

    func main(){
        print("Do you wish to Encrypt(E) or Decrypt(D) a function? (E/D):")
        let method = readLine() ?? ""
        print("Enter shift value: ")
        let shift = Int(readLine() ?? "0") ?? 0
        if method == "E"{
            print("Enter the message you want to encrypt: ")
            let message = readLine() ?? ""
            let encrypted = caesar_cipher_encrypt(message: message, shift: shift)
            print("Encrypted message: \(encrypted)")
        } else if method == "D"{
            print("Enter the message you want to decrypt: ")
            let message = readLine() ?? ""
            let decrypted = caesar_cipher_decrypt(message: message, shift: shift)
            print("Decrypted message: \(decrypted)")
        }
    }
    main()
}

//Are you smarter than a fifth grader
func quiz() {
    var score = 0
    print("Welcome to are you smarter than a fifth grader?")
    print("Get ready to answer some questions!")
    var questions = ["What is the capital of New York?", "What is the capital of Japan?", "Who was the 16th president of the United States?", "What is the largest land animal?", "Which country is closest to the Great Barrier Reef? "]
    var answers = ["albany", "tokyo", "abraham lincoln", "elephant", "australia"]
    var iteration = 0
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
}

//Banking simulator
func banking() {
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
                    let amount = Double(readLine() ?? "0.0") ?? 0.0
                    balance = balance + amount
                    print("You have successfully deposited",amount,"to your account. Your new balance is:$",balance)
                } else {
                    print("Incorrect password")
                }
            case 2:
            print("Enter password: ")
                let attempt = readLine() ?? ""
                if attempt == password {
                    print("How much would you like to withdraw: $")
                    if let amount = Double(readLine() ?? "0.0"){
                        if balance - amount > 0.0{
                            balance -= amount
                            print("You have successfully withdrawn",amount, "from your account. Your new balancec is:$",balance)
                        } else {
                            print("Insufficent funds")
                        }
                    }
                } else {
                    print("Incorrect password")
                }
            case 3:
                print("Your balance is: $", balance)
            default:
                stop = 1
        }
    }
}
func calculator(){
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
}