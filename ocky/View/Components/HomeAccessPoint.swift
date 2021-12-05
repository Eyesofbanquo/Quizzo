//
//  HomeAccessPoint.swift
//  ocky
//
//  Created by Markim Shaw on 12/5/21.
//

import SwiftUI

struct HomeAccessPoint: View {
  var returnToMainView: () -> Void
  
  var body: some View {
    Button(action: {
      returnToMainView()
    } ) {
      Image(systemName: "house.fill")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 44, height: 44)
        .foregroundColor(Theme.Yellow)
    }
  }
}

struct HomeAccessPoint_Previews: PreviewProvider {
  static var previews: some View {
    HomeAccessPoint(returnToMainView: {})
      .previewLayout(.sizeThatFits)
      .preferredColorScheme(.dark)
  }
}
