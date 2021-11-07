//
//  MainView.swift
//  SignsUp
//
//  Created by Markim Shaw on 11/3/21.
//

import SwiftUI
import GameKit

struct SplashView: View {
  // MARK: - State -
  
  @AppStorage("signup") private var signup: Bool = false
  
  @State private var authenticated: Bool = false
  
  @State private var match: GKTurnBasedMatch? = nil
  
  var body: some View {
    if !authenticated {
      MLGameAuthViewRepresentable(authenticated: $authenticated,
                     match: $match)
    }
    
    if authenticated {
      GameViewRepresentable()
    }
  }
}

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    SplashView()
  }
}
