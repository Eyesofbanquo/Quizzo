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
  @StateObject var clipService: ClipService = ClipService()
  
  @EnvironmentObject var ockyStateManager: OckyStateManager
  
  //  @State private var authenticated: Bool = false
  
  var body: some View {
    ZStack {
      Theme.BG.ignoresSafeArea()
      
      /* Here is where you'll have the new view to select game type */
      switch ockyStateManager.currentState {
        case .menu:
          MainView()
//          OrchestratorRepresentable()
        case .multiplayer:
          MLGameAuthViewRepresentable()
        case .single:
          QuizMainView()
        case .creator:
          QuestionEditorModeView(isOffline: true)
        case .clip(let quizId):
          Group {
            if quizId == "31" {
              OrchestratorRepresentable()
            } else {
              ZStack {
                ClipView()
                  .padding(.top, 62)
                  .environmentObject(clipService)
                
                VStack {
                  HomeHeaderView
                    .fixedSize(horizontal: false, vertical: true)
                  Spacer()
                }
              }
              .onAppear {
                Task {
                  await clipService.retrieveQuiz(id: quizId)
                }
              }
            }
          }
      }
    }
  }
  
  private var HomeHeaderView: some View {
    VStack {
      HomeAccessPoint {
        ockyStateManager.send(.menu)
      }
      .padding(.top)
      Spacer()
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
