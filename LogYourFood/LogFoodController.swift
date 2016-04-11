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
      deleteSelectionFromRealm()
      (segue.destinationViewController as! NewMealTableViewController).date = selectedDate
    }
  }
}

extension LogFoodController: UITableViewDataSource{
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("mealCell", forIndexPath: indexPath)
    cell.textLabel?.text = meals[indexPath.row].dishType
    cell.detailTextLabel?.text = meals[indexPath.row].foodItems
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return meals.count
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
}

extension LogFoodController{
  
  func deleteSelectionFromRealm(){
    let reactions = realm.objects(Reaction)
    realm.beginWrite()
    realm.delete(reactions)
    try! realm.commitWrite()
  }
  
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

