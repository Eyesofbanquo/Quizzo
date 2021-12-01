//
//  NewQuestionView.swift
//  ocky
//
//  Created by Markim Shaw on 12/1/21.
//

import SwiftUI

struct NewQuestionView<A: AbstractNavigationBarVew>: View {
  
  var navBar: AnyView?
  
  init(@ViewBuilder navBar: () -> A? = { nil }) {
    self.navBar = navBar()?.anyBody
  }
  var body: some View {
    VStack {
      if navBar != nil {
        navBar!
      }
      Text("Hi")
    }
  }
}

struct NewQuestionView_Previews: PreviewProvider {
  static var previews: some View {
    let view: NewQuestionView = NewQuestionView<QuestionNavigationBarView> {
      QuestionNavigationBarView(displayQuizHistory: .constant(false), lives: 2, displayHistoryButton: true, closeButtonAction: {}, surrenderButtonAction: {})
    }
    return view
      .preferredColorScheme(.dark)
  }
}
