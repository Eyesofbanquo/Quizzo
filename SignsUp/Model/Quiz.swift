//
//  Quiz.swift
//  SignsUp
//
//  Created by Markim Shaw on 11/4/21.
//

import Foundation

struct Question {
  var name: String
  var choices: [Answer]
  
  var correctAnswers: [Answer] {
    choices.filter { $0.isCorrect }
  }
}
