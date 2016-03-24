//
//  MealSelectorTableViewController.swift
//  LogYourFood
//
//  Created by Laura Calinoiu on 24/03/16.
//  Copyright © 2016 3smurfs. All rights reserved.
//

import UIKit

class MealSelectorTableViewController: UITableViewController {
  
  var checkedIndexPath: NSIndexPath!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if checkedIndexPath != nil && indexPath == checkedIndexPath {
      tableView.cellForRowAtIndexPath(checkedIndexPath)?.accessoryType = .None
    }
    
    let cell = tableView.cellForRowAtIndexPath(indexPath)
    cell?.accessoryType = .Checkmark
    checkedIndexPath = indexPath
    
    self.performSelector("dismissController", withObject: nil, afterDelay: 0.5)
  }

  func dismissController(){
      navigationController?.popViewControllerAnimated(true)
  }
  
}
