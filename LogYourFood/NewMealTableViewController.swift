//
//  NewMealTableViewController.swift
//  LogYourFood
//
//  Created by Laura Calinoiu on 24/03/16.
//  Copyright © 2016 3smurfs. All rights reserved.
//

import UIKit

class NewMealTableViewController: UITableViewController, MealDelegate, ApetitDelegate{
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ChooseMeal" {
      (segue.destinationViewController as! MealSelectorTableViewController).delegate = self
    }
    
    if segue.identifier == "ApetitReaction" {
      (segue.destinationViewController as! ApetitReactionsTableViewController).apetitDelegate = self
    }
  }
  
  func update(data: String) {
    tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))?.detailTextLabel!.text = data
  }
  
  func updateSelected(data: String) {
    tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2))?.detailTextLabel!.text = data
  }
}
