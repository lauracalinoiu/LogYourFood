//
//  ReactionTableViewController.swift
//  LogYourFood
//
//  Created by Laura Calinoiu on 29/03/16.
//  Copyright © 2016 3smurfs. All rights reserved.
//

import UIKit
import RealmSwift

class ReactionTableViewController: UITableViewController {
  
  var reactionDelegate: ReactionDelegate?
  let realm = try! Realm()
  
  var options: [Reaction] = [Reaction]()
  var row: Int!
  
  var meal: Meal?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(ReactionTableViewController.pressDone(_:)))
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewDidLoad()
    tableView.reloadData()
  }
  
  func pressDone(doneButton: UIBarButtonItem){
    notifyAndUpdateParentWithSelection()
    navigationController?.popViewControllerAnimated(true)
  }
  
  func notifyAndUpdateParentWithSelection(){
    reactionDelegate!.updateSelectedReaction(meal!, whichRow: row)
  }
}

extension ReactionTableViewController{
  
  var biasedOptions: [[Reaction]]{
    get{
      return [options.filter{ $0.typeEnum == .Positive } , options.filter{ $0.typeEnum == .Negative }]
    }
  }
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return biasedOptions[section].count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("apetitCell", forIndexPath: indexPath)
    let reaction = biasedOptions[indexPath.section][indexPath.row]
    cell.textLabel!.text = reaction.text
    cell.accessoryType = meal!.reactions.contains({ $0.text == reaction.text }) ? .Checkmark : .None
    return cell
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return section == 0 ? "Positive" : "Negative"
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let reaction = biasedOptions[indexPath.section][indexPath.row]
    if let indexOfReaction = meal?.reactions.indexOf({ $0.text == reaction.text}){
      meal!.reactions.removeAtIndex(indexOfReaction)
    } else{
      meal!.reactions.append(reaction)
    }
    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
  }
}
protocol ReactionDelegate{
  func updateSelectedReaction(updatedMeal: Meal, whichRow: Int)
}
