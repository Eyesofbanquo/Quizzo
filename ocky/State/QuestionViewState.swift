//
//  QuestionViewState.swift
//  ocky
//
//  Created by Markim Shaw on 11/29/21.
//

import Foundation

/// The view state for `Question`. This view can only be in 1 of 3 states at a time.
enum QuestionViewState {
  case editing
  case playing
  case showQuestion(gameData: MLGameData, isCurrentPlayer: Bool)
  case history
}
