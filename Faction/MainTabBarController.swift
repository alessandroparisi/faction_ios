//
//  MainTabBarController.swift
//  Faction
//
//  Created by Alessandro Parisi on 2015-02-03.
//  Copyright (c) 2015 Alessandro Parisi. All rights reserved.
//

import Foundation
import UIKit

var firstTime = true

class MainTabBarController : UITabBarController {
    override func viewDidAppear(animated: Bool) {
        
        if firstTime {
            let storyboard = self.storyboard!
            let authVC = storyboard.instantiateViewControllerWithIdentifier("authNav") as UINavigationController
            self.presentViewController(authVC, animated: false, completion: nil)
            firstTime = false
        }
        //RequestDealer.logout()
    }
}