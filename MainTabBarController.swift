//
//  MainTabBarController.swift
//  Faction
//
//  Created by Alessandro Parisi on 2015-02-03.
//  Copyright (c) 2015 Alessandro Parisi. All rights reserved.
//

import Foundation
import UIKit
import CoreData
var newLogin = false
var sh: SessionHelper?
var path = "https://faction.notscott.me"

class MainTabBarController : UITabBarController, UITabBarControllerDelegate {
    override func viewDidAppear(animated: Bool) {

        self.delegate = self;
//
//        KeychainManager.removeItemForKey("id")
//        RequestDealer.logout(self)
        
        if let name = KeychainManager.stringForKey("id") //also check to see hes not logged out? if he is we can re log him in? I only kill the keychamanger id if he logs out from my app, but what if he logs out elsewhere?
        {
            
            println(name)
            println("returning user")
            
            sh = SessionHelper()
            
            var friendNav = self.viewControllers?[0] as UINavigationController
            var factionNav = self.viewControllers?[2] as UINavigationController

            var friendVC = friendNav.viewControllers?[0] as FriendsViewController
            var factionVC = factionNav.viewControllers?[0] as ReceivedFactionsViewController

            //RequestDealer.getAllInfoOnLogin(friendVC, factionVC: factionVC, chooseVC:nil)

        }
        else{
            let storyboard = self.storyboard!
            let authVC = storyboard.instantiateViewControllerWithIdentifier("authNav") as UINavigationController
            self.presentViewController(authVC, animated: false, completion: nil)
        }
    }
}