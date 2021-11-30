//
//  EmilyView.swift
//  ocky
//
//  Created by Markim Shaw on 11/8/21.
//

import SwiftUI

struct EmilyView: View {
  var body: some View {
    GeometryReader { proxy in
      Image(uiImage: UIImage(named: "emily")!)
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: proxy.size.width / 2.0, height: proxy.size.width / 2.0)
        .clipped()
        .overlay(Rectangle()
                  .stroke(Color.black, lineWidth: 8)
                  .shadow(color: Color.black.opacity(0.3), radius: 10.0, x: 0, y: 10))
    }
  }
}

struct EmilyView_Previews: PreviewProvider {
  static var previews: some View {
    EmilyView()
      .previewLayout(.sizeThatFits)
  }
}
