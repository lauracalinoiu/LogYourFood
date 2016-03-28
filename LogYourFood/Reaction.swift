//
//  Reaction.swift
//  LogYourFood
//
//  Created by Laura Calinoiu on 28/03/16.
//  Copyright © 2016 3smurfs. All rights reserved.
//

import Foundation

enum Category{
  case Apetit
  case Energy
  case Emotion
}

enum Type{
  case Positive
  case Negative
}

class Reaction{
  var category: Category
  var text: String?
  var type: Type
  var selected: Bool
  
  init(category: Category, text: String, type: Type, selected: Bool){
    self.category = category
    self.text = text
    self.type = type
    self.selected = selected
  }
  
  func toggleSelection(){
    selected = !selected
  }
}
