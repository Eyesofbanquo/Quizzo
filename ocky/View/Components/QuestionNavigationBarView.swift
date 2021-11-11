//
//  QuestionNavigationBarView.swift
//  ocky
//
//  Created by Markim Shaw on 11/10/21.
//

import SwiftUI

struct QuestionNavigationBarView: View {
  @EnvironmentObject var handler: MLGame
  
  var body: some View {
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
      Spacer()
      AttemptsCounter()
    }
  }
}

struct QuestionNavigationBarView_Previews: PreviewProvider {
  static var previews: some View {
    QuestionNavigationBarView()
  }
}

extension QuestionNavigationBarView {
  private func CloseButton() -> some View {
    Button(action: {
      switch handler.previousGameState {
        case .loadMatch:
          Task {
            try await handler.loadMatches()
          }
        case .findMatch, .playing, .updateLives:
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
