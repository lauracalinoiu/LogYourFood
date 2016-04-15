//
//  EnergyReactionTableViewController.swift
//  LogYourFood
//
//  Created by Laura Calinoiu on 29/03/16.
//  Copyright © 2016 3smurfs. All rights reserved.
//

import Foundation
class EnergyReactionTableViewController: ReactionTableViewController{
  
  override func viewDidLoad() {
    category = .Energy
    options = [ Reaction(category: .Energy,text: "Your energy is back", type: .Positive, selected: false),
        Reaction(category: .Energy,text: "You feel a good energy that will last longer", type: .Positive, selected: false),
      Reaction(category: .Energy,text: "Your meal gave you too much or too less energy", type: .Negative, selected: false),
      Reaction(category: .Energy,text: "You became hiper, tense, unsure, anxious or fast", type: .Negative, selected: false),
      Reaction(category: .Energy,text: "You feel hiper, but tired inside", type: .Negative, selected: false),
        Reaction(category: .Energy,text: "You don't have energy, you are sleepy", type: .Negative, selected: false)]
    super.viewDidLoad()
  }

}