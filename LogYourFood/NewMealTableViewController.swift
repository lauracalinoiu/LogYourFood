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
      controller.delegate = self
    case let controller as ReactionTableViewController:
      controller.reactionDelegate = self
      controller.meal = meal
    default: break
    }
  }
  
  func updateTypeOfMealWith(data: String) {
    tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))?.detailTextLabel!.text = data
    if kindOfController == .UpdaterController{
      updateMeal{
        self.meal.dishTypeEnum = DishType(rawValue: data)!
      }
    } else {
      meal.dishTypeEnum = DishType(rawValue: data)!
    }
    
  }
  
  func updateSelectedReaction(updatedMeal: Meal, category: Category) {
    meal = updatedMeal
    let reactions = meal.reactions.filter { $0.category == category.rawValue }
    tableView.cellForRowAtIndexPath(NSIndexPath(forRow: category.rawValue, inSection: 2))?.detailTextLabel!.text = EmonjiCalculator.getEmonji(reactions)
  }
  
  func saveMeal(saveButton: UIBarButtonItem){
    if kindOfController == .InserterController {
      insertNewMeal(){
        self.navigationController?.popViewControllerAnimated(true)
      }
    }
  }
  
  func textViewDidEndEditing(textView: UITextView) {
    if kindOfController == .UpdaterController{
      updateMeal{
        self.meal.foodItems = textView.text
      }
    } else {
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
  
  func updateMeal(updateBlock: ()->()){
    try! realm.write(){
      updateBlock()
    }
  }
  
  func insertNewMeal(completionBlock: () -> ()){
    meal.id = NSUUID().UUIDString
    realm.beginWrite()
    realm.add(meal)
    try! realm.commitWrite()
    
    completionBlock()
    
  }
}