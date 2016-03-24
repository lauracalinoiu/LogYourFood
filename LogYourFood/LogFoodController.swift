//
//  LogFoodController.swift
//  LogYourFood
//
//  Created by Laura Calinoiu on 22/03/16.
//  Copyright © 2016 3smurfs. All rights reserved.
//

import UIKit

class LogFoodController: UITableViewController {
  
  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var dateLabel: UILabel!
  
  var editingCell: Bool = false
  let dateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .ShortStyle
    formatter.timeStyle = .NoStyle
    
    print("instantiate formatter")
    return formatter
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    datePicker.addTarget(self, action: "datePickerChanged:", forControlEvents: .ValueChanged)
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if (indexPath.section == 0 && indexPath.row == 1) {
      return !editingCell ? 0 : 216
    } else {
      return self.tableView.rowHeight
    }
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    self.tableView.deselectRowAtIndexPath(indexPath, animated: false);
    self.tableView.beginUpdates()
    if (indexPath.section == 0 && indexPath.row == 0) {
      editingCell = !editingCell;
    }
    self.tableView.endUpdates()
  }
  
  func datePickerChanged(datePicker:UIDatePicker) {
    let strDate = dateFormatter.stringFromDate(datePicker.date)
    dateLabel.text = strDate
  }
  
}
