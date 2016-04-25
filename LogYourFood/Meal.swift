//
//  Meal.swift
//  LogYourFood
//
//  Created by Laura Calinoiu on 30/03/16.
//  Copyright © 2016 3smurfs. All rights reserved.
//

import RealmSwift

enum DishType: Int{
  case None = -1
  case Breakfast = 0
  case Brunch
  case Elevenses
  case Lunch
  case Tea
  case Dinner
  case Supper
  case Snack
  
  
  static let dishNames: [DishType: String] = [ None: "None", Breakfast : "Breakfast", Brunch : "Brunch", Elevenses : "Elevenses", Lunch : "Lunch",
    Tea : "Tea", Dinner : "Dinner", Supper : "Supper", Snack : "Snack"]
  
  func getDescription() -> String{
    if let name = DishType.dishNames[self]{
      return name
    } else {
      return "None"
    }
  }
}

class Meal : Object, Clonable{
  dynamic var date: NSDate = NSDate()
  dynamic var dishType = DishType.None.rawValue
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