//
//  OfflineCreateQuestionEditingInput.swift
//  ocky
//
//  Created by Markim Shaw on 12/10/21.
//

import Foundation
import SwiftUI

struct OfflineCreateQuestionEditingInput: EditingBodyInput {
  var questionName: Binding<String>
  var currentPlayer: String
  var addQuestionToHistory: (Question) -> Void
  var endTurn: () -> Void
  var questionType: Binding<QuestionType>
  
  static func generate(fromView view: OfflineCreateQuestionView) -> OfflineCreateQuestionEditingInput {
    return OfflineCreateQuestionEditingInput(questionName: view.$questionName, currentPlayer: "Anonymous Creator", addQuestionToHistory: { question in
      /* This doesn't matter */
    }, endTurn: {
      /* This is where the network call is made */
    }, questionType: view.$questionType)
  }
}
