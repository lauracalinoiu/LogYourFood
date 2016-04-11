//
//  NewMealTableViewController.swift
//  LogYourFood
//
//  Created by Laura Calinoiu on 24/03/16.
//  Copyright © 2016 3smurfs. All rights reserved.
//

import UIKit
import RealmSwift

class NewMealTableViewController: UITableViewController, MealDelegate, ReactionDelegate{
  
  let realm = try! Realm()
  var date = NSDate()
  var typeOfMeal : DishType?
  
  @IBOutlet weak var foodItems: UITextView!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(NewMealTableViewController.saveMeal(_:)))
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ChooseMeal" {
      (segue.destinationViewController as! MealSelectorTableViewController).delegate = self
    }
    
    if segue.identifier == "ApetitReaction" {
      (segue.destinationViewController as! ApetitReactionsTableViewController).reactionDelegate = self
    }
    
    if segue.identifier == "EnergyReaction" {
      (segue.destinationViewController as! EnergyReactionTableViewController).reactionDelegate = self
    }
    
    if segue.identifier == "EmotionReaction" {
      (segue.destinationViewController as! EmotionReactionTableViewController).reactionDelegate = self
    }
  }
  
  func updateTypeOfMealWith(data: String) {
    tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))?.detailTextLabel!.text = data
    typeOfMeal = DishType(rawValue: data)
  }
  
  func updateSelectedReaction(positivesMinusNegatives: Int, row: Int) {
    tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 2))?.detailTextLabel!.text = getEmonji(positivesMinusNegatives)
  }
  
  func getEmonji(difference: Int) -> String{
    switch difference{
    case _ where difference > 0: return "😀"
    case _ where difference < 0: return "☹️"
    default: return "😐"
    }
  }
  
  func saveMeal(saveButton: UIBarButtonItem){
    commitMealToRealm(newMealFromUserEnteredData())
  }
}

extension NewMealTableViewController{
  func newMealFromUserEnteredData() -> Meal{
    let meal = Meal()
    meal.date = date
    if let dishType = typeOfMeal{
      meal.dishTypeEnum = dishType
    }
    meal.foodItems = foodItems.text
    meal.reactions = realm.objects(Reaction).reduce(List<Reaction>()){  (list, element) -> List<Reaction> in
      list.append(element)
      return list
    }
    
    return meal
  }
  
  func commitMealToRealm(meal: Meal){
    realm.beginWrite()
    realm.add(meal)
    try! realm.commitWrite()
  }
}