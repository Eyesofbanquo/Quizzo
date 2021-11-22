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
  
  var won: Bool
  
  var body: some View {
    VStack {
      if won {
         Image(systemName: "hands.clap.fill")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .padding()
        Text("You won")
          .font(.largeTitle)
      } else {
        Image(systemName: "repeat.circle.fill")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .padding()
        Text("You lost")
          .font(.largeTitle)
      }
      Button(action: {
        handler.setState(.idle)
      }) {
        Text("Continue")
          .questionButton(isHighlighted: false)
      }
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
