import Foundation

//Guessing the number game

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