//
//  ChristmasCardView.swift
//  ocky
//
//  Created by Markim Shaw on 12/18/21.
//

import SwiftUI
import Orchestrator

struct ChristmasCardView: View, OrchestratableSwiftUI {
  @State var localOrchestratorDelegate: OrchestratorDelegate?
  @StateObject var gen: FeedbackGenerator = FeedbackGenerator()
  
  init(orchestratorDelegate: OrchestratorDelegate?) {
    self._localOrchestratorDelegate = State.init(wrappedValue: orchestratorDelegate)
  }
  
  @State private var animateHeader: Bool = false
  @State private var animateBody: Bool = false
  @State private var animateFooter: Bool = false
  
  var body: some View {
    ScrollView {
      HStack {
        VStack(alignment: .leading) {
          Text("Dear ")
            .bold() +
          Text("Kyrinne")
            .bold()
            .foregroundColor(Color(uiColor: .systemPink))
          + Text(",")
            .bold()
        }
        .opacity(animateHeader ? 1.0 : 0.0)
        .animation(.easeOut(duration: 2.0).delay(1.0), value: animateHeader)
        .font(.largeTitle)
        .padding()
        
        Spacer()
      }
      
      VStack(alignment: .leading, spacing: 16.0) {
        Group {
          Text("Christmas")
            .font(.title)
            .bold() +
          Text(" came early for me this year back in april when we decided to officially call this relationship for what it was after a month of finding new, and elaborate, ways of saying ") +
          Text("'I love you'")
            .foregroundColor(Color(uiColor: .systemPink))
            .bold() +
          Text(" both before and after your MHESU nap sessions.")
        }
        
        
        Group {
          Text("These past 8 months")
            .font(.title)
            .bold() +
          Text(" I've come to fully understand the person I've fallen in love with. There aren't any items off a list I could buy you that could accurately capture how I feel about you. I knew this months ago. Our love is unique. It can't be bought or found in a store. For it to be something that could be packaged would require it to be something most people could understand. That will never happen. Our love is our own.")
        }
        
        Group {
          Text("Love is")
            .font(.title)
            .bold() +
          Text(" a two person experience. It isn't currency. It's not a transaction. It's not a magic word to get whatever you want.") + Text(" it is an experience.").italic() + Text(" You know you're experiencing it when you realize that who you're experiencing it with is the only person who matters to you in this crazy world we're currently living.")
        }
        
        Group {
          Text("With this person you stop ")
            .font(.title)
            .bold()
        }
        HStack {
          Spacer()
          VStack(alignment: .leading) {
            Text("• Being afraid")
            Text("• Feeling uncertain")
            Text("• Doubting yourself")
            Text("• Being negative")
          }
          Spacer()
        }
        
        Text("This person makes you better. They're your everything.")
        
        
        Text("You're my everything")
          .font(.title)
          .bold() +
        Text(" and I want to be everything for you. I want to be the constant in your life that will love you unconditionally and help you become the best Kyrinne we both know you're capable of being.")
      }
      .opacity(animateBody ? 1.0 : 0.0)
      .animation(.easeOut(duration: 2.0).delay(3.0), value: animateBody)
      .padding()
      
      HStack {
        Spacer()
        VStack {
          Button(action: {
            gen.light()
            localOrchestratorDelegate?.orchestrator(playNextViewController: true)
          } ) {
            VStack {
              Image(systemName: "envelope.fill")
                .foregroundColor(Theme.Light)
                .font(.largeTitle)
              Text("Continue")
                .font(.headline)
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
        Spacer()
      }
     
    }
    .foregroundColor(Theme.Light)
    .onAppear {
      gen.warm()
      withAnimation {
        animateHeader.toggle()
        animateBody.toggle()
        animateFooter.toggle()
      }
    }
  }
}

struct ChristmasCardView_Previews: PreviewProvider {
  static var previews: some View {
    ChristmasCardView(orchestratorDelegate: nil)
      .preferredColorScheme(.dark)
  }
}
