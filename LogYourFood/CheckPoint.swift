//
//  CheckPoint.swift
//  LogYourFood
//
//  Created by Laura Calinoiu on 11/04/16.
//  Copyright © 2016 3smurfs. All rights reserved.
//

import Foundation

let reactionKey = "com.3smurfs.Reaction"

class CheckPoint {
  class func saveState(memento: Reaction, keyName: String = reactionKey) {
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.setObject(memento, forKey: keyName)
    defaults.synchronize()
  }
  
  class func restorePreviousState(keyName keyName: String = reactionKey) -> Reaction {
    let defaults = NSUserDefaults.standardUserDefaults()
    
    return defaults.objectForKey(keyName) as? Reaction ?? Reaction()
  }
}
