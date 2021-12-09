//
//  MainView.swift
//  ocky
//
//  Created by Markim Shaw on 11/21/21.
//

import SwiftUI
import Combine
import StoreKit

struct MainView: View {
  
  // MARK: - State: Env -
  @EnvironmentObject var feedbackGen: FeedbackGenerator
  
  @EnvironmentObject var ockyStateManager: OckyStateManager
  
  // MARK: - Local -
  // MARK: - State: Injected -
  //  @Binding var actions: CurrentValueSubject<MLGameAuthState, Never>
  
  var body: some View {
    GeometryReader { proxy in
      ZStack {
        Theme.BG
          .ignoresSafeArea()
        VStack {
          
          Image(uiImage: .init(named: "logo")!)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding()
          
          Text("Ocky")
            .foregroundColor(.white)
            .font(.largeTitle)
            .bold()
          
          Text("The quiz making game")
            .foregroundColor(.white)
          
          #if APPCLIP
          VStack {
            AppClipButton
              .padding(.bottom)
              .padding(.bottom)
              .onAppear {
                guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                let config = SKOverlay.AppClipConfiguration(position: .bottom)
                let overlay = SKOverlay(configuration: config)
                overlay.present(in: scene)
              }
          }
          #else
          
          VStack {
          #if DEBUG
            SinglePlayerButton
          #endif
            MultiplayerButton
          }
          #endif
        }
        .onAppear {
          feedbackGen.warm()
        }
      }
    }
    
    
  }
  
  private var SinglePlayerButton: some View {
    Button(action: {
      feedbackGen.success()
      ockyStateManager.send(.single)
    }) {
      Text("Single Player Quiz Mode")
        .questionButton(isHighlighted: false,
                        defaultBackgroundColor: Theme.LightBlue)
    }
  }
  
  private var MultiplayerButton: some View {
    Button(action: {
      feedbackGen.success()
      ockyStateManager.send(.multiplayer)
    }) {
      Text("Login to Game Center")
        .questionButton(isHighlighted: false,
                        defaultBackgroundColor: Theme.LightBlue)
    }
  }
  
  private var AppClipButton: some View {
    Button(action: {
      feedbackGen.success()
    }) {
      Text("Welcome to Ocky")
        .questionButton(isHighlighted: false,
                        defaultBackgroundColor: Theme.LightBlue)
    }
  }
}

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
      .environmentObject(FeedbackGenerator())
      .environmentObject(OckyStateManager())
  }
}
