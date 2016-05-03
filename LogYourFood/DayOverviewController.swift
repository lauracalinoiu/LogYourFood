//
//  DayOverviewController.swift
//  LogYourFood
//
//  Created by Laura Calinoiu on 21/04/16.
//  Copyright © 2016 3smurfs. All rights reserved.
//

import UIKit
import RealmSwift

class DayOverviewController: UIViewController{
  
  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var todayButton: UIButton!
  @IBOutlet weak var mealTable: UITableView!
  
  var meals: Results<Meal>!
  var selectedMeal: Meal?
  
  var selectedDate: NSDate{
    get{
      return datePicker.date
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    datePicker.addTarget(self, action: #selector(DayOverviewController.datePickerChanged(_:)), forControlEvents: .ValueChanged)
    datePicker.hidden = true
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    RealmAPI.sharedInstance.getMealsFromDay(selectedDate){ meals in
      self.meals = meals
      self.mealTable.reloadData()
    }
  }
  
  @IBAction func todayClicked(sender: UIButton) {
    datePicker.hidden ? datePicker.fadeIn() : datePicker.fadeOut()
  }
  
  func datePickerChanged(datePicker:UIDatePicker) {
    let strDate = datePicker.date.foodLoggerDateFormatter()
    todayButton.setTitle(strDate, forState: .Normal)
    RealmAPI.sharedInstance.getMealsFromDay(selectedDate){ meals in
      self.meals = meals
      self.mealTable.reloadData()
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "NewMeal" {
      let meal = Meal()
      meal.date = selectedDate
      let newMealController = segue.destinationViewController as! NewMealTableViewController
      newMealController.meal = meal
      newMealController.kindOfController = .InserterController
    }
    
    if segue.identifier == "EditMeal" {
      if let meal = selectedMeal{
        let cloneMeal = meal.clone()
        let updaterController = segue.destinationViewController as! NewMealTableViewController
        updaterController.meal = cloneMeal
        updaterController.kindOfController = .UpdaterController
      }
    }
  }
}

extension DayOverviewController: UITableViewDataSource, UITableViewDelegate{
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("mealCell", forIndexPath: indexPath) as! MealOverviewCell
    cell.typeOfMealLabel.text = meals[indexPath.row].dishTypeEnum.getDescription()
    cell.foodItemsLabel.text = meals[indexPath.row].foodItems
    cell.reactionColorLabel.backgroundColor = EmonjiCalculator.getEmonji(Array(meals[indexPath.row].reactions))
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return meals.count
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
    return .Delete
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
  {
    if editingStyle == .Delete {
      RealmAPI.sharedInstance.deleteMeal(meals[indexPath.row])
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    selectedMeal = meals[indexPath.row]
    performSegueWithIdentifier("EditMeal", sender: self)
  }
}

extension UIView {
  func fadeIn(duration: NSTimeInterval = 0.3, completion: ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
    UIView.transitionWithView(self, duration: duration, options: .TransitionFlipFromTop, animations: {
      self.hidden = false
      }, completion: completion)
  }
  
  func fadeOut(duration: NSTimeInterval = 0.3, completion: (Bool) -> Void = {(finished: Bool) -> Void in}) {
    UIView.transitionWithView(self, duration: duration, options: UIViewAnimationOptions.TransitionFlipFromBottom, animations: {
      self.hidden = true
      }, completion: completion)
  }
}

extension NSDateFormatter {
  private static let foodDateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .LongStyle
    formatter.timeStyle = .NoStyle
    return formatter
  }()
}

extension NSDate {
  func foodLoggerDateFormatter() -> String{
    return NSDateFormatter.foodDateFormatter.stringFromDate(self)
  }
}
