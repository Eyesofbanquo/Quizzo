//
//  MainView.swift
//  ocky
//
//  Created by Markim Shaw on 11/21/21.
//

import SwiftUI
import Combine

struct MainView: View {
  
  // MARK: - State -
  @Binding var actions: CurrentValueSubject<MLGameAuthState, Never>
  var body: some View {
    VStack {
      Text("Ocky")
        .font(.largeTitle)
        .bold()
      Text("The quiz making game")
      Button(action: {
        actions.send(.isAuthenticating)
      }) {
        Text("Login to Game Center")
          .questionButton(isHighlighted: false)
      }
    }
  }
}

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView(actions: .constant(CurrentValueSubject<MLGameAuthState, Never>(.none)))
  }
}
