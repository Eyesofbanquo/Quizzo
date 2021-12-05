//
//  MLGameAuthView.swift
//  ocky
//
//  Created by Markim Shaw on 11/7/21.
//

import Combine
import SwiftUI

struct MLGameAuthView: View {
  @Binding var state: MLGameAuthState
  
  var body: some View {
    ZStack {
      Theme.BG
        .ignoresSafeArea()
      Group {
        switch state {
          case .isAuthenticating:
            ProgressView()
              .progressViewStyle(CircularProgressViewStyle(tint: Theme.Light))
              .scaleEffect(2.0)
          case .inGame: GameViewRepresentable()
          default: EmptyView()
        }
      }
    }
  }
}

struct MLGameAuthView_Previews: PreviewProvider {
  static var previews: some View {
    MLGameAuthView(state: .constant(.none))
  }
}
