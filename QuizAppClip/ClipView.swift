//
//  ContentView.swift
//  QuizAppClip
//
//  Created by Markim Shaw on 12/6/21.
//

import SwiftUI
import StoreKit

enum ClipState {
  case playing, loading, marketing
  case results(passed: Bool)
}

struct ClipView: View {
  @EnvironmentObject var clipService: ClipService
    
  var presentingAppStoreOverlay: Binding<Bool> {
    Binding<Bool>(get: {
      #if APPCLIP
      return true
      #else
      return false
      #endif
    }, set: { _ in
      
    })
  }
  
  func resultText(_ isCorrect: Bool) -> String {
    if isCorrect {
      return "You got it right!"
    } else {
      return "Incorrect"
    }
    
  }
  
  
  
  func resultImage(_ isCorrect: Bool) -> Image {
    if isCorrect {
      return Image(systemName: "checkmark.circle.fill")
    } else {
      return Image(systemName: "xmark.circle.fill")
    }
  }
  
  var body: some View {
    ZStack {
      Group {
        switch clipService.clipState {
          case .loading:
            VStack(spacing: 16.0) {
              ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .tint(Theme.Light)
                .scaleEffect(x: 1.5, y: 1.5)
              Text("Retrieving your Question Clip...")
                .font(.headline)
                .foregroundColor(Theme.Light)
            }
          case .playing:
            if let question = clipService.question {
              OfflineQuestionView(question: question)
            } else {
              Text("Unable to load quiz. Please try again")
                .foregroundColor(Theme.Light)
            }
          case .results(let passed):
            VStack {
              Spacer()
              resultImage(passed)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(0.80)
                .foregroundColor(passed ? Theme.LightGreen : .pink)
              Text(resultText(passed))
                .font(.largeTitle)
                .foregroundColor(Theme.Light)
              Text("Thanks For Playing")
                .questionButton(isHighlighted: false, defaultBackgroundColor: Theme.Yellow)
              Spacer()
            }
          case .marketing:
            MainView()
              .environmentObject(FeedbackGenerator())
              .environmentObject(OckyStateManager())
              .appStoreOverlay(isPresented: presentingAppStoreOverlay) {
                SKOverlay.AppClipConfiguration(position: .bottom)
              }
        }
      }
    }
    
    
  }
  
  
}

struct ClipView_Previews: PreviewProvider {
  static var previews: some View {
    ClipView()
      .environmentObject(ClipService())
  }
}
