//
//  LogFoodController.swift
//  LogYourFood
//
//  Created by Laura Calinoiu on 22/03/16.
//  Copyright © 2016 3smurfs. All rights reserved.
//

import UIKit
import RealmSwift

class LogFoodController: UIViewController{
  
  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var todayButton: UIButton!
  @IBOutlet weak var mealTable: UITableView!
  
  var meals: Results<Meal>!
  
  let realm = try! Realm()
  
  var editingCell: Bool = false
  var selectedMeal: Meal?
  
  let dateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .LongStyle
    formatter.timeStyle = .NoStyle
    return formatter
  }()
  
  var selectedDate: NSDate{
    get{
      return datePicker.date
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    datePicker.addTarget(self, action: #selector(LogFoodController.datePickerChanged(_:)), forControlEvents: .ValueChanged)
    
    mealTable.dataSource = self
    mealTable.delegate = self
    datePicker.hidden = true
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    getMeals{
      self.mealTable.reloadData()
    }
  }
  
  @IBAction func todayClicked(sender: UIButton) {
    datePicker.hidden ? datePicker.fadeIn() : datePicker.fadeOut()
  }
  
  func datePickerChanged(datePicker:UIDatePicker) {
    let strDate = dateFormatter.stringFromDate(datePicker.date)
    todayButton.setTitle(strDate, forState: .Normal)
    getMeals{
      self.mealTable.reloadData()
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "NewMeal" {
      clearNSUserDefaults()
      let meal = Meal()
      meal.date = selectedDate
      (segue.destinationViewController as! NewMealTableViewController).meal = meal
    }
    
    if segue.identifier == "EditMeal" {
      if let meal = selectedMeal{
        (segue.destinationViewController as! NewMealTableViewController).meal = meal.clone()
      }
    }
  }
}

extension LogFoodController: UITableViewDataSource, UITableViewDelegate{
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("mealCell", forIndexPath: indexPath) as! MealOverviewCell
    cell.typeOfMealLabel.text = meals[indexPath.row].dishType
    cell.foodItemsLabel.text = meals[indexPath.row].foodItems
    cell.feedbackLabel.text = EmonjiCalculator.getEmonji(Array(meals[indexPath.row].reactions))
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
    if editingStyle == .Delete
    {
      try! realm.write{
        realm.delete(meals[indexPath.row].reactions)
        realm.delete(meals[indexPath.row])
      }
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    selectedMeal = meals[indexPath.row]
    performSegueWithIdentifier("EditMeal", sender: self)
  }
}

extension LogFoodController{
  
  func clearNSUserDefaults(){
    for key in Array(NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys) {
      NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
    }
  }
  
  func getMeals( completionBlock : () -> Void ) {
    let dayStart = NSCalendar.currentCalendar().startOfDayForDate(selectedDate)
    let dayEnd: NSDate = {
      let components = NSDateComponents()
      components.day = 1
      components.second = -1
      return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: dayStart, options: NSCalendarOptions())!
    }()
    self.meals = realm.objects(Meal).filter("date BETWEEN %@", [dayStart, dayEnd])
    
    completionBlock()
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

