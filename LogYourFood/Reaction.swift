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
  
  static let categoryNames:[Category: String] = [Apetit: "Apetit", Energy: "Energy", Emotion: "Emotion"]
  
  func getDescription() -> String{
    if let name = Category.categoryNames[self]{
      return name
    } else {
      return "None"
    }
  }
}

enum Type: String{
  case Positive
  case Negative
}

class Reaction: Object, Clonable{
  
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
  
  func clone() -> Reaction{
    let reaction = Reaction()
    reaction.category = category
    reaction.text = text
    reaction.type = type
    
    return reaction
  }
}

class EmonjiCalculator{
  
  class func getEmonji(reactions: [Reaction]) -> UIColor{
    let positives = reactions.filter{$0.typeEnum == .Positive}.count
    let negatives = reactions.filter{$0.typeEnum == .Negative}.count
    let difference = positives - negatives
    switch  difference{
    case _ where difference > 0: return  UIColor(netHex:0x249943)
    case _ where difference < 0: return  UIColor(netHex:0xBB1117)
    default: return  UIColor(netHex:0x6A7A6E)
    }
  }
}

extension UIColor {
  convenience init(red: Int, green: Int, blue: Int) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")
    
    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
  }
  
  convenience init(netHex:Int) {
    self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
  }
}
