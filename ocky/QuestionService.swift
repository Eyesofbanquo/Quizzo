//
//  QuestionService.swift
//  ocky
//
//  Created by Markim Shaw on 11/16/21.
//

import Foundation

class QuestionService: ObservableObject {
  
  /* Place in grader/question service */
  func appendQuestion(question: Question, inGame gameData: inout MLGameData) {
    gameData.history.append(question)
  }
  
  /* Place in grader/question service */
  func isCorrect(currentQuestion question: Question, usingAnswerChoices choices: [Answer]) -> Bool {
    let correctAnswers = Set(question.correctAnswers)
    let userAnswers = Set(choices)
    let isCorrect = correctAnswers.intersection(userAnswers).count == correctAnswers.count
    return isCorrect
  }
  
  /* Place in grader/question service */
  func isCorrect(currentQuestion question: Question, usingAnswerChoices choices: [UUID]) -> Bool {
    let correctAnswers = Set(question.correctAnswers.map { $0.id })
    let userAnswers = Set(choices)
    let isCorrect = correctAnswers.intersection(userAnswers).count == correctAnswers.count
    return isCorrect
  }
  
  /* Place in grader/question service */
  func grade(currentQuestion question: Question,
             usingAnswerChoices choices: [Answer],
             forPlayer player: inout MLPlayer) {
    if isCorrect(currentQuestion: question, usingAnswerChoices: choices) {
//      let player = gameData.players.first(where: { $0.displayName == GKLocalPlayer.local.displayName })
      player.addCorrectQuestion(id: question.id)
    }
  }
  
}
