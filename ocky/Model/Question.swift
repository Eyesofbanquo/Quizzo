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
  var player: String
  var questionType: QuestionType
  
  init(name: String, choices: [Answer], player: String, questionType: QuestionType) {
    self.name = name
    self.choices = choices
    self.player = player
    self.questionType = questionType
    id = UUID()
  }
  
  init(fromResponse response: QuestionResponse) {
    self.name = response.name
    self.player = response.player ?? "Ocky App"
    self.id = UUID(uuidString: response.id) ?? UUID()
    self.questionType = QuestionType(fromValue: response.type) ?? .editing
    self.choices = response.choices.map { Answer(fromResponse: $0)}
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
             Answer(isCorrect: true, text: "Shaw")],
             player: "MLShaw",
             questionType: .multipleChoice)
  }
  
  static var editing: Question {
    Question(name: "", choices: [], player: "", questionType: .editing)
  }
}
