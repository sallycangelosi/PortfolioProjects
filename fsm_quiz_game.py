print("Welcome to the FSM quiz game!")

playing = input("Do you want to play? ")

if playing.lower() != "yes":
    quit()

print("Okay! Let's play :)")
score = 0

#Question 1
answer = input("What year did Boston win its first World Series? ")
if answer.lower() == "1903":
    print('Correct!')
    score += 1
else:
    print("Incorrect!")

#Question 2
answer = input("Who was the first player in MLB history to win the Most Valuable Player, Silver Slugger, Gold Glove, batting title, and World Series in the same season? ")
if answer.lower() == "mookie betts":
    print('Correct!')
    score += 1
else:
    print("Incorrect!")

#Question 3
answer = input("Who was Jurgen Klopp's first signing, in January 2016, as Liverpool manager? ")
if answer.lower() == "marko grujic":
    print('Correct!')
    score += 1
else:
    print("Incorrect!")

#Question 4
answer = input("After trading Babe Ruth to the New York Yankees, how long did the Red Sox go without winning a World Series? ")
if answer.lower() == "86 years":
    print('Correct!')
    score += 1
else:
    print("Incorrect!")

#Question 5
answer = input("Upon the appointment of Jurgen Klopp in 2015, how many people had held the post of Liverpool manager (not counting interim managers)? ")
if answer.lower() == "20":
    print('Correct!')
    score += 1
else:
    print("Incorrect!")

print("You got " + str(score) + " questions correct!")
print("You got " + str((score/5)*100) + "%.")