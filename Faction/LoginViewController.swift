//
//  LoginViewController.swift
//  Faction
//
//  Created by Alessandro Parisi on 2015-02-01.
//  Copyright (c) 2015 Alessandro Parisi. All rights reserved.
//

import Foundation
import UIKit

var path = "https://faction.notscott.me"

class LoginViewController : UIViewController, UIActionSheetDelegate {
    
    @IBOutlet var btLogin: UIButton!
    
    @IBOutlet var btRegister: UIButton!
    @IBOutlet var usernameTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        title = "Login"
    }
    
    @IBAction func login(sender: UIButton) {
        if(usernameTextField.text != "" && passwordTextField.text != ""){
            println("logging in...")
            self.authUser(usernameTextField.text, password:passwordTextField.text)
            //RequestDealer.logout()
        }
        else{
            println("Nothing entered")
            showMessage("Credentials are incomplete")
        }
    }
    func showMessage(message: String){
        RequestDealer.showMessage(message, vc: self)

    }
    
    @IBAction func register(sender: UIButton) {
        performSegueWithIdentifier("to_register", sender: nil)
    }
    
    func authUser(username:String, password:String) {
        RequestDealer.login(username, password: password, vc: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
}