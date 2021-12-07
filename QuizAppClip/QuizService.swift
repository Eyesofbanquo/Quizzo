//
//  QuizService.swift
//  QuizAppClip
//
//  Created by Markim Shaw on 12/6/21.
//

import Foundation

/// A class that handles retrieving quizzes and questions
class QuizService: ObservableObject {
  
  @Published var question: Question?
  
  lazy private var domain: String = "https://ocky-api.herokuapp.com"
  
  @MainActor
  func retrieveQuiz(id: String) async {
    let urlString = domain + "/q?id=\(id)"
    guard let url = URL(string: urlString) else { return }
    let request = URLRequest(url: url)
    
    let session = URLSession.shared
    
    do {
      let (data, _) = try await session.data(for: request, delegate: .none)
      let decodedData = try JSONDecoder().decode(OckyQuestionNetworkResponse.self, from: data)
      let questionResponse = decodedData.body.question
      let question = Question(fromResponse: questionResponse)
      self.question = question
    } catch {
      print(error)
    }
  }
}
