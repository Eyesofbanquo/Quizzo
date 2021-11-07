//
//  InputModifier.swift
//  SignsUp
//
//  Created by Markim Shaw on 11/3/21.
//

import SwiftUI

struct InputModifier: ViewModifier{
  func body(content: Content) -> some View {
    content
      .padding()
      .textFieldStyle(RoundedBorderTextFieldStyle())
  }
}

struct InputModifier_Previews: PreviewProvider {
  struct Preview: View {
    @State private var text: String = ""
    var body: some View {
      TextField("Test", text: $text)
    }
  }
  static var previews: some View {
    Preview()
      .modifier(InputModifier())
      .previewLayout(.sizeThatFits)
  }
}
