//
//  Data.swift
//  ocky
//
//  Created by Markim Shaw on 11/10/21.
//

import SwiftUI

struct Datum: View {
  var title: String
  var metric: String
  var subtitle: String
  var imageName: String
  var tint: Color
  var body: some View {
    GroupBox(label: HStack {
      Image(systemName: imageName)
      Text(title)
    }
              .foregroundColor(tint), content: {
      HStack(alignment: .firstTextBaseline, spacing: 4.0) {
        Text(metric)
          .font(.title)
          .bold()
          .foregroundColor(Color(.label))
        Text(subtitle)
          .font(.body)
          .foregroundColor(Color(.lightGray))
        Spacer()
      }
      .padding(.top)
    })
  }
}

struct Data_Previews: PreviewProvider {
  static var previews: some View {
    Datum(title: "Question", metric: "Something", subtitle: "Here", imageName: "checkmark", tint: .black)
      .previewLayout(.sizeThatFits)
  }
}
