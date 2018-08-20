//
//  QuestionProvider.swift
//  TrueFalseStarter
//
//  Created by Beatty Jamieson on 8/19/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation
import GameKit

struct QuestionsBank {
    var questions: [QuestionsObject] = [
        QuestionsObject(question: "Only female koalas can whistle", answer: "False"),
        QuestionsObject(question: "Blue whales are technically whales", answer: "True"),
        QuestionsObject(question: "Camels are cannibalistic", answer: "False"),
        QuestionsObject(question: "All ducks are birds", answer: "True")
        
    ]
}

func displayQuestion() {
    indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: trivia.count)
    let questionDictionary = trivia[indexOfSelectedQuestion]
    questionField.text = questionDictionary["Question"]
    playAgainButton.isHidden = true
}


