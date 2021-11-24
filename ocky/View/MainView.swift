//
//  MainView.swift
//  ocky
//
//  Created by Markim Shaw on 11/21/21.
//

import SwiftUI
import Combine

struct MainView: View {
  
  // MARK: - State: Env -
  @EnvironmentObject var feedbackGen: FeedbackGenerator
  
  // MARK: - Local -  
  // MARK: - State: Injected -
  @Binding var actions: CurrentValueSubject<MLGameAuthState, Never>
  
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
          
          Button(action: {
            feedbackGen.success()
            actions.send(.isAuthenticating)
          }) {
            Text("Login to Game Center")
              .questionButton(isHighlighted: false,
                              defaultBackgroundColor: Theme.LightBlue)
          }
        }
        .onAppear {
          feedbackGen.warm()
        }
      }
    }
    
    
  }
}

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView(actions: .constant(CurrentValueSubject<MLGameAuthState, Never>(.none)))
      .environmentObject(FeedbackGenerator())
  }
}
