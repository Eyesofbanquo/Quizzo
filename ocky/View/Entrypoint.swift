//
//  MainView.swift
//  SignsUp
//
//  Created by Markim Shaw on 11/3/21.
//

import SwiftUI
import GameKit

struct Entrypoint: View {
  // MARK: - State -
  
  @AppStorage("signup") private var signup: Bool = false
  @AppStorage("firstLaunch") private var firstLaunch: Bool = true
  
  @EnvironmentObject var ockyStateManager: OckyStateManager
  
//  @State private var authenticated: Bool = false
  
  var body: some View {
    ZStack {
      Theme.BG.ignoresSafeArea()
      
      /* Here is where you'll have the new view to select game type */
      switch ockyStateManager.currentState {
        case .menu:
          MainView()
        case .multiplayer:
          MLGameAuthViewRepresentable()
        case .single:
          QuizMainView()
      }
    }
  }
}

struct Entrypoint_Previews: PreviewProvider {
  static var previews: some View {
    Entrypoint()
      .environmentObject(OckyStateManager())
      .environmentObject(FeedbackGenerator())
  }
}
