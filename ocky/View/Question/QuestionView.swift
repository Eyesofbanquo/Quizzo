//
//  QuizView.swift
//  SignsUp
//
//  Created by Markim Shaw on 11/4/21.
//

import SwiftUI
import GameKit

struct QuestionView: View {
  // MARK: - State: Environment -
  @EnvironmentObject var handler: MLGame
  
  // MARK: - State: Local -
  @StateObject private var playerManager = GKPlayerManager()
  @State private var questionName: String = ""
  @State private var displayQuizHistory: Bool = false
  @State private var question: Question?
  
  // MARK: - Properties -
  var questionViewState: QuestionViewState = .playing
  
  var questionNumber: Int {
    handler.gameData.history.count
  }
  
  var questionNameBinding: Binding<String> {
    Binding<String>(get: {
      question?.name ?? ""
    }, set: { _ in })
  }
  
  // MARK: - Init -
  init(question: Question?,
       state: QuestionViewState) {
    self._question = State.init(initialValue: question)
    self.questionViewState = state
  }
  
  // MARK: - Layout -
  var body: some View {
    GeometryReader { proxy in
      ZStack {
        VStack {
          QuestionNavigationBarView(displayQuizHistory: $displayQuizHistory,
                                    
                                    lives:  playerManager.lives(inGameData: handler.gameData, forMatch: handler.activeMatch),
                                    
                                    displayHistoryButton: handler.gameData.history.count > 0,
                                    
                                    closeButtonAction: handler.returnToPreviousState,
                                    
                                    surrenderButtonAction: {
            Task {
              try await handler.quitGame()
            }
          })
          Spacer()
          ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
              QuestionViewStaticHeader(
                matchID: String(handler.activeMatch?.matchID.prefix(4) ?? ""),
                matchStatus: handler.activeMatch?.status ?? .ended,
                currentPlayerDisplayName: handler.currentPlayer?.displayName ?? "",
                questionIndex: questionNumber,
                questionViewState: questionViewState,
                isMultipleChoice: question?.isMultipleChoice ?? false)
              
              if case .editing = questionViewState {
                QuestionViewDynamicHeader(questionName: $questionName,
                                          questionViewState: questionViewState)
              } else {
                QuestionViewDynamicHeader(questionName: questionNameBinding,
                                          questionViewState: questionViewState)
              }
            }
            .padding()
            
            
            VStack {
              Spacer()
              VStack {
                switch questionViewState {
                  case .editing:
                    QuestionViewEditingBody(questionName: $questionName)
                      .environmentObject(handler)
                  case .showQuestion:
                    QuestionViewResultsBody(choices: question?.choices ?? [])
                  case .playing:
                    QuestionViewPlayingBody(question: question)
                  default: EmptyView()
                }
              } //v-stack
              
              Spacer()
              Spacer()
              Spacer()
            }
          }
        }
        .padding()
      }
    }
    .sheet(isPresented: $displayQuizHistory) {
      QuestionHistoryListView()
        .environmentObject(handler)
    }
  }
}

struct QuizView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      QuestionView(question: .stub,
                   state: .playing)
        .environmentObject(MLGame())
      QuestionView(question: .stub,
                   state: .editing)
        .environmentObject(MLGame())
      QuestionView(question: .stub,
                   state: .showQuestion(gameData: MLGameData(), isCurrentPlayer: true))
        .environmentObject(MLGame())
    }
  }
}
