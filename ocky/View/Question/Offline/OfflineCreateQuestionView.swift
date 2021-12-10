//
//  OfflineCreateQuestionView.swift
//  ocky
//
//  Created by Markim Shaw on 12/10/21.
//

import Foundation
import SwiftUI

struct OfflineCreateQuestionView: View {
  @State var questionName: String = ""
  @State var questionType: QuestionType = .editing
  @State fileprivate var question: Question?
  
  var CloseButton: AnyView

  
  init(questionType: QuestionType,
       state: QuestionViewState,
       @ViewBuilder closeButton:  () -> AnyView) {
    self._questionType = State(initialValue: questionType)
    self.CloseButton = closeButton()
  }
  
  var body: some View {
    ZStack {
      Theme.BG.ignoresSafeArea()
      VStack {
        CloseButton
          .padding(.horizontal)
          .padding(.top)
        
        
        ScrollView {
          VStack {
            VStack(alignment: .leading) {
              HStack {
                Text("Create a Question")
                  .font(.title)
                  .bold()
                Spacer()
              }
              
              Text("This will be added to the Ocky DB.")
                .font(.headline)
                .foregroundColor(Theme.Light)
              
              HStack {
                Group {
                  Image(systemName: questionType.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                }
                .frame(width: 24, height: 24)
                .foregroundColor(Theme.Light)
                
                Text("\(questionType.stringValue.capitalized)")
                  .font(.subheadline)
                  .foregroundColor(Theme.Light)
                Spacer()
              }
            }
            .foregroundColor(Theme.Light)
            QuestionViewDynamicHeader(questionName: $questionName,
                                      questionViewState: .editing)
            QuestionViewEditingBody(input: OfflineCreateQuestionEditingInput.generate(fromView: self))
          }
        }
        .padding()
      }
    }
  }
}
