import Foundation

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
                var amount = Double(readLine() ?? "0.0") ?? 0.0
                balance = balance + amount
                print("You have successfully deposited",amount,"to your account. Your new balance is:$",balance)
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
            }
        case 3:
            print("Your balance is: $", balance)
        default:
            stop = 1
    }
}
