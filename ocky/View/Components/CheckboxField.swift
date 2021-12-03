//
//  CheckboxField.swift
//  ocky
//
//  Created by Markim Shaw on 11/9/21.
//

import SwiftUI

struct CheckboxField: View {
  @Environment(\.colorScheme) var colorScheme

  let id: UUID
  let size: CGFloat
  let color: Color
  let textSize: Int
  let isMarkedOverride: Bool?
  let callback: (UUID, Bool) -> ()
  
  init(
    id: UUID,
    size: CGFloat = 10,
    color: Color = Theme.Light,
    textSize: Int = 14,
    isMarkedOverride: Bool? = nil,
    callback: @escaping (UUID, Bool) -> ()
  ) {
    self.id = id
    self.size = size
    self.color = color
    self.textSize = textSize
    self.callback = callback
    self.isMarkedOverride = isMarkedOverride
  }
  
  @State var isMarked: Bool = false
  
  func chooseIsMarked() -> Bool {
    if let overridden = isMarkedOverride {
      return overridden
    } else {
      return isMarked
    }
  }
  
  var body: some View {
    Button(action:{
      self.isMarked.toggle()
      self.callback(self.id, self.isMarked)
    }) {
      VStack {
        Image(systemName: chooseIsMarked() ? "checkmark.square" : "square")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 20, height: 20)
          .foregroundColor(color)
      }
    }
    .buttonStyle(PlainButtonStyle())
    .fixedSize()
  }
}

struct CheckboxField_Previews: PreviewProvider {
  static var previews: some View {
    CheckboxField(id: UUID(), callback: { strings, bools in })
      .previewLayout(.sizeThatFits)
  }
}
