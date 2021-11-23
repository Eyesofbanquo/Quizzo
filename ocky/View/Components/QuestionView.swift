//
//  QuizView.swift
//  SignsUp
//
//  Created by Markim Shaw on 11/4/21.
//

import SwiftUI
import GameKit

enum QuestionViewState {
  case editing
  case playing
  case showQuestion(gameData: MLGameData, isCurrentPlayer: Bool)
}

struct QuestionView: View {
  // MARK: - State: Environment -
  @EnvironmentObject var handler: MLGame
  
  // MARK: - State: Local -
  @State private var questionName: String = ""
  @State private var displayQuizHistory: Bool = false
  @State private var question: Question?
  
  // MARK: - Properties -
  var questionNumber: Int
  var questionViewState: QuestionViewState = .playing
  
  // MARK: - Init -
  init(questionNumber: Int,
       question: Question?,
       state: QuestionViewState) {
    self.questionNumber = questionNumber
    self._question = State.init(initialValue: question)
    self.questionViewState = state
  }
  
  // MARK: - Layout -
  var body: some View {
    GeometryReader { proxy in
      ZStack {
        VStack {
          QuestionNavigationBarView(displayQuizHistory: $displayQuizHistory)
            .environmentObject(handler)
          Spacer()
          ScrollView {
            VStack(alignment: .leading) {
              QuestionViewHeader(
                matchID: String(handler.activeMatch?.matchID.prefix(4) ?? ""),
                matchStatus: handler.activeMatch?.status ?? .ended,
                currentPlayerDisplayName: handler.currentPlayer?.displayName ?? "",
                questionIndex: questionNumber,
                questionViewState: questionViewState)
              
              if case .editing = questionViewState {
                TextField("", text: $questionName, prompt: Text("Enter a question"))
                  .disableAutocorrection(true)
                  .textFieldStyle(.roundedBorder)
                  .font(.largeTitle)
                  .foregroundColor(Color.pink)
                  .fixedSize(horizontal: false, vertical: true)
                  .scaledToFit()
              } else {
                Text(question?.name ?? "")
                  .font(.largeTitle)
                  .bold()
                  .foregroundColor(Color.pink)
                  .fixedSize(horizontal: false, vertical: true)
                  .scaledToFit()
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
      QuestionView(questionNumber: 1,
                   question: .stub,
                   state: .playing)
        .environmentObject(MLGame())
      QuestionView(questionNumber: 1,
                   question: .stub,
                   state: .editing)
        .environmentObject(MLGame())
      QuestionView(questionNumber: 1,
                   question: .stub,
                   state: .showQuestion(gameData: MLGameData(), isCurrentPlayer: true))
        .environmentObject(MLGame())
    }
  }
}
