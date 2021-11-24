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
  
  @State private var authenticated: Bool = false
  
  @State private var match: GKTurnBasedMatch? = nil
  
  @StateObject private var feedbackGen: FeedbackGenerator = FeedbackGenerator()
  
  var body: some View {
    ZStack {
      Theme.BG.ignoresSafeArea()
      
      if !authenticated {
        MLGameAuthViewRepresentable(authenticated: $authenticated,
                                    match: $match)
          .environmentObject(feedbackGen)
      }
      
      if authenticated {
        GameViewRepresentable()
          .environmentObject(feedbackGen)
      }
    }
    
  }
}

struct Entrypoint_Previews: PreviewProvider {
  static var previews: some View {
    Entrypoint()
  }
}
