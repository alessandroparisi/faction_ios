//
//  SettingsViewController.swift
//  Faction
//
//  Created by Alessandro Parisi on 2015-02-01.
//  Copyright (c) 2015 Alessandro Parisi. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController : UIViewController{

    @IBOutlet var currentPass: UITextField!
    @IBOutlet var newPass: UITextField!
    @IBOutlet var confirmNewPass: UITextField!
    
    @IBAction func changePassword(sender: AnyObject) {
        println("attemption change password")
        if(newPass.text != "" && currentPass.text != ""){
            if(newPass.text == confirmNewPass.text){
                RequestDealer.changePassword(currentPass.text, newPass: newPass.text)
            }
            else{
                println("passwords do not match")
            }
        }
        else{
            println("empty fields")
        }
    }
    @IBAction func logout(sender: AnyObject) {
        RequestDealer.logout()
        let storyboard = self.storyboard!
        let tabVC = storyboard.instantiateViewControllerWithIdentifier("tabVC") as MainTabBarController
        self.presentViewController(tabVC, animated: false, completion: nil)
    }
    
}