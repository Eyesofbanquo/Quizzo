//
//  MLGameAuthView.swift
//  ocky
//
//  Created by Markim Shaw on 11/7/21.
//

import Combine
import SwiftUI

struct MLGameAuthView: View {
  @State private var receivedAction: MLGameAuthState = .none
  @Binding var authenticated: Bool
  var actions: CurrentValueSubject<MLGameAuthState, Never>
  
  var body: some View {
    Group {
      switch receivedAction {
        case .none:
          VStack {
            Button(action: {
              actions.send(.isAuthenticating)
            }) {
              Text("Login to Game Center")
            }
          }
        case .isAuthenticating:
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
        case .isAuthenticated:
          Button(action: {
            authenticated = true
          }) {
            Text("Start game")
          }
      }
    }
    .onReceive(actions) { output in
      self.receivedAction = output
      print("Received from SwiftUI")
    }
  }
}

struct MLGameAuthView_Previews: PreviewProvider {
  static var previews: some View {
    MLGameAuthView(authenticated: .constant(false),
                   actions: CurrentValueSubject<MLGameAuthState, Never>(.none))
  }
}
