//
//  MainTabBarController.swift
//  Faction
//
//  Created by Alessandro Parisi on 2015-02-03.
//  Copyright (c) 2015 Alessandro Parisi. All rights reserved.
//

import Foundation
import UIKit

var notLoggedIn = true

class MainTabBarController : UITabBarController {
    override func viewDidAppear(animated: Bool) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let name = defaults.stringForKey("id") //also check to see hes not logged out? if he is we can re log him in?
        {
            println(name)
            println("returning user")
        }
        else{
            let storyboard = self.storyboard!
            let authVC = storyboard.instantiateViewControllerWithIdentifier("authNav") as UINavigationController
            self.presentViewController(authVC, animated: false, completion: nil)
        }
        //RequestDealer.logout()
    }
}