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
    ZStack {
      Theme.BG
        .ignoresSafeArea()
      Group {
        switch receivedAction {
          case .none:
            /* True entry view point of the app. This MainView could have the option to play either solo or multiplayer. */
            MainView(actions: $actions)
          case .isAuthenticating:
            ProgressView()
              .progressViewStyle(CircularProgressViewStyle(tint: Theme.Light))
              .scaleEffect(2.0)
          default: EmptyView()
        }
      }
      .onReceive(actions) { output in
        self.receivedAction = output
        print("Received from SwiftUI")
      }
    }
    
  }
}

struct MLGameAuthView_Previews: PreviewProvider {
  static var previews: some View {
    MLGameAuthView(authenticated: .constant(false),
                   actions: CurrentValueSubject<MLGameAuthState, Never>(.none))
  }
}
