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
  var checkedIndexPath: NSIndexPath?{
    get{
      return NSIndexPath(forRow: meal.dishTypeEnum.rawValue, inSection: 0)
    }
    set(v){
      meal.dishTypeEnum = DishType(rawValue: v!.row)!
    }
  }
  var delegate: MealDelegate?
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    showPreviousSelection()
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    uncheckOption()
    checkOption(indexPath)
    notifyDelegateAboutChange(indexPath)
    self.performSelector(#selector(MealSelectorTableViewController.dismissController), withObject: nil, afterDelay: 0.5)
  }
  
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return DishType.dishNames.count - 1
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("dishTypeCell", forIndexPath: indexPath)
    if let dishType = DishType(rawValue: indexPath.row) {
      cell.textLabel!.text = dishType.getDescription()
    }
    return cell
  }
  
  func uncheckOption(){
    if let checkedIndexPathUnwrapped = checkedIndexPath {
      tableView.cellForRowAtIndexPath(checkedIndexPathUnwrapped)?.accessoryType = .None
    }
  }
  
  func checkOption(indexPath: NSIndexPath){
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
