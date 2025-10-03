func guessing_game(random: Int) -> String
{
    var message = ""
    for i in 1...6
    {
        print("Enter a guess: ")
        let guess = Int(readLine() ?? "") ?? 0
        if guess > random 
        {
            message = "TOO HIGH!"
            print(message)
        }
        else if guess < random
        {
            message = "TOO LOW!"
            print(message)
        }
        else
        {
            return "Congrats! You guessed the number in " + String(i) + " tries!"
        }
    }
    return "Aw Man! The secret number was " + String(random)
}

func to_do_list() -> String
{
    var tasks = [String]()
    while true
    {
    print("Would you like to: 1.Add Tasks 2.Remove Tasks 3.List Tasks")
    let to_do = Int(readLine() ?? "") ?? 0
    if to_do == 1
    {
        var add = "y"
        while add == "y"
        {
            print("What task would you like to add? ")
            let task = readLine() ?? ""
            tasks.append(task)
            print("Would you like to add more? (y or n) ")
            add = readLine() ?? ""
            if add != "y" && add != "n"
            {
                while add != "y" && add != "n"
                {
                    print("Not a valid input")
                    print("Would you like to add more? (y or n) ")
                    add = readLine() ?? ""
                }   
            }
        }
    }
    if to_do == 2
    {
        if tasks.count != 0
        {
            var rem = "y"
            while rem == "y"
            {
                let arrayLength = tasks.count
                print("____TO_DO_LIST____")
                for i in 0...(arrayLength - 1)
                {
                    print(String(i + 1) + ". " + tasks[i])
                }
                print("Which task would you like to remove? (Enter number) ")
                let task = Int(readLine() ?? "") ?? 0
                if task > arrayLength
                {
                    print("Not a value on the to-do list!")
                }
                else 
                {
                    tasks.remove(at: task - 1)
                    print("Would you like to remove more? (y or n) ")
                    rem = readLine() ?? ""
                    if tasks.count == 0
                    {
                        print("No tasks to remove")
                        break
                    }
                }
            }
        }
        else
        {
            print("No tasks to remove")
        }
    }
    if to_do == 3
    {
        let arrayLen = tasks.count
        if arrayLen != 0
        {
            print("____TO_DO_LIST____")
            for i in 0...(arrayLen - 1)
            {
            print(String(i + 1) + ". " + tasks[i])
            }
            break
        }
        else
        {
            print("____TO_DO_LIST____")
            print("...")
            break
        }
    }
    }
    return "End of list"
}
var random_num = Int.random(in:1...100)
//print(guessing_game(random: random_num))
print(to_do_list())