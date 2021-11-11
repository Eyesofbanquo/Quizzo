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
  case results
}

struct QuestionView: View {
  @EnvironmentObject var handler: MLGame
  @State private var questionName: String = ""

  var questionNumber: Int
  var question: Question?
  var questionViewState: QuestionViewState = .playing

  
  init(questionNumber: Int,
       question: Question?,
       state: QuestionViewState) {
    self.questionNumber = questionNumber
    self.question = question
    self.questionViewState = state
  }
  
  var body: some View {
    GeometryReader { proxy in
      ZStack {
        VStack {
          QuestionNavigationBarView()
            .environmentObject(handler)
          Spacer()
          VStack(alignment: .leading) {
            QuestionViewHeader(
              matchID: String(handler.activeMatch?.matchID.prefix(4) ?? ""),
              matchStatus: handler.activeMatch?.status ?? .ended,
              currentPlayerDisplayName: handler.currentPlayer?.displayName ?? "",
              questionIndex: questionNumber,
              questionViewState: questionViewState)
            
            if questionViewState == .editing {
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
          
          ScrollView {
            VStack {
              Spacer()
              VStack {
                if questionViewState == .editing {
                  QuestionViewEditingBody()
                    .environmentObject(handler)
                }
                if questionViewState == .results {
                  QuestionViewResultsBody(choices: question?.choices ?? [])
                }
                if questionViewState == .playing {
                  QuestionViewPlayingBody(question: question)
                } // playing
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
                   state: .results)
        .environmentObject(MLGame())
    }
  }
}

extension QuestionView {
  private func CloseButton() -> some View {
    Button(action: {
      switch handler.previousGameState {
        case .loadMatch:
          Task {
            try await handler.loadMatches()
          }
        case .findMatch, .playing:
          handler.setState(.idle)
        default: break
      }
    }) {
      Image(systemName: "xmark.circle")
        .resizable()
        .frame(width: 32, height: 32)
    }
  }
  
  private func Counter() -> some View {
    Text("05")
      .font(.body)
      .bold()
      .padding()
      .overlay(Circle()
                .trim(from: 0.0, to: 1.0)
                .stroke(Color.gray, lineWidth: 8.0)
                .rotationEffect(.degrees(-90))
                .opacity(0.2))
      .overlay(Circle()
                .trim(from: 0.0, to: 0.4)
                .stroke(Color.black, lineWidth: 8.0)
                .rotationEffect(.degrees(-90)))
  }
  
  private func AttemptsCounter() -> some View {
    HStack(spacing: 4) {
      Image(systemName: "heart.fill")
      Text("3")
    }
    .padding(4)
    .padding(.horizontal, 6)
    .overlay(Capsule().stroke(Color.black, lineWidth: 1.0))
  }
}
