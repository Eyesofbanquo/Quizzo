//
//  MatchView.swift
//  ocky
//
//  Created by Markim Shaw on 11/7/21.
//

import SwiftUI
import GameKit

struct MatchView: View {
  private var match: MLMatch
  private var imageSize: CGSize = CGSize(width: 16.0, height: 16.0)
  
  init(match: MLMatch) {
    self.match = match
  }
  
  var matchViewText: String {
    if match.currentParticipant.isEmpty {
      return "Searching for match..."
    } else {
      return GKLocalPlayer.local.displayName == match.currentParticipant ? "It's your turn now" : "It's \(match.currentParticipant)'s turn"
    }
    
  }
  
  var body: some View {
    HStack {
      VStack(alignment: .leading,
             spacing: 8.0) {
        Image(systemName: "play.circle")
          .resizable()
          .frame(width: imageSize.width,
                 height: imageSize.height)
          .overlay(Circle()
                    .stroke(Color.white, lineWidth: 2.0)
                    .frame(width: imageSize.width * 2.0, height: imageSize.height * 2.0))
          .offset(x: imageSize.width / 2.0)
          .padding(.bottom, 8.0)
          .padding(.top, 8.0)
          .foregroundColor(Color.white)
        
        Text("ID #\(match.matchID)")
          .foregroundColor(Color.white)
          .opacity(0.95)
        
        Text(matchViewText)
          .font(.largeTitle)
          .bold()
          .foregroundColor(Color.white)
          .padding(.bottom, 8.0)
          .fixedSize(horizontal: false, vertical: true)
      }
      Spacer()
    }
    .frame(maxWidth: .infinity)
    .padding()
    .background(RoundedRectangle(cornerRadius: 16.0)
                  .fill(Color.red)
                  .shadow(color: Color.black.opacity(0.3), radius: 10.0, x: 0, y: 10))
    .padding()
  }
}

struct MatchView_Previews: PreviewProvider {
  static var previews: some View {
    MatchView(match: .stub)
      .previewLayout(.sizeThatFits)
  }
}
