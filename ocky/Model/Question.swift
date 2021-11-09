//
//  Quiz.swift
//  SignsUp
//
//  Created by Markim Shaw on 11/4/21.
//

import Foundation

struct Question: Codable, Identifiable {
  var id: UUID
  var name: String
  var choices: [Answer]
  
  init(name: String, choices: [Answer]) {
    self.name = name
    self.choices = choices
    id = UUID()
  }
  
  var correctAnswers: [Answer] {
    choices.filter { $0.isCorrect }
  }
}

extension Question {
  static var stub: Question {
    Question(name: "What is my name?",
             choices: [
             Answer(isCorrect: false, text: "Markim"),
             Answer(isCorrect: true, text: "Shaw")])
  }
}
