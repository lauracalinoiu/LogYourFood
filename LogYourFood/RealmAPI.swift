//
//  RealmAPI.swift
//  LogYourFood
//
//  Created by Laura Calinoiu on 28/04/16.
//  Copyright © 2016 3smurfs. All rights reserved.
//

import Foundation
import RealmSwift

class RealmAPI{
  static let sharedInstance = RealmAPI()
  let realm = try! Realm()
  
  func getMealsFromDay(selectedDate: NSDate, completionBlock : (Results<Meal>) -> Void ){
    let dayStart = NSCalendar.currentCalendar().startOfDayForDate(selectedDate)
    let dayEnd: NSDate = {
      let components = NSDateComponents()
      components.day = 1
      components.second = -1
      return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: dayStart, options: NSCalendarOptions())!
    }()
    
    let meals = realm.objects(Meal).filter("date BETWEEN %@", [dayStart, dayEnd])
    completionBlock(meals)
  }
  
  func deleteMeal(meal: Meal){
    realm.beginWrite()
    realm.delete(meal.reactions)
    realm.delete(meal)
    try! realm.commitWrite()
  }
  
  func insertNewMeal(meal: Meal, completionBlock: () -> ()){
    try! realm.write{
      meal.id = NSUUID().UUIDString
      realm.add(meal)
    }
    completionBlock()
  }
  
  func updateMeal(meal: Meal, completionBlock: () -> ()){
    try! realm.write{
      realm.add(meal, update: true)
    }
    completionBlock()
  }
  
  func updateFoodItemsWith(meal: Meal, data: String){
    try! realm.write{
      meal.foodItems = data
    }
  }
}
