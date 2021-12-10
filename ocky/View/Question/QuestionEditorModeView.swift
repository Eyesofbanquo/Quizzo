//
//  SelectQuestionTypeView.swift
//  ocky
//
//  Created by Markim Shaw on 12/2/21.
//

import SwiftUI

struct SelectedQuestionTypeView: View {
  @EnvironmentObject var ockyStateManager: OckyStateManager
  @Binding var didSelectQuestionType: Bool
  @Binding var selectedQuestionType: QuestionType?
  var isOffline: Bool
  
  var body: some View {
    Group {
      if isOffline {
        OfflineCreateQuestionView(questionType: selectedQuestionType!, state: .editing) {
          AnyView(HStack {
            Button(action: {
              ockyStateManager.send(.menu)
            }) {
              Image(systemName: "xmark.circle")
                .resizable()
                .frame(width: 32, height: 32)
                .foregroundColor(Theme.Light)
            }
            Spacer()
          })
        }
      } else {
        QuestionView(questionType: selectedQuestionType, state: .editing)
      }
    }
  }
}

struct QuestionEditorModeView: View {
  
  @EnvironmentObject var ockyStateManager: OckyStateManager
  @State private var didSelectQuestionType: Bool = false
  @State private var selectedQuestionType: QuestionType?
  var isOffline: Bool
  
  var body: some View {
    ZStack {
      if !didSelectQuestionType {
        SelectView
          .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
      }
      
      if didSelectQuestionType {
        SelectedQuestionTypeView(didSelectQuestionType: $didSelectQuestionType,
                                 selectedQuestionType: $selectedQuestionType,
                                 isOffline: isOffline)
          .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
      }
    }
  }
  
  var SelectView: some View {
    ZStack {
      VStack {
        if case .creator = ockyStateManager.currentState {
          HStack {
            Button(action: {
              ockyStateManager.send(.menu)
            }) {
              Image(systemName: "xmark.circle")
                .resizable()
                .frame(width: 32, height: 32)
                .foregroundColor(Theme.Light)
            }
            Spacer()
          }
          .padding(.top)
          .padding()
        }
        Spacer()
      }
      
      
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
  
}


struct QuestionEditorModeView_Previews: PreviewProvider {
  static var previews: some View {
    QuestionEditorModeView(isOffline: false)
      .preferredColorScheme(.dark)
  }
}
