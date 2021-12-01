//
//  QuestionNavigationBarView.swift
//  ocky
//
//  Created by Markim Shaw on 11/10/21.
//

import SwiftUI

struct QuestionNavigationBarView: View {
  // MARK: - State: Env -
  @EnvironmentObject var feedbackGen: FeedbackGenerator
  
  // MARK: - State: Local -
  @State private var surrender: Bool = false
  
  // MARK: - State: Injected -
  @Binding var displayQuizHistory: Bool
  
  // MARK: - Props -
  var lives: Int
  var displayHistoryButton: Bool
  var closeButtonAction:  () -> Void
  var surrenderButtonAction: () -> Void
  
  // MARK: - Init -
  
  init(displayQuizHistory: Binding<Bool>,
       lives: Int,
       displayHistoryButton: Bool,
       closeButtonAction:  @escaping () -> Void,
       surrenderButtonAction: @escaping () -> Void) {
    self._displayQuizHistory = displayQuizHistory
    self.lives = lives
    self.displayHistoryButton = displayHistoryButton
    self.closeButtonAction = closeButtonAction
    self.surrenderButtonAction = surrenderButtonAction
  }
  
  init(input: NavigationBarViewInput) {
    self.init(displayQuizHistory: input.displayQuizHistory, lives: input.lives, displayHistoryButton: input.displayHistoryButton, closeButtonAction: input.closeButtonAction, surrenderButtonAction: input.surrenderButtonAction)
  }
  
  var body: some View {
    HStack {
      CloseButton()
      Spacer()
      
      if displayHistoryButton {
        Spacer()
        Button(action: {
          /* Display history sheet */
          displayQuizHistory.toggle()
        }) {
          Text("History")
            .font(.title2)
            .bold()
            .padding(.horizontal)
            .background(RoundedRectangle(cornerRadius: 8.0).stroke(Theme.Light, lineWidth: 2.0))
        }
      }
      
      Spacer()
      HStack(spacing: 8.0) {
        Button(action: {
          surrender.toggle()
        }) {
          Image(systemName: "flag.fill")
            .font(.title)
            .foregroundColor(Theme.Red)
        }
        .alert("Do you want to surrender this game?", isPresented: $surrender) {
          Button("Yes", role: .destructive) {
            surrenderButtonAction()
          }
          Button("Cancel", role: .cancel) { }
        }
        
        AttemptsCounter()
      }
      
    }
    .foregroundColor(Theme.Light)
  }
}

struct QuestionNavigationBarView_Previews: PreviewProvider {
  static var previews: some View {
    QuestionNavigationBarView(displayQuizHistory: .constant(false),
                              lives: 3,
    displayHistoryButton: true,
                              closeButtonAction: {}, surrenderButtonAction: {})
      .environmentObject(FeedbackGenerator())
  }
}

extension QuestionNavigationBarView {
  private func CloseButton() -> some View {
    Button(action: closeButtonAction) {
      Image(systemName: "xmark.circle")
        .resizable()
        .frame(width: 32, height: 32)
    }
  }
  
  private func Counter() -> some View {
    Text("05")
      .font(.body)
      .bold()
      .padding()
      .overlay(Circle()
                .trim(from: 0.0, to: 1.0)
                .stroke(Color.gray, lineWidth: 8.0)
                .rotationEffect(.degrees(-90))
                .opacity(0.2))
      .overlay(Circle()
                .trim(from: 0.0, to: 0.4)
                .stroke(Color.black, lineWidth: 8.0)
                .rotationEffect(.degrees(-90)))
  }
  
  private func AttemptsCounter() -> some View {
    HStack(spacing: 4) {
      Image(systemName: "heart.fill")
      Text("\(lives)")
    }
    .padding(4)
    .padding(.horizontal, 6)
    .overlay(Capsule().stroke(Theme.Light, lineWidth: 2.0))
  }
}
