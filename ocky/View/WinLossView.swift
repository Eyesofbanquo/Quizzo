//
//  WinLossView.swift
//  ocky
//
//  Created by Markim Shaw on 11/21/21.
//

import SwiftUI

struct WinLossView: View {
  
  // MARK: - State -
  @EnvironmentObject var handler: MLGame
  @EnvironmentObject var feedbackGen: FeedbackGenerator
  
  var won: Bool
  
  var body: some View {
    ZStack {
      Theme.BG
        .ignoresSafeArea()
      
      VStack {
        if won {
          Image(systemName: "hands.clap.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding()
            .foregroundColor(Theme.LightBlue)
          Text("You won")
            .font(.largeTitle)
            .foregroundColor(Theme.Light)
        } else {
          Image(systemName: "repeat.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding()
            .foregroundColor(Theme.LightBlue)
          Text("You lost")
            .font(.largeTitle)
            .foregroundColor(.pink)
        }
        Button(action: {
          handler.setState(.idle)
        }) {
          Text("Continue")
            .questionButton(isHighlighted: false, defaultBackgroundColor: Theme.Yellow)
        }
      }
    }
    .onAppear {
      feedbackGen.light()
    }
    
  }
}

struct WinLossView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      WinLossView(won: true)
      WinLossView(won: false)
      WinLossView(won: true)
        .preferredColorScheme(.dark)
      WinLossView(won: false)
        .preferredColorScheme(.dark)
    }
    
  }
}
