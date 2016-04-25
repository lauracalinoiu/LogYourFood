//
//  NewMealTableViewController.swift
//  LogYourFood
//
//  Created by Laura Calinoiu on 24/03/16.
//  Copyright © 2016 3smurfs. All rights reserved.
//

import UIKit
import RealmSwift

enum TypeOfController{
  case UpdaterController
  case InserterController
}

class NewMealTableViewController: UITableViewController, MealDelegate, ReactionDelegate, UITextViewDelegate{
  
  let realm = try! Realm()
  var meal: Meal!
  @IBOutlet weak var foodItemsTextView: UITextView!
  var kindOfController: TypeOfController!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    populateUIWithValuesFromRealm()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(NewMealTableViewController.saveMeal(_:)))
    foodItemsTextView.delegate = self
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    switch segue.destinationViewController {
    case let controller as MealSelectorTableViewController:
      controller.meal = meal
      controller.delegate = self
    case let controller as ReactionTableViewController:
      controller.reactionDelegate = self
      controller.meal = meal
    default: break
    }
  }
  
  func updateTypeOfMealWith(data: Int) {
    meal.dishTypeEnum = DishType(rawValue: data)!
    tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))?.detailTextLabel!.text = meal.dishTypeEnum.getDescription()
  }
  
  func updateSelectedReaction(updatedMeal: Meal, category: Category) {
    meal = updatedMeal
    let reactions = meal.reactions.filter { $0.category == category.rawValue }
    if reactions.count > 0{
    tableView.cellForRowAtIndexPath(NSIndexPath(forRow: category.rawValue, inSection: 2))?.backgroundColor = EmonjiCalculator.getEmonji(reactions)
    } else {
      tableView.cellForRowAtIndexPath(NSIndexPath(forRow: category.rawValue, inSection: 2))?.detailTextLabel!.text = "Choose"
    }
  }
  
  func saveMeal(saveButton: UIBarButtonItem){
    if kindOfController == .InserterController {
      insertNewMeal(){
        self.navigationController?.popViewControllerAnimated(true)
      }
    } else {
      updateMeal(){
        self.navigationController?.popViewControllerAnimated(true)
      }
    }
  }
  
  func textViewDidEndEditing(textView: UITextView) {
    try! realm.write{
      meal.foodItems = textView.text
    }
  }
}

extension NewMealTableViewController{
  
  func populateUIWithValuesFromRealm(){
    foodItemsTextView.text = meal.foodItems
    updateSelectedReaction(meal, category: .Apetit)
    updateSelectedReaction(meal, category: .Energy)
    updateSelectedReaction(meal, category: .Emotion)
    updateTypeOfMealWith(meal.dishType)
  }
  
  func insertNewMeal(completionBlock: () -> ()){
    try! realm.write{
      meal.id = NSUUID().UUIDString
      realm.add(meal)
    }
    completionBlock()
  }
  
  func updateMeal(completionBlock: () -> ()){
    try! realm.write{
      realm.add(meal, update: true)
    }
    completionBlock()
  }
}