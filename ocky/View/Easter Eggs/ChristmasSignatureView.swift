//
//  ChristmasSignatureView.swift
//  ocky
//
//  Created by Markim Shaw on 12/23/21.
//

import SwiftUI
import Orchestrator

struct ChristmasSignatureView: View, OrchestratableSwiftUI {
  @State private var beginAnimation: Bool = false
  @State var localOrchestratorDelegate: OrchestratorDelegate?
  
  init(orchestratorDelegate: OrchestratorDelegate? = nil) {
    self._localOrchestratorDelegate = State.init(wrappedValue: orchestratorDelegate)
  }
  var body: some View {
    ZStack {
      Theme.BG.ignoresSafeArea()
      
        VStack(spacing: 16.0) {
          Text("So with that")
            .font(.title3)
            .bold()
            .opacity(beginAnimation ? 1.0 : 0.0)
            .animation(.easeOut(duration: 1.0).delay(0.0), value: beginAnimation)
          
          Text("This is more than a holiday card")
            .font(.title3)
            .bold()
            .opacity(beginAnimation ? 1.0 : 0.0)
            .animation(.easeOut(duration: 1.0).delay(2.5), value: beginAnimation)
          
          Text("This is my heart and my soul wrapped up into a promise")
            .font(.title3)
            .bold()
            .opacity(beginAnimation ? 1.0 : 0.0)
            .animation(.easeOut(duration: 1.0).delay(5.0), value: beginAnimation)
          
          Text("The promise that I'll always be there for you")
            .font(.title3)
            .bold()
            .opacity(beginAnimation ? 1.0 : 0.0)
            .animation(.easeOut(duration: 1.0).delay(7.5), value: beginAnimation)
          
          Text("That I'll always be yours")
            .font(.title3)
            .bold()
            .opacity(beginAnimation ? 1.0 : 0.0)
            .animation(.easeOut(duration: 1.0).delay(10.0), value: beginAnimation)
          
          Text("That I'll always love you")
            .font(.title3)
            .bold()
            .opacity(beginAnimation ? 1.0 : 0.0)
            .animation(.easeOut(duration: 1.0).delay(12.5), value: beginAnimation)
          
          Text("Don't you ever forget that")
            .font(.title3)
            .bold()
            .opacity(beginAnimation ? 1.0 : 0.0)
            .animation(.easeOut(duration: 1.0).delay(15.0), value: beginAnimation)
          
          Text("Because I never will")
            .font(.title3)
            .bold()
            .opacity(beginAnimation ? 1.0 : 0.0)
            .animation(.easeOut(duration: 1.0).delay(17.5), value: beginAnimation)
            
        }
        .padding()
        .padding()
        
      VStack {
        Spacer()
        HStack {
          Spacer()
          Text("Love, ")
            .bold()
          +
          Text("Markim")
            .foregroundColor(Color(uiColor: .systemBlue))
            .bold()
        }
        .opacity(beginAnimation ? 1.0 : 0.0)
        .animation(.easeOut(duration: 2.0).delay(20.0), value: beginAnimation)
        .font(.largeTitle)
        .padding()
      }
        
      
    }
    .foregroundColor(Theme.Light)
    .onAppear {
      withAnimation {
        beginAnimation.toggle()
      }
    }
  }
}

struct ChristmasSignatureView_Previews: PreviewProvider {
  static var previews: some View {
    ChristmasSignatureView()
  }
}
