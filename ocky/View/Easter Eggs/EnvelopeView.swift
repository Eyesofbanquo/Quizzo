//
//  EnvelopeView.swift
//  ocky
//
//  Created by Markim Shaw on 12/18/21.
//

import SwiftUI
import Orchestrator

struct EnvelopeView: View, OrchestratableSwiftUI {
  @State var localOrchestratorDelegate: OrchestratorDelegate?
  @StateObject var gen: FeedbackGenerator = FeedbackGenerator()
  
  init(orchestratorDelegate: OrchestratorDelegate?) {
    self._localOrchestratorDelegate = State.init(wrappedValue: orchestratorDelegate)
  }
  
  var body: some View {
    VStack {
      Button(action: {
        gen.light()
        localOrchestratorDelegate?.orchestrator(playNextViewController: true)
      } ) {
        VStack {
          Image(systemName: "envelope.fill")
            .foregroundColor(Theme.Light)
            .font(.largeTitle)
          Text("Open Your Christmas Card ❤️")
            .font(.largeTitle)
            .bold()
            .foregroundColor(Theme.Light)
          Text("Tap envelope...")
            .font(.subheadline)
            .foregroundColor(Theme.Light)
            .italic()
            .opacity(0.5)
        }
      }
    }
    .onAppear(perform: {
      gen.warm()
    })
    .padding()
  }
}

struct ContinueEnvelopeView: View, OrchestratableSwiftUI {
  @State var localOrchestratorDelegate: OrchestratorDelegate?
  
  init(orchestratorDelegate: OrchestratorDelegate?) {
    self._localOrchestratorDelegate = State.init(wrappedValue: orchestratorDelegate)
  }
  
  var body: some View {
    VStack {
      Button(action: {
        localOrchestratorDelegate?.orchestrator(playNextViewController: true)
      } ) {
        VStack {
          Image(systemName: "envelope.fill")
            .foregroundColor(Theme.Light)
            .font(.largeTitle)
          Text("Continue ❤️")
            .font(.largeTitle)
            .bold()
            .foregroundColor(Theme.Light)
          Text("Tap envelope...")
            .font(.subheadline)
            .foregroundColor(Theme.Light)
            .italic()
            .opacity(0.5)
        }
      }
    }
    .padding()
  }
}

struct EnvelopeView_Previews: PreviewProvider {
  static var previews: some View {
    EnvelopeView(orchestratorDelegate: nil)
      .preferredColorScheme(.dark)
  }
}
