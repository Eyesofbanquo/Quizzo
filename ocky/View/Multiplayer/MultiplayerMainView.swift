//
//  MultiplayerMainView.swift
//  ocky
//
//  Created by Markim Shaw on 11/29/21.
//

import SwiftUI

struct MultiplayerMainView: View {
  // MARK: - State: Env -
  @EnvironmentObject var handler: MLGame

  var body: some View {
    VStack {
      Spacer()
      FindMatchButton()
      LoadMatchesButton()
      Spacer()
    }
    .modifier(GKAccessPointModifier())
  }
}

struct MultiplayerMainView_Previews: PreviewProvider {
  static var previews: some View {
    MultiplayerMainView()
      .environmentObject(MLGame())
  }
}

extension MultiplayerMainView {
  func FindMatchButton() -> some View {
    Button(action: {
      handler.setState(.findMatch)
    }) {
      Text("Find match")
        .font(.largeTitle)
        .bold()
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(RoundedRectangle(cornerRadius: 16.0).fill(Theme.DarkBlue))
        .padding()
    }
  }
  
  func LoadMatchesButton() -> some View {
    Button(action: {
      handler.setState(.loadMatches)
    }) {
      Text("Load matches")
        .font(.largeTitle)
        .bold()
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(RoundedRectangle(cornerRadius: 16.0).fill(Theme.DarkGreen))
        .padding()
    }
  }
}


