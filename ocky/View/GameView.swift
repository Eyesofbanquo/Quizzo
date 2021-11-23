//
//  GameView.swift
//  ocky
//
//  Created by Markim Shaw on 11/7/21.
//

import SwiftUI
import Combine
import GameKit

// the active player can only be in the playing state when they go into a match
// if there isn't any history then put it into editing mode
// if you go into a match and aren't active player then make it showing

struct GameView: View {
  @EnvironmentObject var handler: MLGame
  @State private var presentSettingsView: Bool = false

  var body: some View {
    VStack {
//      if case .idle = handler.gameState {
//        HStack {
//          Spacer()
//          Button(action: {
//            presentSettingsView.toggle()
//          }) {
//            Text("Settings")
//          }
//        }
//        .padding()
//      }
      Group {
        switch handler.gameState {
          case .idle:
            VStack {
              Button(action: {
                handler.setState(.findMatch)
              }) {
                Text("Find match")
                  .font(.largeTitle)
                  .bold()
                  .foregroundColor(.white)
                  .frame(maxWidth: .infinity, maxHeight: .infinity)
                  .background(Color.pink)
                  .padding()
              }
              Button(action: {
                handler.setState(.loadMatches)
              }) {
                Text("Load matches")
                  .font(.largeTitle)
                  .bold()
                  .foregroundColor(.white)
                  .frame(maxWidth: .infinity, maxHeight: .infinity)
                  .background(Color.green)
                  .padding()
              }
            }
            .padding(.top, 120)
            .onAppear {
              GKAccessPoint.shared.location = .topLeading
              GKAccessPoint.shared.isActive = true
            }
            .onDisappear(perform: {
              GKAccessPoint.shared.isActive = false
            })
            .transition(.move(edge: .trailing))
          case .listMatches(let mlMatches):
            MatchListView(matches: mlMatches)
              .environmentObject(handler)
              .transition(.move(edge: .trailing))
          case .inQuestion(let playState):
            
            switch playState {
              case .playing:
                Group {
                  if handler.gameData.history.isEmpty {
                    QuestionView(questionNumber: 0, question: nil, state: .editing)
                  }
                  
                  if let mostRecentQuestion = handler.gameData.history.last {
                    QuestionView(questionNumber: handler.gameData.history.count, question: mostRecentQuestion, state: playState)
                  }
                }
              case .editing:
                if let gameData = handler.gameData.history {
                  QuestionView(questionNumber: gameData.count, question: nil, state: playState)
                }
                
              case .showQuestion(let gameData, let currentParticipant):
                QuestionView(questionNumber: gameData.history.count, question: gameData.history.last, state: currentParticipant ? .playing : playState)
              case .history: EmptyView()
            }
          case .result(question: let question, answers: let answers):
            QuestionResultView(question: question, selectedAnswers: answers)
              .environmentObject(handler)
          case .winLoss(won: let won):
            WinLossView(won: won)
              .environmentObject(handler)
          case .loadMatches, .loadMatch, .findMatch:
            ProgressView()
              .progressViewStyle(CircularProgressViewStyle())
        }
      }
    }
    .sheet(isPresented: $presentSettingsView) {
      VStack {
        Text("Hi")
      }
    }

  }
  
  
  private func PlayingView() {
    
  }
  
}

struct GameView_Previews: PreviewProvider {
  static var previews: some View {
    GameView()
      .environmentObject(MLGame.stub)
  }
}

