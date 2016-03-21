//
//  AddNewMealController.swift
//  LogYourFood
//
//  Created by Laura Calinoiu on 15/03/16.
//  Copyright © 2016 3smurfs. All rights reserved.
//

import UIKit

class AddNewMealController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{

  var mealType = ["breakfast", "snack after breakfast", "lunch", "snack after lunch", "dinner", "snack after dinner"]
  @IBOutlet weak var textView: UITextView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      textView!.layer.borderWidth = 2
      textView!.layer.borderColor = UIColor.grayColor().CGColor
      textView!.text = "What did you eat?"
    }

  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return mealType.count
  }
  
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return mealType[row]
  }

}
