//
//  ViewController.swift
//  LogYourFood
//
//  Created by Laura Calinoiu on 15/03/16.
//  Copyright © 2016 3smurfs. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
  
  @IBOutlet weak var dayLabel: UILabel!
  let formatter = NSDateFormatter()

  var date: NSDate = NSDate() {
    didSet {
      dayLabel.text = formatter.stringFromDate(date)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    formatter.dateStyle = NSDateFormatterStyle.LongStyle
    formatter.timeStyle = .NoStyle
  }
  
  @IBAction func pushOneDayBack(sender: UIButton) {
    date = date.changeDaysBy(-1)
  }

  @IBAction func pushOneDayAhead(sender: UIButton) {
    date = date.changeDaysBy(1)
  }
  
}

extension NSDate {
  func changeDaysBy(days : Int) -> NSDate {
    let dateComponents = NSDateComponents()
    dateComponents.day = days
    return NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: self, options: NSCalendarOptions(rawValue: 0))!
  }
}

