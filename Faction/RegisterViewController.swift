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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        title = "Register"
    }
    
    
    @IBAction func register(sender: UIButton) {
        if(usernameTextField.text != "" && passwordTextField.text != "" && emailTextField.text != ""){
            self.registerUser(usernameTextField.text, password: passwordTextField.text, email:emailTextField.text)
        }
    }
    
    func registerUser(username: String, password: String, email: String) {
//        var loginRef = myRef.childByAppendingPath("login")
//        loginRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
//            var snapDict = snapshot.value as Dictionary<String,String>
//            var val = snapDict[username] as String?
//            if(val == nil){ // we also need to validate if the username is valid (does not contain . # ..predefined fireabse shit
//                println("username doesnt exists")
//                
//                self.authClient = FirebaseSimpleLogin(ref:self.myRef)
//                self.authClient.createUserWithEmail(email, password: password,
//                    andCompletionBlock: { error, user in
//                        
//                        if (error != nil) {
//                            // There was an error creating the account
//                            println(error)
//                        }
//                        else {
//                            println("created user");
//                            
//                            var newLoginData = [username:String(user.uid)]
//                            loginRef.updateChildValues(newLoginData)
//                            println("account added to login Data")
//                            
//                            var userRef = self.myRef.childByAppendingPath("users")
//                            var newUserData = [user.uid: ["email":email, "username": username]]
//                            userRef.updateChildValues(newUserData)
//                            println("account created in users")
//                            var loginVC = self.navigationController?.viewControllers[0] as LoginViewController
//                            loginVC.usernameTextField.text = username
//                            self.navigationController?.popViewControllerAnimated(true)
//                        }
//                })
//            }
//            else{
//                println("username already exists")
//            }
//            
//            },
//            withCancelBlock: { error in
//                println(error.description)
//        })
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
}