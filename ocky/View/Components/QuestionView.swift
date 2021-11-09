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
  var questionNumber: Int
  var question: Question?
  var questionViewState: QuestionViewState = .playing
  @State private var selectedAnswerChoices: [UUID] = []
  @State private var questionName: String = ""
  @State private var numberOfAnswerChoices: Int = 0
  @State private var answerChoices: [Answer] = []
  @State private var submittedAnswer: Bool = false
  
  var userIsCurrentParticipant: Bool {
    GKLocalPlayer.local.displayName == currentParticipant
  }
  var currentParticipant: String {
    handler.activeMatch?.currentParticipant?.player?.displayName ?? ""
  }
  
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
          HStack {
            CloseButton()
            Spacer()
            Button(action: {
              Task {
                try await handler.quitGame()
              }
            }) {
              Text("Surrender")
                .bold()
            }
            //            Counter()
            Spacer()
            AttemptsCounter()
          }
          Spacer()
          
          HStack {
            Text(handler.activeMatch?.matchID.prefix(4) ?? "ID #")
            Spacer()
          }
          .padding(.top)
          
          ScrollView {
            VStack {
              Spacer()
              
              VStack(alignment: .leading) {
                Text("\(handler.currentPlayer?.displayName ?? "")'s turn")
                HStack {
                  Text("Question \(questionNumber + 1)")
                    .foregroundColor(Color.pink)
                  if let currentPlayer = handler.user, questionViewState == .results && !handler.isUserTurn {
                    Text(currentPlayer.correctQuestions.contains(question?.id ?? UUID()) ? "Correct" : "Incorrect" )
                  }
                  
                  if questionViewState == .playing && submittedAnswer {
                    Text(handler.isCorrect(currentQuestion: question!, usingAnswerChoices: selectedAnswerChoices) ? "Correct" : "Incorrect" )
                  }
                  Spacer()
                }
                
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
              
              VStack {
                if questionViewState == .editing {
                  ForEach(0..<answerChoices.count, id: \.self) { idx in
                    TextField(answerChoices[idx].text, text: Binding<String>(get: {
                      answerChoices[idx].text
                    }, set: { val in
                      answerChoices[idx].text = val
                    }), prompt: Text("Enter an answer choice")
                                .foregroundColor(Color.gray)
                                .font(.headline))
                      .disableAutocorrection(true)
                      .textFieldStyle(.roundedBorder)
                      .padding()
                  }
                  if answerChoices.count < 2 {
                    Text("Add \(2 - answerChoices.count) more answer choice\(2 - answerChoices.count == 1 ? "" : "s")")
                      .font(.subheadline)
                      .foregroundColor(.red)
                  }
                  Button(action: {
                    answerChoices.append(.empty)
                  }) {
                    Text("Add new answer choice")
                      .foregroundColor(.white)
                      .padding()
                      .background(RoundedRectangle(cornerRadius: 16.0))
                  }
                  Button(action: {
                    handler.appendQuestion(question: Question(name: questionName, choices: answerChoices))
                    Task {
                      try await handler.sendData()
                    }
                  } ) {
                    Text("Submit question")
                      .foregroundColor(.white)
                      .padding()
                      .background(RoundedRectangle(cornerRadius: 16.0))
                  }
                }
                if questionViewState == .results {
                  ForEach(question?.choices ?? []) { choice in
                    Text(choice.text)
                      .questionButton(isHighlighted: false)
                  }
                  HStack(spacing: 8.0) {
                    ProgressView()
                      .progressViewStyle(CircularProgressViewStyle(tint: .white))
                      .foregroundColor(.white)
                    Text("Waiting on other player")
                  }
                  .foregroundColor(Color.white)
                  .frame(maxWidth: .infinity)
                  .padding()
                  .background(RoundedRectangle(cornerRadius: 16.0)
                                .fill(Color.green)
                                .shadow(color: Color.black.opacity(0.3),
                                        radius: 10.0, x: 0, y: 10))
                  .padding()
                  
                } // editing
                if questionViewState == .playing {
                  ForEach(question?.choices ?? []) { choice in
                    Button(action: {
                      withAnimation {
                        if self.selectedAnswerChoices.contains(choice.id) == false {
                          self.selectedAnswerChoices.append(choice.id)
                          self.answerChoices.append(choice)
                        } else {
                          self.selectedAnswerChoices = self.selectedAnswerChoices.filter { $0 != choice.id}
                          self.answerChoices = self.answerChoices.filter { $0.id != choice.id}
                        }
                      }
                    }) {
                      Text(choice.text)
                        .questionButton(isHighlighted: selectedAnswerChoices.contains(choice.id))
                        .animation(.easeInOut, value: selectedAnswerChoices)
                    }
                  }
                  Button(action: {
                    if self.userIsCurrentParticipant {
                      if let question = question {
                        handler.grade(currentQuestion: question, usingAnswerChoices: answerChoices)
                        Task {
                          try await handler.sendData()
                        }
                      }
                    }
                  }) {
                    Text("Play turn")
                      .foregroundColor(.white)
                      .padding()
                      .background(RoundedRectangle(cornerRadius: 16.0))
                  }
                  .animation(.easeInOut, value: submittedAnswer)
                  .disabled(submittedAnswer)
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
  private func Background() -> some View {
    Color.yellow.opacity(0.2)
      .ignoresSafeArea()
  }
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

struct QuestionViewAnswerButtonModifier: ViewModifier {
  var isHighlighted: Bool
  func body(content: Content) -> some View {
    content
      .foregroundColor(Color.white)
      .frame(maxWidth: .infinity)
      .padding()
      .background(RoundedRectangle(cornerRadius: 16.0)
                    .fill(isHighlighted ? Color.green : Color.pink)
                    .shadow(color: Color.black.opacity(0.3),
                            radius: 10.0, x: 0, y: 10))
      .padding()
  }
}

extension Text {
  func questionButton(isHighlighted: Bool) -> some View {
    self
      .modifier(QuestionViewAnswerButtonModifier(isHighlighted: isHighlighted))
  }
  
  func questionButtonWithLoading(isHighlighted: Bool) -> some View {
    HStack {
      ProgressView()
        .progressViewStyle(CircularProgressViewStyle())
      self
        .modifier(QuestionViewAnswerButtonModifier(isHighlighted: isHighlighted))
    }
  }
}
