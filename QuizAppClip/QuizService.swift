//
//  QuizService.swift
//  QuizAppClip
//
//  Created by Markim Shaw on 12/6/21.
//

import Foundation

/// A class that handles retrieving quizzes and questions
class ClipService: ObservableObject {
  
  @Published var question: Question?
  @Published var clipState: ClipState
  
  lazy private var domain: String = "https://ocky-api.herokuapp.com"
  
  init() {
    self.question = nil
    self.clipState = .loading
  }
  
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
      self.clipState = .playing
    } catch {
      print(error)
    }
  }
  
  func gradeQuiz(selectedAnswerChoices: [Answer])  {
    guard let question = question else { 
      self.clipState = .results(passed: false)
      return
    }
    
    let setOfKnownAnswers = Set(question.correctAnswers.map { $0.id })
    let setOfAnswers = Set(selectedAnswerChoices.map { $0.id })
    
    let intersection = setOfKnownAnswers.intersection(setOfAnswers)
    
    let passed = intersection.count == setOfKnownAnswers.count
    
    self.clipState = .results(passed: passed)
  }
}
