//
//  QuestionViewDynamicHeader.swift
//  ocky
//
//  Created by Markim Shaw on 11/29/21.
//

import SwiftUI

struct QuestionViewDynamicHeader: View {
  // MARK: - State: Local -
  @Binding var questionName: String
  
  // MARK: - Inject -
  var questionViewState: QuestionViewState
  
  var body: some View {
    VStack(alignment: .leading) {
      if case .editing = questionViewState {
        TextField("", text: $questionName, prompt: Text("Enter a question"))
          .disableAutocorrection(false)
          .textFieldStyle(.roundedBorder)
          .font(.largeTitle)
          .fixedSize(horizontal: false, vertical: true)
          .scaledToFit()
      } else {
        Text(questionName)
          .font(.largeTitle)
          .bold()
          .fixedSize(horizontal: false, vertical: true)
          .scaledToFit()
          .foregroundColor(Theme.Yellow)
      }
    }
  }
}

struct QuestionViewDynamicHeader_Previews: PreviewProvider {
  static var previews: some View {
    QuestionViewDynamicHeader(questionName: .constant("Question 123"), questionViewState: .editing)
  }
}
