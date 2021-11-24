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
  @State var actions: CurrentValueSubject<MLGameAuthState, Never>
  
  var body: some View {
    Group {
      switch receivedAction {
        case .none:
          MainView(actions: $actions)
        case .isAuthenticating:
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .init(uiColor: .label)))
            .scaleEffect(2.0)
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
