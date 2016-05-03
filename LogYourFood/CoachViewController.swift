//
//  CoachViewController.swift
//  LogYourFood
//
//  Created by Laura Calinoiu on 28/04/16.
//  Copyright © 2016 3smurfs. All rights reserved.
//

import UIKit
import MessageUI
import FSCalendar

class CoachViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
  
  
  @IBOutlet weak var calendar: FSCalendar!
  var composeController: MFMailComposeViewController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    calendar.setScope(.Month, animated: true)
    navigationItem.rightBarButtonItem = self.editButtonItem()
    editButtonItem().title = "Select"
  }
  
  override func setEditing(editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    
    if editing{
      editButtonItem().title = "Done"
      calendar.allowsMultipleSelection = true
    } else {
      editButtonItem().title = "Select"
      calendar.allowsMultipleSelection = false
      sendFoodTextToComposeViewController()
    }
  }
  
  func getMonitoredFoodWithCompletionHandler(completionHandler: (allText: String) -> ()){
    var allMealsAsString = ""
    for date in calendar.selectedDates{
      RealmAPI.sharedInstance.getMealsFromDay(date as! NSDate){ meals in
        for meal in meals{
          allMealsAsString += meal.foodItems
        }
      }
    }
    completionHandler(allText: allMealsAsString)
  }
}

extension CoachViewController: MFMailComposeViewControllerDelegate{
  
  func sendFoodTextToComposeViewController(){
    guard MFMailComposeViewController.canSendMail() else {
      return
    }
    composeController = MFMailComposeViewController()
    composeController.mailComposeDelegate = self
    composeController.setSubject("Food Log for: " + NSDate().foodLoggerDateFormatter())
    getMonitoredFoodWithCompletionHandler { foodText in
      self.composeController.setMessageBody(foodText, isHTML: false)
    }
    presentViewController(composeController, animated: true){
      UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
    }
  }
  
  func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
    dismissViewControllerAnimated(true, completion: nil)
  }
}
