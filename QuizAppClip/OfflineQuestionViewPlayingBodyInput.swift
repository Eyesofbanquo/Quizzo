//
//  OfflineQuestionViewPlayingBodyInput.swift
//  QuizAppClip
//
//  Created by Markim Shaw on 12/6/21.
//

import Foundation

struct OfflineQuestionViewPlayingBodyInput: PlayingBodyInput {
  var question: Question?
  
  var playTurnAction: (Question?, [Answer]) -> Void
  
  static func generate(fromView view: OfflineQuestionView) -> OfflineQuestionViewPlayingBodyInput {
    return OfflineQuestionViewPlayingBodyInput(question: view.question) { question, selectedAnserChoices in
      view.grade(withAnswers: selectedAnserChoices)
    }
  }
  
  
}
