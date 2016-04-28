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

class NewMealTableViewController: UITableViewController, MealDelegate, UITextViewDelegate{
  
  var kindOfController: TypeOfController!
  let realm = try! Realm()
  var meal: Meal!
  @IBOutlet weak var foodItemsTextView: UITextView!
  @IBOutlet weak var controllersHeight: NSLayoutConstraint!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(NewMealTableViewController.saveMeal(_:)))
    foodItemsTextView.delegate = self
    tableView.estimatedRowHeight = 44
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    populateUIWithValuesFromRealm()
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.section{
    case 1: return 120
    case 2:
      if let reactionsEmbeded = childViewControllers.first as?ReactionsEmbededTableViewController{
        return reactionsEmbeded.getTableViewHeight()
      }
      return UITableViewAutomaticDimension
    default:
      return UITableViewAutomaticDimension
    }
  }
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    switch segue.destinationViewController {
    case let controller as MealSelectorTableViewController:
      controller.meal = meal
      controller.delegate = self
    case let controller as ReactionsEmbededTableViewController:
      controller.meal = meal
    default: break
    }
  }
  
  func updateTypeOfMealWith(data: Int) {
    meal.dishTypeEnum = DishType(rawValue: data)!
    tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))?.detailTextLabel!.text = meal.dishTypeEnum.getDescription()
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
