//
//  QuestionViewCoordinator.swift
//  ocky
//
//  Created by Markim Shaw on 11/29/21.
//

import SwiftUI

struct QuestionViewCoordinator: View {
  // MARK: - State: Env
  @EnvironmentObject var handler: MLGame
  
  // MARK: - Inject
  var questionViewState: QuestionViewState
  
  var body: some View {
    Group {
      switch questionViewState {
        case .playing:
          Group {
            if let mostRecentQuestion = handler.gameData.history.last {
              QuestionView(question: mostRecentQuestion, state: questionViewState)
            } else {
              QuestionView(state: .editing)
            }
          }
        case .editing:
          QuestionEditorModeView()
        case .showQuestion(let gameData, let currentParticipant):
          QuestionView(question: gameData.history.last, state: currentParticipant ? .playing : questionViewState)
        case .history: EmptyView()
      }
    }
    
  }
}


struct QuestionViewCoordinator_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      QuestionViewCoordinator(questionViewState: .editing)
        .environmentObject(MLGame())
      QuestionViewCoordinator(questionViewState: .playing)
        .environmentObject(MLGame())
    }
    
  }
}
