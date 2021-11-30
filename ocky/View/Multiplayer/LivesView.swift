//
//  LivesView.swift
//  ocky
//
//  Created by Markim Shaw on 11/10/21.
//

import SwiftUI

struct LivesView: View {
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var handler: MLGame
  @EnvironmentObject var feedbackGen: FeedbackGenerator
  var correctQuestion: Bool
  
  @State private var currentLife: Int = 0
  @State private var displayContinueButton: Bool = false
  @State private var displayLostButton: Bool = false
  
  static var totalLives: Int = 3
  
  var body: some View {
    ZStack {
      Theme.BG.ignoresSafeArea()
      
      VStack {
        Image(systemName: "heart")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .opacity(0.5)
          .scaleEffect(0.80)
          .background(
            Image(systemName: "heart.fill")
              .resizable()
              .aspectRatio(contentMode: .fill)
              .foregroundColor(Theme.LightGreen)
              .scaleEffect(0.80 * CGFloat(currentLife) / CGFloat(LivesView.totalLives))
              .animation(.easeInOut(duration: 0.3), value: currentLife))
        Button(action: {
          Task {
            try await handler.endgame()
            /* Send user to win/loss screen. pass in lives */
            handler.setState(.winLoss(won: false))
            presentationMode.wrappedValue.dismiss()
          }
        }) {
          Text("Final results")
            .questionButton(isHighlighted: false, defaultBackgroundColor: Theme.Yellow)
        }
        .opacity(displayLostButton ? 1.0 : 0.0)
        .animation(.easeIn(duration: 0.4).delay(0.4), value: displayLostButton)
        
        
        Button(action: {
          handler.setState(.inQuestion(playState: .editing))
          presentationMode.wrappedValue.dismiss()
        }) {
          Text("Play your turn")
            .questionButton(isHighlighted: false, defaultBackgroundColor: Theme.Yellow)
        }
        .opacity(displayContinueButton ? 1.0 : 0.0)
        .animation(.easeIn(duration: 0.4).delay(0.4), value: displayContinueButton)
        
      }
    }
    .onAppear {
      currentLife = handler.user?.lives ?? 0

      Task {
        await Task.sleep(1)
        feedbackGen.light()
        withAnimation {
          if !correctQuestion {
            currentLife -= 1
          }
        }
        withAnimation {
          if currentLife == 0 {
            displayLostButton = true
          } else {
            displayContinueButton = true
          }
        }
        feedbackGen.light()
      }
    }
  }
}

struct LivesView_Previews: PreviewProvider {
  static var previews: some View {
    LivesView(correctQuestion: false)
      .environmentObject(MLGame())
      .environmentObject(FeedbackGenerator())
  }
}
