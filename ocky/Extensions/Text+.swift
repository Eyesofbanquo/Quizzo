//
//  Text+.swift
//  ocky
//
//  Created by Markim Shaw on 11/10/21.
//

import Foundation
import SwiftUI

extension Text {
  func questionButton(isHighlighted: Bool) -> some View {
    self
      .modifier(QuestionViewAnswerButtonModifier(isHighlighted: isHighlighted))
  }
  
  func questionButtonWithLoading(isHighlighted: Bool) -> some View {
    HStack {
      ProgressView()
        .progressViewStyle(CircularProgressViewStyle())
      self
        .modifier(QuestionViewAnswerButtonModifier(isHighlighted: isHighlighted))
    }
  }
}
