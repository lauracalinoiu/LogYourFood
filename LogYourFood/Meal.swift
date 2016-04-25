//
//  Meal.swift
//  LogYourFood
//
//  Created by Laura Calinoiu on 30/03/16.
//  Copyright © 2016 3smurfs. All rights reserved.
//

import RealmSwift

enum DishType: String{
  case Breakfast
  case Brunch
  case Elevenses
  case Lunch
  case Tea
  case Dinner
  case Supper
  case Snack
}

class Meal : Object, Clonable{
  dynamic var date: NSDate = NSDate()
  dynamic var dishType = DishType.Breakfast.rawValue
  dynamic var id: String = ""
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  var dishTypeEnum: DishType{
    get{
      return DishType(rawValue: dishType)!
    }
    set{
      dishType = newValue.rawValue
    }
  }
  
  dynamic var foodItems: String = ""
  var reactions = List<Reaction>()
  
  func clone() -> Meal{
    let meal = Meal()
    meal.date = date
    meal.dishTypeEnum = dishTypeEnum
    meal.foodItems = foodItems
    
    for reaction in reactions{
      meal.reactions.append(reaction.clone())
    }
    
    return meal
  }
}

protocol Clonable{
  associatedtype Element
  func clone() -> Element
}