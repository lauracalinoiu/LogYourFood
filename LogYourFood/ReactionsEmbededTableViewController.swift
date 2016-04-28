//
//  ReactionsEmbededTableViewController.swift
//  LogYourFood
//
//  Created by Laura Calinoiu on 26/04/16.
//  Copyright © 2016 3smurfs. All rights reserved.
//

import UIKit

class ReactionsEmbededTableViewController: UITableViewController, ReactionDelegate {
  
  var meal: Meal!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = UIView()
    tableView.layoutIfNeeded()
  }
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let controller = segue.destinationViewController as? ReactionTableViewController{
      controller.reactionDelegate = self
      controller.meal = meal
    }
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Category.categoryNames.count
  }
  
  override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.1
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("reactionCell", forIndexPath: indexPath) as! ReactionCell
    let reactions = meal.reactions.filter { $0.category == indexPath.row }
    cell.reactionLabel.text = Category(rawValue: indexPath.row)!.getDescription()
    reactions.count > 0 ? setUpRowWithColorAndNoHelpingText(cell, reactions: reactions) :
      setUpRowWithNoColorAndHelpingText(cell)
    return cell
  }
  
  func setUpRowWithColorAndNoHelpingText(cell: ReactionCell, reactions: [Reaction]){
    cell.reactionColorLabel.backgroundColor = EmonjiCalculator.getEmonji(reactions)
    cell.explanationTextLabel.text = ""
  }
  
  func setUpRowWithNoColorAndHelpingText(cell: ReactionCell){
    cell.reactionColorLabel.backgroundColor = cell.backgroundColor
    cell.explanationTextLabel.text = "Choose"
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    switch indexPath.row {
    case 0: performSegueWithIdentifier("ApetitReaction", sender: self)
    case 1: performSegueWithIdentifier("EnergyReaction", sender: self)
    case 2: performSegueWithIdentifier("EmotionReaction", sender: self)
    default: break
    }
  }
  
  func updateSelectedReaction(updatedMeal: Meal, category: Category) {
    let indexPath = NSIndexPath(forRow: category.rawValue, inSection: 0)
    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
  }
  
  func getTableViewHeight() -> CGFloat{
    return tableView.contentSize.height
  }
}
