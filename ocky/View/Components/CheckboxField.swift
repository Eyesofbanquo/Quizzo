//
//  CheckboxField.swift
//  ocky
//
//  Created by Markim Shaw on 11/9/21.
//

import SwiftUI

struct CheckboxField: View {
  let id: UUID
  let size: CGFloat
  let color: Color
  let textSize: Int
  let callback: (UUID, Bool) -> ()
  
  init(
    id: UUID,
    size: CGFloat = 10,
    color: Color = Color(uiColor: .label).opacity(0.68),
    textSize: Int = 14,
    callback: @escaping (UUID, Bool) -> ()
  ) {
    self.id = id
    self.size = size
    self.color = color
    self.textSize = textSize
    self.callback = callback
  }
  
  @State var isMarked:Bool = false
  
  var body: some View {
    Button(action:{
      self.isMarked.toggle()
      self.callback(self.id, self.isMarked)
    }) {
      HStack(alignment: .center, spacing: 10) {
        Image(systemName: self.isMarked ? "checkmark.square" : "square")
          .renderingMode(.original)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 20, height: 20)
      }.foregroundColor(self.color)
    }
    .buttonStyle(PlainButtonStyle())
    .foregroundColor(Color.white)
    .fixedSize()
  }
}

struct CheckboxField_Previews: PreviewProvider {
  static var previews: some View {
    CheckboxField(id: UUID(), callback: { strings, bools in })
      .previewLayout(.sizeThatFits)
  }
}
