//
//  MLGameState.swift
//  ocky
//
//  Created by Markim Shaw on 11/15/21.
//

import Foundation

enum MLGameState {
  case idle
  case findMatch
  case loadMatches
  case loadMatch(matchID: String)
  case listMatches(matches: [Matchable])
  case inQuestion(playState: QuestionViewState)
  case result(question: Question, answers: [Answer])
}
