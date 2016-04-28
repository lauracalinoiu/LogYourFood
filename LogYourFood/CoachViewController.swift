//
//  CoachViewController.swift
//  LogYourFood
//
//  Created by Laura Calinoiu on 28/04/16.
//  Copyright © 2016 3smurfs. All rights reserved.
//

import UIKit
import MessageUI

class CoachViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate {
  
  
  @IBOutlet weak var coachEmailTextField: UITextField!
  @IBOutlet weak var sendButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    sendButton.enabled = false
    coachEmailTextField.delegate = self
    
  }
  @IBAction func sendEmail(sender: UIButton) {
    if( MFMailComposeViewController.canSendMail() ) {
      print("Can send email.")
      
      let mailComposer = MFMailComposeViewController()
      mailComposer.mailComposeDelegate = self
      
      if let mailRecipient = coachEmailTextField.text {
        mailComposer.setToRecipients([mailRecipient])
      }
      mailComposer.setSubject("Have you heard a swift?")
      mailComposer.setMessageBody("This is what they sound like.", isHTML: false)
      self.presentViewController(mailComposer, animated: true, completion: nil)
    }
  }
  
  func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluateWithObject(testStr)
  }
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    if !textField.text!.isEmpty && isValidEmail(textField.text!){
      sendButton.enabled = true
    } else {
      sendButton.enabled = false
    }
    return true
  }
}
