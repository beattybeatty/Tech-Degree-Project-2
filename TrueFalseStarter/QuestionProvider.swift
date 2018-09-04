//
//  QuestionProvider.swift
//  TrueFalseStarter
//
//  Created by Beatty Jamieson on 8/19/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation
import GameKit

struct QuestionsObject {
    var question: String
    var answers: [String]
    var correctAnswer: Int
}

// Can you have 'correctAnswer' pull index from answer, rather than me retyping a string of what the answer should be?
struct QuestionsBank {
    var questions: [QuestionsObject] = [
        QuestionsObject(question: "This was the only US President to serve more than two consecutive terms.", answers: ["George Washington", "Franklin D. Roosevelt", "Woodrow Wilson", "Andrew Jackson"], correctAnswer: 2),
        QuestionsObject(question: "Which of the following countries has the most residents?", answers: ["Nigeria", "Russia", "Iran", "Vietnam"], correctAnswer: 2),
        QuestionsObject(question: "In what year was the United Nations Founded?", answers: ["1918", "1919", "1945", "1954"], correctAnswer: 3),
        QuestionsObject(question: "The Titanic departed from the United Kingdom, where was it supposed to arrive?", answers: ["Paris", "Washington D.C", "New York City", "Boston"], correctAnswer: 3),
        QuestionsObject(question: "Which nation produces the most oil?", answers: ["Iran", "Iraq", "Brazil", "Canada"], correctAnswer: 4),
        QuestionsObject(question: "Which country has most recently won consecutive World Cups in Soccer?", answers: ["Italy", "Brazil", "Argentina", "Spain"], correctAnswer: 2),
        QuestionsObject(question: "Which of the following rivers is longest?", answers: ["Yangtze", "Mississippi", "Congo", "Mekong"], correctAnswer: 2),
        QuestionsObject(question: "Which city is the oldest?", answers: ["Mexico City", "Cape Town", "San Juan", "Sydney"], correctAnswer: 1),
        QuestionsObject(question: "Which country was the first to allow women to vote in national elections?", answers: ["Poland", "United States", "Sweden", "Senegal"], correctAnswer: 1),
        QuestionsObject(question: "Which of these countries won the most medals in the 2012 Summer Games?", answers: ["France", "Germany", "Japan", "Great Britan"], correctAnswer: 4)
    ]
    
    func randomFact() -> String {
        let randomNumber = GKRandomSource.sharedRandom().nextInt(upperBound: questions.count)
        return questions[randomNumber]
    }

}


