//
//  QuestionNavigationBarView.swift
//  ocky
//
//  Created by Markim Shaw on 11/10/21.
//

import SwiftUI

struct QuestionNavigationBarView: View {
  // MARK: - State: Environment -
  @EnvironmentObject var handler: MLGame
  
  // MARK: - State: Local -
  @StateObject private var playerManager = GKPlayerManager()
  @State private var surrender: Bool = false
  
  // MARK: - State: Injected -
  @Binding var displayQuizHistory: Bool
  
  var lives: Int {
    playerManager.lives(inGameData: handler.gameData, forMatch: handler.activeMatch)
  }
  
  var body: some View {
    HStack {
      CloseButton()
      Spacer()
      
      if handler.gameData.history.count > 0 {
        Spacer()
        Button(action: {
          /* Display history sheet */
          displayQuizHistory.toggle()
        }) {
          Text("History")
            .font(.title2)
            .bold()
        }
      }
      
      Spacer()
      HStack(spacing: 8.0) {
        Button(action: {
          surrender.toggle()
        }) {
          Image(systemName: "flag.fill")
            .font(.title)
            .foregroundColor(Theme.Red)
        }
        .alert("Do you want to surrender this game?", isPresented: $surrender) {
          Button("Yes", role: .destructive) {
            Task {
              try await handler.quitGame()
            }
          }
          Button("Cancel", role: .cancel) { }
        }
        
        AttemptsCounter()
      }
      
    }
    .foregroundColor(Theme.Light)
  }
}

struct QuestionNavigationBarView_Previews: PreviewProvider {
  static var previews: some View {
    QuestionNavigationBarView(displayQuizHistory: .constant(false))
      .environmentObject(MLGame())
  }
}

extension QuestionNavigationBarView {
  private func CloseButton() -> some View {
    Button(action: {
      // save the progress if you're in playing/editing state
      // handler.saveProgressIfNeeded()
      handler.returnToPreviousState()
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
      Text("\(lives)")
    }
    .padding(4)
    .padding(.horizontal, 6)
    .overlay(Capsule().stroke(Theme.Light, lineWidth: 1.0))
  }
}
