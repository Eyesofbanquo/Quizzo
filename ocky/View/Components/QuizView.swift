//
//  QuizView.swift
//  SignsUp
//
//  Created by Markim Shaw on 11/4/21.
//

import SwiftUI

struct QuizView: View {
  var body: some View {
    GeometryReader { proxy in
      ZStack {
        Background()
        VStack {
          HStack {
            CloseButton()
            Spacer()
            Counter()
            Spacer()
            AttemptsCounter()
          }
          Spacer()
          
          ScrollView {
            VStack {
              Spacer()
              Image(uiImage: UIImage(named: "emily")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: proxy.size.width / 2.0, height: proxy.size.width / 2.0)
                .clipped()
                .overlay(Rectangle()
                          .stroke(Color.black, lineWidth: 8)
                          .shadow(color: Color.black.opacity(0.3), radius: 10.0, x: 0, y: 10))
              
              VStack(alignment: .leading) {
                Text("Question 1")
                  .foregroundColor(Color.pink)
                Text("How many times did I cum to Emily today? 😈")
                  .font(.largeTitle)
                  .bold()
                  .foregroundColor(Color.pink)
                  .fixedSize(horizontal: false, vertical: true)
                
              }
              .padding()
              
              VStack {
                Text("1x")
                  .foregroundColor(Color.white)
                  .frame(maxWidth: .infinity)
                  .padding()
                  .background(RoundedRectangle(cornerRadius: 16.0)
                                .fill(Color.pink)
                                .shadow(color: Color.black.opacity(0.3), radius: 10.0, x: 0, y: 10))
                  .padding()
                
                Text("5x")
                  .foregroundColor(Color.white)
                  .frame(maxWidth: .infinity)
                  .padding()
                  .background(RoundedRectangle(cornerRadius: 16.0)
                                .fill(Color.pink)
                                .shadow(color: Color.black.opacity(0.3), radius: 10.0, x: 0, y: 10))
                  .padding()
                
                Text("10x")
                  .foregroundColor(Color.blue)
                  .frame(maxWidth: .infinity)
                  .padding()
                  .background(RoundedRectangle(cornerRadius: 16.0)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.3), radius: 10.0, x: 0, y: 10))
                  .padding()
              }
              
              Spacer()
              Spacer()
              Spacer()
            }
          }
        }
        .padding()
      }
    }
  }
}

struct QuizView_Previews: PreviewProvider {
  static var previews: some View {
    QuizView()
  }
}

extension QuizView {
  private func Background() -> some View {
    Color.yellow.opacity(0.2)
      .ignoresSafeArea()
  }
  private func CloseButton() -> some View {
    Image(systemName: "xmark.circle")
      .resizable()
      .frame(width: 32, height: 32)
  }
  
  private func Counter() -> some View {
    Text("05")
      .font(.body)
      .bold()
      .padding()
      .overlay(Circle()
                .trim(from: 0.0, to: 1.0)
                .stroke(Color.gray, lineWidth: 8.0)
                .rotationEffect(.degrees(-90))
                .opacity(0.2))
      .overlay(Circle()
                .trim(from: 0.0, to: 0.4)
                .stroke(Color.black, lineWidth: 8.0)
                .rotationEffect(.degrees(-90)))
  }
  
  private func AttemptsCounter() -> some View {
    HStack(spacing: 4) {
      Image(systemName: "heart.fill")
      Text("3")
    }
    .padding(4)
    .padding(.horizontal, 6)
    .overlay(Capsule().stroke(Color.black, lineWidth: 1.0))
  }
}
