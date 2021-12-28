//
//  OrchestratorRepresentable.swift
//  ocky
//
//  Created by Markim Shaw on 12/16/21.
//

import Foundation
import SwiftUI
import Orchestrator

final class OrchestratorRepresentable: UIViewControllerRepresentable {
  
  var controllers: [Orchestratable] = [
    OrchestratedRepresentedController<EnvelopeView>(),
//    OrchestratedRepresentedController<LocalCountryView>(),
//    GenericOrchestratedController(delegate:
//                                    CountryView(fromLabelText: "From", countryImageName: "", toLabelText: "Country")),
//    GenericOrchestratedController(delegate:
//                                    CountryView(fromLabelText: "To", countryImageName: "", toLabelText: "Land")),
//    GenericOrchestratedController(delegate: WordScrawlView(words: ["This", "Is", "For", "The", "Love", "Of", "My", "Life", "❤️"])),
//    GenericOrchestratedController(delegate: WordScrawlView(words: ["I", "Would", "Like", "To", "Wish", "Happy", "Holidays", "To"])),
//    GenericOrchestratedController(delegate: LabelImageLabelView(header: "My", imageName: "", footer: "True Love", imageOnly: false)),
//    GenericOrchestratedController(delegate: LabelImageLabelView(header: "😅", imageName: "", footer: "", imageOnly: true)),
//    GenericOrchestratedController(delegate: LabelImageLabelView(header: "I meant...", imageName: "", footer: "Kyrinne Lockhart", imageOnly: false)),
//    GenericOrchestratedController(delegate: LabelImageLabelView(header: "❤️", imageName: "", footer: "", imageOnly: true)),
//    OrchestratedRepresentedController<ContinueEnvelopeView>(),
    OrchestratedRepresentedController<ChristmasCardView>(),
    OrchestratedRepresentedController<ChristmasSignatureView>()
  ]

  func makeUIViewController(context: Context) -> some UIViewController {
    let controller = Orchestrator(controllers: controllers)
    return controller
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    
  }
}
