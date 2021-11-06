//
//  InvalidTextModifier.swift
//  SignsUp
//
//  Created by Markim Shaw on 11/3/21.
//

import Foundation
import SwiftUI

struct InvalidTextFieldModifier: ViewModifier {
  var condition: Bool
  func body(content: Content) -> some View {
    content
      .overlay(
        RoundedRectangle(cornerRadius: 8.0)
                  .stroke(condition == false ? Color.red : Color.gray, lineWidth: 1.0))
  }
}
