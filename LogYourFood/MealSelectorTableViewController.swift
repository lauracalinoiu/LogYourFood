//
//  MealSelectorTableViewController.swift
//  LogYourFood
//
//  Created by Laura Calinoiu on 24/03/16.
//  Copyright © 2016 3smurfs. All rights reserved.
//

import UIKit

class MealSelectorTableViewController: UITableViewController {
  
  var checkedIndex: Int? {
    get {
      guard let index = NSUserDefaults.standardUserDefaults().objectForKey("checkedIndex") else{
        return nil
      }
      return Int(index as! NSNumber)
    }
    set {
      NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "checkedIndex")
      NSUserDefaults.standardUserDefaults().synchronize()
    }
  }
  
  var checkedIndexPath: NSIndexPath? {
    get{
      if let checkedIndexUnwrapped = checkedIndex{
        return NSIndexPath(forRow: checkedIndexUnwrapped, inSection: 0)
      }
      return nil
    }
    set(v){
      checkedIndex = v?.row
    }
  }
  
  var delegate: MealDelegate?
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    showPreviousSelection()
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if let checkedIndexPathUnwrapped = checkedIndexPath {
      tableView.cellForRowAtIndexPath(checkedIndexPathUnwrapped)?.accessoryType = .None
    }
    
    let cell = tableView.cellForRowAtIndexPath(indexPath)
    cell?.accessoryType = .Checkmark
    checkedIndexPath = indexPath
    if let labelFromCell = cell?.textLabel{
      delegate?.update(labelFromCell.text!)
    }
  
    self.performSelector("dismissController", withObject: nil, afterDelay: 0.5)
  }
  
  func dismissController(){
    navigationController?.popViewControllerAnimated(true)
  }
  
  func showPreviousSelection(){
    if let checkedIndexPathUnwrapped = checkedIndexPath{
      tableView.cellForRowAtIndexPath(checkedIndexPathUnwrapped)?.accessoryType = .Checkmark
    }
  }
}

protocol MealDelegate{
  func update(data: String)
}
