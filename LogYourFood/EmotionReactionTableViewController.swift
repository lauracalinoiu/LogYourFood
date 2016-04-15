//
//  EmotionReactionTableViewController.swift
//  LogYourFood
//
//  Created by Laura Calinoiu on 30/03/16.
//  Copyright © 2016 3smurfs. All rights reserved.
//

import Foundation
class EmotionReactionTableViewController: ReactionTableViewController{
  
  override func viewDidLoad() {
    category = .Emotion
    options = [ Reaction(category: .Emotion,text: "You feel good", type: .Positive, selected: false),
      Reaction(category: .Emotion,text: "You are refreshed", type: .Positive, selected: false),
      Reaction(category: .Emotion,text: "Your emotions are high", type: .Positive, selected: false),
      Reaction(category: .Emotion,text: "You think clear and precise", type: .Positive, selected: false),
      Reaction(category: .Emotion,text: "Your thinking is sharpened", type: .Positive, selected: false),
      Reaction(category: .Emotion,text: "You feel mentally slow", type: .Negative, selected: false),
      Reaction(category: .Emotion,text: "You can not think clear nor precise", type: .Negative, selected: false),
      Reaction(category: .Emotion,text: "Hiper thoughts, overmuch fast", type: .Negative, selected: false),
      Reaction(category: .Emotion,text: "You can not focus nor concentrate", type: .Negative, selected: false),
      Reaction(category: .Emotion,text: "Sadness, apathetic, depressive", type: .Negative, selected: false),
      Reaction(category: .Emotion,text: "Anxious, obsessive, fearfull", type: .Negative, selected: false)]
    
    super.viewDidLoad()
  }
}