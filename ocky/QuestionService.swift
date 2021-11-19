//
//  QuestionService.swift
//  ocky
//
//  Created by Markim Shaw on 11/16/21.
//

import Foundation
import RealmSwift
import GameKit

class QuestionService: ObservableObject {
  
  let realm = try! Realm()
  
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
             forPlayer player: MLPlayer,
             andGame game: GKTurnBasedMatch?) {
    guard let matchID = game?.matchID else { return }
    
    let playerRO = realm.objects(PlayerRO.self).filter { $0.matchID == matchID }.first
    if playerRO == nil {
      try! realm.write {
        let pRO = PlayerRO(matchID: matchID, correctQuestionID: nil, updatedLives: player.lives)
        realm.add(pRO)
      }
    }
      
    let editablePlayerRO = realm.objects(PlayerRO.self).filter { $0.matchID == matchID }.first

    /* Send player info to realm on grade */
    if isCorrect(currentQuestion: question, usingAnswerChoices: choices) {
      try! realm.write {
        editablePlayerRO?.matchID = question.id.uuidString
      }
//      player.addCorrectQuestion(id: question.id)
    } else {
      guard player.lives > 0 else { return }
      let lives = player.lives - 1
      try! realm.write {
        editablePlayerRO?.updatedLives = lives
      }
    }
  }
  
}
