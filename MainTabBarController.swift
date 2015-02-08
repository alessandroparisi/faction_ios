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

class MainTabBarController : UITabBarController, UITabBarControllerDelegate {
    override func viewDidAppear(animated: Bool) {
    
//        var userDefaults = NSUserDefaults.standardUserDefaults()
//        userDefaults.removeObjectForKey("username")
//        KeychainManager.removeItemForKey("id")
        
        self.delegate = self;

        if let name = KeychainManager.stringForKey("id") //also check to see hes not logged out? if he is we can re log him in? I only kill the keychamanger id if he logs out from MY app, but what if he logs out elsewhere?
        {
            sh = SessionHelper()
            
            var friendNav = self.viewControllers?[0] as UINavigationController
            var factionNav = self.viewControllers?[2] as UINavigationController

            var friendVC = friendNav.viewControllers?[0] as FriendsViewController
            var factionVC = factionNav.viewControllers?[0] as ReceivedFactionsViewController

            if newLogin {
                //RequestDealer.getAllInfoOnLogin()
                newLogin = false
            }
            else {
                RequestDealer.updateDB(friendVC, factionVC: factionVC)
            }
            
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
//    func updateAfterLogout(){
//        if let name = KeychainManager.stringForKey("id") //also check to see hes not logged out? if he is we can re log him in? I only kill the keychamanger id if he logs out from MY app, but what if he logs out elsewhere?
//        {
//            sh = SessionHelper()
//            
//            var nav = self.viewControllers?[0] as UINavigationController
//            
//            var friendVC = nav.viewControllers?[0] as FriendsViewController
//            
//            RequestDealer.updateDB(friendVC)
//            
//            println(name)
//            println("returning user")
//        }
//        else{
//            let storyboard = self.storyboard!
//            let authVC = storyboard.instantiateViewControllerWithIdentifier("authNav") as UINavigationController
//            self.presentViewController(authVC, animated: false, completion: nil)
//        }
//        //RequestDealer.logout()
//    }
    
}