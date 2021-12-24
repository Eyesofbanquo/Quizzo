//
//  LocalCountryView.swift
//  ocky
//
//  Created by Markim Shaw on 12/23/21.
//

import SwiftUI
import Orchestrator

struct LocalCountryView: View, OrchestratableSwiftUI {
  @State var localOrchestratorDelegate: OrchestratorDelegate?
  
  init(orchestratorDelegate: OrchestratorDelegate?) {
    self._localOrchestratorDelegate = State.init(wrappedValue: orchestratorDelegate)
  }
  
  @State var beginAnimation: Bool = false
  
  var body: some View {
    ZStack {
      Theme.BG.ignoresSafeArea()
      
      VStack {
        HStack {
          Text("From the country that brought you this...")
          Spacer()
        }
        .scaleEffect(beginAnimation ? 1.0 : 0.1)
        .animation(.interpolatingSpring(mass: 1, stiffness: 100, damping: 10, initialVelocity: 0), value: beginAnimation)
        
        Spacer()
        
        HStack {
          Spacer()
          Text("Hello, World!")
        }
        .layoutPriority(1.0)
        .scaleEffect(beginAnimation ? 1.0 : 0.1)
        .animation(.interpolatingSpring(mass: 1, stiffness: 100, damping: 10, initialVelocity: 0).delay(1.0), value: beginAnimation)
      }
      .padding()
      .padding()
      .foregroundColor(Theme.Light)
    }
    .onAppear {
      withAnimation {
        beginAnimation.toggle()
      }
    }
  }
}

struct LocalCountryView_Previews: PreviewProvider {
  static var previews: some View {
    LocalCountryView(orchestratorDelegate: nil)
  }
}
