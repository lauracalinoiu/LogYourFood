//
//  Reaction.swift
//  LogYourFood
//
//  Created by Laura Calinoiu on 28/03/16.
//  Copyright © 2016 3smurfs. All rights reserved.
//

import RealmSwift

enum Category: Int{
  case Apetit
  case Energy
  case Emotion
}

enum Type: String{
  case Positive
  case Negative
}

class Reaction: Object{
  
  dynamic var category = Category.Apetit.rawValue
  dynamic var text: String?
  dynamic var type = Type.Positive.rawValue
  
  var categoryEnum: Category{
    get{
      return Category(rawValue: category)!
    }
    set{
      category = newValue.rawValue
    }
  }
  
  var typeEnum: Type{
    get{
      return Type(rawValue: type)!
    }
    set{
      type = newValue.rawValue
    }
  }
  
  convenience init(category: Category, text: String, type: Type, selected: Bool){
    self.init()
    self.categoryEnum = category
    self.text = text
    self.typeEnum = type
  }
}

class EmonjiCalculator{
  
  class func getEmonji(reactions: [Reaction]) -> String{
    let positives = reactions.filter{$0.typeEnum == .Positive}.count
    let negatives = reactions.filter{$0.typeEnum == .Negative}.count
    let difference = positives - negatives
    switch  difference{
    case _ where difference > 0: return "😀"
    case _ where difference < 0: return "☹️"
    default: return "😐"
    }
  }
}
