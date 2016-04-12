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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(ReactionTableViewController.pressDone(_:)))
    getPreviousSelectionFromCategory()
    tableView.reloadData()
  }
  
  func pressDone(doneButton: UIBarButtonItem){
    notifyAndUpdateParentWithSelection()
    saveReactionStateOnUserDefaults()
    navigationController?.popViewControllerAnimated(true)
  }
  
  func notifyAndUpdateParentWithSelection(){
    let positives = options.filter{$0.typeEnum == .Positive && $0.selected}.count
    let negatives = options.filter{$0.typeEnum == .Negative && $0.selected}.count
    reactionDelegate!.updateSelectedReaction(positives - negatives, row: row)
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
    cell.textLabel!.text = biasedOptions[indexPath.section][indexPath.row].text
    cell.accessoryType = biasedOptions[indexPath.section][indexPath.row].selected ? .Checkmark : .None
    return cell
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return section == 0 ? "Positive" : "Negative"
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    biasedOptions[indexPath.section][indexPath.row].toggleSelection()
    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
  }
}

extension ReactionTableViewController{
  
  func saveReactionStateOnUserDefaults(){
    let selected = options.filter{$0.selected}
    let archiveArray = NSMutableArray()
    for selectedOption in selected{
      let encodedReaction = NSKeyedArchiver.archivedDataWithRootObject(selectedOption)
      archiveArray.addObject(encodedReaction)
    }
    if selected.count > 0 {
      CheckPoint.saveState(archiveArray, keyName: "\(row)")}
  }
  
  func getPreviousSelectionFromCategory(){
    let selected = CheckPoint.restorePreviousState(keyName: "\(row)")
    options = options.map(){ reaction in
      if selected.filter({$0.text == reaction.text}).count > 0 {
        reaction.selected = true
      }
      return reaction
    }
  }
}

protocol ReactionDelegate{
  func updateSelectedReaction(positivesMinusNegatives: Int, row: Int)
}
