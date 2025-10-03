import Foundation
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