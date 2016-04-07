//
//  ApetitReactionsTableViewController.swift
//  LogYourFood
//
//  Created by Laura Calinoiu on 25/03/16.
//  Copyright © 2016 3smurfs. All rights reserved.
//

import UIKit

class ApetitReactionsTableViewController: ReactionTableViewController {
  
  override func viewDidLoad() {
    
    row = 0
    options = [ Reaction(category: .Apetit,text: "You feel sated, satisfied", type: .Positive, selected: false),
      Reaction(category: .Apetit,text: "You don't want desert", type: .Positive, selected: false),
      Reaction(category: .Apetit,text: "You don't want more food", type: .Positive, selected: false),
      Reaction(category: .Apetit,text: "You don't feel hungry", type: .Positive, selected: false),
      Reaction(category: .Apetit,text: "You don't need a snack before next meal", type: .Positive, selected: false),
      
      Reaction(category: .Apetit,text: "You feel full, but still hungry", type: .Negative, selected: false),
        Reaction(category: .Apetit,text: "You want desert", type: .Negative, selected: false),
        Reaction(category: .Apetit,text: "Unsatisfied, something was missing", type: .Negative, selected: false),
        Reaction(category: .Apetit,text: "Already hungry", type: .Negative, selected: false),
        Reaction(category: .Apetit,text: "You want a snack", type: .Negative, selected: false)]
    
    super.viewDidLoad()
  }
}

