//
//  Meal.swift
//  LogYourFood
//
//  Created by Laura Calinoiu on 30/03/16.
//  Copyright © 2016 3smurfs. All rights reserved.
//

import RealmSwift

enum DishType: Int{
  case Breakfast = 0
  case Brunch
  case Elevenses
  case Lunch
  case Tea
  case Dinner
  case Supper
  case Snack
  
  var description: String{
    switch self{
    case Breakfast: return "Breakfast"
    case Brunch: return "Brunch"
    case Elevenses: return "Elevenses"
    case Lunch: return "Lunch"
    case Tea: return "Tea"
    case Dinner: return "Dinner"
    case Supper: return "Supper"
    case Snack: return "Snack"
    }
  }
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
    meal.id = id
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