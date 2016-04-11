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
  case Second_breakfast
  case Brunch
  case Elevenses
  case Lunch
  case Tea
  case Dinner
  case Supper
  case Snack
}

class Meal : Object{
  dynamic var date: NSDate = NSDate()
  dynamic var dishType = DishType.Breakfast.rawValue
  
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
}