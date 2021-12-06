//
//  SelectQuestionTypeView.swift
//  ocky
//
//  Created by Markim Shaw on 12/2/21.
//

import SwiftUI

struct QuestionEditorModeView: View {
  
  @State private var didSelectQuestionType: Bool = false
  @State private var selectedQuestionType: QuestionType?
  
  var body: some View {
    ZStack {
      if !didSelectQuestionType {
        SelectView
          .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
      }
      
      if didSelectQuestionType {
        QuestionView(questionType: selectedQuestionType, state: .editing)
          .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
      }
    }
  }
  
  var SelectView: some View {
    VStack {
      Text("Select the question type")
        .font(.title)
        .bold()
        .foregroundColor(Theme.Light)
      
      HStack(alignment: VerticalAlignment.lastTextBaseline, spacing: 32.0) {
        ForEach(QuestionType.allCases.filter { $0 != .editing }, id: \.self) { questionType in
          Button(action: {
            withAnimation {
              selectedQuestionType = questionType
            }
          }) {
            VStack {
              Image(systemName: questionType.imageName)
                .font(.largeTitle)
                .foregroundColor(selectedQuestionType == questionType ? Theme.Yellow : Theme.Light)
              Text(questionType.stringValue)
                .font(.subheadline)
                .foregroundColor(selectedQuestionType == questionType ? Theme.Yellow : Theme.Light)
            }
          }
        }
      }
      
      if selectedQuestionType != nil {
        Button(action: {
          withAnimation {
            didSelectQuestionType = true
          }
        }) {
          Text("Continue")
            .questionButton(isHighlighted: false, defaultBackgroundColor: Theme.Yellow)
        }
      }
    }
    
  }
}


struct QuestionEditorModeView_Previews: PreviewProvider {
  static var previews: some View {
    QuestionEditorModeView()
      .preferredColorScheme(.dark)
  }
}
