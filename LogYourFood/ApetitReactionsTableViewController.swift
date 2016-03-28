//
//  ApetitReactionsTableViewController.swift
//  LogYourFood
//
//  Created by Laura Calinoiu on 25/03/16.
//  Copyright © 2016 3smurfs. All rights reserved.
//

import UIKit

class ApetitReactionsTableViewController: UITableViewController {
  
  var apetitDelegate: ApetitDelegate?
  var options: [[Reaction]] = [[ Reaction(category: .Apetit,text: "You feel sated, satisfied", type: .Positive, selected: false),
    Reaction(category: .Apetit,text: "You don't want desert", type: .Positive, selected: false),
    Reaction(category: .Apetit,text: "You don't want more food", type: .Positive, selected: false),
    Reaction(category: .Apetit,text: "You don't feel hungry", type: .Positive, selected: false),
    Reaction(category: .Apetit,text: "You don't need a snack before next meal", type: .Positive, selected: false)],
    
    [Reaction(category: .Apetit,text: "You feel full, but still hungry", type: .Negative, selected: false),
      Reaction(category: .Apetit,text: "You want desert", type: .Negative, selected: false),
      Reaction(category: .Apetit,text: "Unsatisfied, something was missing", type: .Negative, selected: false),
      Reaction(category: .Apetit,text: "Already hungry", type: .Negative, selected: false),
      Reaction(category: .Apetit,text: "You want a snack", type: .Negative, selected: false)]]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "pressDone:")
  }
  
  func pressDone(doneButton: UIBarButtonItem){
    checkIfSomethingChosen()
    navigationController?.popViewControllerAnimated(true)
  }
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return options.count
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return options[section].count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("apetitCell", forIndexPath: indexPath)
    cell.textLabel!.text = options[indexPath.section][indexPath.row].text
    cell.accessoryType = options[indexPath.section][indexPath.row].selected ? .Checkmark : .None
    return cell
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 0{
      return "Positve"
    } else {
      return "Negative"
    }
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    options[indexPath.section][indexPath.row].toggleSelection()
    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
  }
  
  func checkIfSomethingChosen(){
    for type in options{
      for option in type{
        if option.selected {
          apetitDelegate!.updateSelected("**")
        }
      }
    }
  }
}

protocol ApetitDelegate{
  func updateSelected(data: String)
}
