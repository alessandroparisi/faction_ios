//
//  RegisterViewController.swift
//  Faction
//
//  Created by Alessandro Parisi on 2015-02-01.
//  Copyright (c) 2015 Alessandro Parisi. All rights reserved.
//

import Foundation
import UIKit

class RegisterViewController : UIViewController, UIActionSheetDelegate {
    
    
    @IBOutlet var btRegister: UIButton!
    @IBOutlet var usernameTextField: UITextField!
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        title = "Register"
    }
    
    
    @IBAction func register(sender: UIButton) {
        if(usernameTextField.text != "" && passwordTextField.text != "" && emailTextField.text != ""){
            if(passwordTextField.text == confirmPasswordTextField.text){
                self.registerUser(usernameTextField.text, password: passwordTextField.text, email:emailTextField.text)
            }
            else{
                println("Passwords do not match")
            }
        }
    }
    
    func registerUser(username: String, password: String, email: String) {
        
        let params = ["action":"register", "email":email, "password":password, "username": username] as Dictionary<String, String>
        
        println("logging in...")
        
        RequestDealer.auth(params, path: path + "/api/user/new", myVC: self, method:"POST")
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
}