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
        * will need to make function for question to display, answers to display, and correct answer display
        * will need to change references from trivia to new struct
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
    
    var gameSound: SystemSoundID = 0
    
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var falseButton: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadGameStartSound()
        // Start game
        playGameStartSound()
        displayQuestion()
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
        let question = questionToDisplay(from: indexOfSelectedQuestion)
        questionField.text = question
        playAgainButton.isHidden = true
    }
 
    func displayScore() {
        // Hide the answer buttons
        trueButton.isHidden = true
        falseButton.isHidden = true
        
        // Display play again button
        playAgainButton.isHidden = false
        
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        // Increment the questions asked counter
        questionsAsked += 1
        
        let selectedQuestionDict = QuestionsBank[QuestionsObject]
        let correctAnswer = selectedQuestionDict["Answer"]
        
        if (sender === trueButton &&  correctAnswer == "True") || (sender === falseButton && correctAnswer == "False") {
            correctQuestions += 1
            questionField.text = "Correct!"
        } else {
            questionField.text = "Sorry, wrong answer!"
        }
        
        loadNextRoundWithDelay(seconds: 2)
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
        trueButton.isHidden = false
        falseButton.isHidden = false
        
        questionsAsked = 0
        correctQuestions = 0
        nextRound()
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

