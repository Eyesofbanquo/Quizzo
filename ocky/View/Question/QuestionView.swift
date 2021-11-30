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
  @EnvironmentObject var questionService: QuestionService
  
  // MARK: - State: Local -
  @StateObject fileprivate var playerManager = GKPlayerManager()
  @State fileprivate var questionName: String = ""
  @State fileprivate var displayQuizHistory: Bool = false
  @State fileprivate var question: Question?
  
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
          QuestionNavigationBarView(input: QuestionNavigationBarViewInput.generate(fromView: self))
          
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
                    QuestionViewEditingBody(input: QuestionViewEditingBodyInput.generate(fromView: self))
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
    .environmentObject(QuestionService())
  }
}
protocol NavigationBarViewInput {
  var displayQuizHistory: Binding<Bool> { get set }
  var lives: Int { get set  }
  var displayHistoryButton: Bool { get set }
  var closeButtonAction:  () -> Void { get set }
  var surrenderButtonAction: () -> Void { get set }
}

protocol EditingBodyInput {
  associatedtype T = View
  associatedtype U = Self
  var questionName: Binding<String> { get set }
  var currentPlayer: String { get set }
  var addQuestionToHistory: (Question) -> Void { get set }
  var endTurn: () -> Void { get set }
  
  static func generate(fromView view: T) -> U
}

extension QuestionView {
  struct QuestionNavigationBarViewInput: NavigationBarViewInput {
    var displayQuizHistory: Binding<Bool>
    var lives: Int
    var displayHistoryButton: Bool
    var closeButtonAction:  () -> Void
    var surrenderButtonAction: () -> Void
    
    static func generate(fromView view: QuestionView) -> NavigationBarViewInput {
      return QuestionNavigationBarViewInput(displayQuizHistory: view.$displayQuizHistory,
                                            lives: view.playerManager.lives(inGameData: view.handler.gameData,
                                                                            
                                                                            forMatch: view.handler.activeMatch),
                                            
                                            displayHistoryButton: view.handler.gameData.history.count > 0,
                                            
                                            closeButtonAction: view.handler.returnToPreviousState) {
        Task {
          try await view.handler.quitGame()
        }
      }
    }
  }
  
  struct QuestionViewEditingBodyInput: EditingBodyInput {
    var questionName: Binding<String>
    var currentPlayer: String
    var addQuestionToHistory: (Question) -> Void
    var endTurn: () -> Void
    
    static func generate(fromView view: QuestionView) -> QuestionViewEditingBodyInput {
      return QuestionViewEditingBodyInput(questionName: view.$questionName, currentPlayer: view.handler.user?.displayName ?? "", addQuestionToHistory: { question in
        view.questionService.appendQuestion(question: question, inGame: &view.handler.gameData)
      }, endTurn: {
        Task {
          try await view.handler.sendData()
          await view.handler.setState(.inQuestion(playState: .showQuestion(gameData: view.handler.gameData, isCurrentPlayer: false)))
        }
      })
    }
  }
}
