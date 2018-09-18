//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

/*
 CHECK - The starter files contain a Storyboard scene that is simulated to a 4.7 inch iPhone without any constraints to position elements. If you run the app in the simulator for a 5.5 inch iPhone, the layout looks fine but it breaks on any other device size. Convert the Storyboard back to a universal scene and add constraints to maintain the layout such all UI elements are sized and spaced appropriately for all iPhones of screen sizes 4.7 and 5.5. inches.
 - Refactor the existing code such that individual questions are modeled using a class or struct
    * will need to be created in new file called something like "question provider".
        CHECK * There you will need to import gamekit and foundation.
        CHECK * will need to make struct for question object and question bank.
        CHECK * will need to make function for question to display, answers to display, and correct answer display
        CHECK * will need to change references from trivia to new struct
 CHECK - Ensure that code adheres to the MVC pattern. Please place your new custom data structure for questions in a new Swift file.
 CHECK - Enhance the quiz so it can accommodate four answer choices for each question, as shown in the mockups and sample question set.
 - Add functionality such that during each game, questions are chosen at random, though no question will be repeated within a single game.
 
 - Implement a feature so that the app can neatly display a mix of 3-option questions as well as 4-option questions. Inactive buttons should be spaced or resized appropriately, not simply hidden, disabled, or marked as unused (e.g. with the string ‘N/A’). You need to implement this feature using only one view controller.
 - Implement a way to appropriately display the correct answer, when a player answers incorrectly.
 - Modify the app to be in "lightning" mode where users only have 15 seconds to select an answer for each question set. Display the number of correct answers at the end of the quiz.
 - Add two sound effects, one for correct answers and one for incorrect. You may also add sounds at the end of the game, or wherever else you see fit. (Hint: you can base your solution on code already found in the starter app.)
 */

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {
    
    let questionsPerRound = 4
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion: Int = 0
    var correctAnswerIndex = 0
    var questionsBank = QuestionsBank()
    var correctAnswer = ""
    
    var gameSound: SystemSoundID = 0
    
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var answerButton01: UIButton!
    @IBOutlet weak var answerButton02: UIButton!
    @IBOutlet weak var answerButton03: UIButton!
    @IBOutlet weak var answerButton04: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadGameStartSound()
        // Start game
        playGameStartSound()
        displayQuestion()
        displayAnswers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
/* commenting out, writing new func below
 
    func displayQuestion() {
        indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: trivia.count)
        let questionDictionary = trivia[indexOfSelectedQuestion]
        questionField.text = questionDictionary["Question"]
        playAgainButton.isHidden = true
    }
 
*/
    
// from sumon0002016
    func displayQuestion() {
        indexOfSelectedQuestion = questionsBank.randomNumber()
        let question = questionsBank.questionToDisplay(from: indexOfSelectedQuestion)
        questionField.text = question
        playAgainButton.isHidden = true
        
       // showAnswers()
    }
 
    func displayAnswers() {
        let answer = questionsBank.answersToDisplay(from: indexOfSelectedQuestion)
        if answer.count == 4 {
            answerButton01.setTitle(answer[0], for: .normal)
            answerButton02.setTitle(answer[1], for: .normal)
            answerButton03.setTitle(answer[2], for: .normal)
            answerButton04.setTitle(answer[3], for: .normal)
        }
    }
    
    func displayScore() {
        // Hide the answer buttons
        answerButton01.isHidden = true
        answerButton02.isHidden = true
        answerButton03.isHidden = true
        answerButton04.isHidden = true
        
        
        // Display play again button
        playAgainButton.isHidden = false
        
        if correctQuestions == 4 {
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        } else {
            questionsField.text = "Way to go!\nYou got\(correctQuestions) out of\(questionsPerRound) correct!"
        }
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        // Increment the questions asked counter
        questionsAsked += 1
        
        correctAnswer = questionsBank.correctAnswerToDisplay(from: indexOfSelectedQuestion)
        
        if (sender === answerButton01 &&  answerButton01.titleLabel?.text == correctAnswer) ||
            (sender === answerButton02 &&  answerButton02.titleLabel?.text == correctAnswer) ||
            (sender === answerButton03 &&  answerButton03.titleLabel?.text == correctAnswer) ||
            (sender === answerButton03 &&  answerButton03.titleLabel?.text == correctAnswer) ||
        
        {
            correctQuestions += 1
            questionField.text = "Correct!"
        } else {
            questionField.text = "Sorry, wrong answer!"
        }
        
        loadNextRoundWithDelay(seconds: 2)
        usedQuestion()
        disableWrongAns(sender)
    }
    
    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestion()
        }
    }
    
    @IBAction func playAgain() {
        // Show the answer buttons
        answerButton01.isHidden = false
        answerButton02.isHidden = false
        answerButton03.isHidden = false
        answerButton04.isHidden = false
        
        questionsAsked = 0
        correctQuestions = 0
        nextRound()
        resetQuestions()
    }
    
    func usedQuestions() {
        questionsBank.questions.append(contentsOf: questionsBank.questionAlreadyAsked)
        questionsBank.questionAlreadyAsked.removeAll()
    }
    
    func resetQuestions() {
        questionsBank.questions.append(contenctsOf: questionsBank.questionsAlreadyAsked)
        questionsBank.questionAlreadyAsked.removeAll()
    }
    
    @IBAction func disableWrongAns(_ sender: UIButton) {
        let answerButtons = [answerButton01, answerButton02, answerButton03, answerButton04]
        
        for button in buttons {
            button?.isEnabled = false
            button?.alpha = 0.1
        }
        
        for selectedButton in answerButtons {
            if sender == selectedButton {
                selectedButton?.alpha = 1.0
            }
        }
    }
    
    func showAnswer() {
        // Enable buttons
        answerButton01.isEnabled = true
        answerButton02.isEnabled = true
        answerButton03.isEnabled = true
        answerButton04.isEnabled = true
        
        // Makes buttons visible
        answerButton01.alpha = 1.0
        answerButton02.alpha = 1.0
        answerButton03.alpha = 1.0
        answerButton04.alpha = 1.0
    }
    
    // MARK: Helper Methods
    
    func loadNextRoundWithDelay(seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.nextRound()
        }
    }
    
    func loadGameStartSound() {
        let pathToSoundFile = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &gameSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
}

