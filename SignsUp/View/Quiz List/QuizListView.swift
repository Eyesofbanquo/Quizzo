//
//  QuizListView.swift
//  SignsUp
//
//  Created by Markim Shaw on 11/3/21.
//

import SwiftUI

struct QuizListView: View {
  @ObservedObject var cloud: CloudManager
  @Binding var isTakingQuiz: Bool
  
  var imageSize: CGSize = CGSize(width: 16.0, height: 16.0)
  
  var body: some View {
      ZStack {
        Color.yellow.opacity(0.2)
          .ignoresSafeArea()
        
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
            
            Text("level 1")
              .foregroundColor(Color.white)
              .opacity(0.95)
            
            Text("Take your pick")
              .font(.largeTitle)
              .bold()
              .foregroundColor(Color.white)
              .padding(.bottom, 8.0)
          }
          Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(RoundedRectangle(cornerRadius: 16.0)
                      .fill(Color.red)
                      .shadow(color: Color.black.opacity(0.3), radius: 10.0, x: 0, y: 10))
        .padding()
        .onTapGesture {
          Task {
            try? await cloud.create(question: Question(name: "What is this?", choices: [Answer(isCorrect: true, text: "yes")]))
          }
        }
      }
    }
}

struct QuizListView_Previews: PreviewProvider {
  static var previews: some View {
    QuizListView(cloud: CloudManager(),
                 isTakingQuiz: .constant(true))
  }
}
