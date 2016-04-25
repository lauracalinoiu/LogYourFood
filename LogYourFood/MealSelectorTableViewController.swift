//
//  MealSelectorTableViewController.swift
//  LogYourFood
//
//  Created by Laura Calinoiu on 24/03/16.
//  Copyright © 2016 3smurfs. All rights reserved.
//

import UIKit

class MealSelectorTableViewController: UITableViewController {
  
  var meal: Meal!
  var checkedIndexPath: NSIndexPath? {
    get{
      return NSIndexPath(forRow: meal.dishTypeEnum.hashValue, inSection: 0)
    }
    set(v){
      
    }
  }
  
  var delegate: MealDelegate?
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    showPreviousSelection()
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    uncheckPreviousOption()
    checkNewOption(indexPath)
    notifyDelegateAboutChange(indexPath)
    self.performSelector(#selector(MealSelectorTableViewController.dismissController), withObject: nil, afterDelay: 0.5)
  }
  
  func uncheckPreviousOption(){
    if let checkedIndexPathUnwrapped = checkedIndexPath {
      tableView.cellForRowAtIndexPath(checkedIndexPathUnwrapped)?.accessoryType = .None
    }
  }
  
  func checkNewOption(indexPath: NSIndexPath){
    let cell = tableView.cellForRowAtIndexPath(indexPath)
    cell?.accessoryType = .Checkmark
    checkedIndexPath = indexPath
  }
  
  func notifyDelegateAboutChange(indexPath: NSIndexPath){
    delegate?.updateTypeOfMealWith(indexPath.row)
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
  func updateTypeOfMealWith(data: Int)
}
