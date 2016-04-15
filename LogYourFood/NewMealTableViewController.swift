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
  
  @IBOutlet weak var foodItemsTextView: UITextView!
  var meal = Meal()
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(NewMealTableViewController.saveMeal(_:)))
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    switch segue.destinationViewController {
    case let controller as MealSelectorTableViewController:
      controller.delegate = self
    case let controller as ReactionTableViewController:
      controller.reactionDelegate = self
      controller.meal = meal
    default: break
    }
  }
  
  func updateTypeOfMealWith(data: String) {
    tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))?.detailTextLabel!.text = data
    typeOfMeal = DishType(rawValue: data)
  }
  
  func updateSelectedReaction(updatedMeal: Meal, category: Category) {
    meal = updatedMeal
    let reactions = meal.reactions.filter { $0.category == category.rawValue }
    tableView.cellForRowAtIndexPath(NSIndexPath(forRow: category.rawValue, inSection: 2))?.detailTextLabel!.text = EmonjiCalculator.getEmonji(reactions)
  }
  
  func saveMeal(saveButton: UIBarButtonItem){
    commitMealToRealm(newMealFromUserEnteredData())
    navigationController?.popViewControllerAnimated(true)
  }
}

extension NewMealTableViewController{
  func newMealFromUserEnteredData() -> Meal{
    meal.date = date
    if let dishType = typeOfMeal{
      meal.dishTypeEnum = dishType
    }
    meal.foodItems = foodItemsTextView.text
    return meal
  }
  
  func commitMealToRealm(meal: Meal){
    realm.beginWrite()
    realm.add(meal)
    try! realm.commitWrite()
  }
}