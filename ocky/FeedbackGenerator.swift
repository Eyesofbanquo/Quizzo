//
//  FeedbackGenerator.swift
//  ocky
//
//  Created by Markim Shaw on 11/24/21.
//

import Foundation
import UIKit

final class FeedbackGenerator: ObservableObject {
  let generator = UINotificationFeedbackGenerator()
  
  /// Call this to prepare the generator
  func warm() {
    generator.prepare()
  }
  
  /// An all purpose function for creating feedback
  /// - Parameter impact: The `FeedbackType` for the generator
  func impact(_ impact: UINotificationFeedbackGenerator.FeedbackType) {
    generator.notificationOccurred(impact)
  }
  
  func success() {
    impact(.success)
  }
  
  func warning() {
    impact(.warning)
  }
  
  func error() {
    impact(.error)
  }
}
