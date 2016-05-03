//
//  ComposeMailViewController.swift
//  LogYourFood
//
//  Created by Laura Calinoiu on 29/04/16.
//  Copyright © 2016 3smurfs. All rights reserved.
//

import Foundation
import MessageUI

class ComposeMailViewController: MFMailComposeViewController, MFMailComposeViewControllerDelegate{
  var monitoredFoodText: String?
  
  override func viewDidLoad(){
    super.viewDidLoad()
    
    mailComposeDelegate = self
    if( MFMailComposeViewController.canSendMail() ) {
      setSubject("Food Log for: " + NSDate().foodLoggerDateFormatter())
      if let foodText = monitoredFoodText{
        setMessageBody(foodText, isHTML: false)
      } else {
        setMessageBody("Sorry, please select dates with data!", isHTML: false)
      }
    }
  }
  
  func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
    dismissViewControllerAnimated(true, completion: nil)
  }
}