//
//  LoginViewController.swift
//  Faction
//
//  Created by Alessandro Parisi on 2015-02-01.
//  Copyright (c) 2015 Alessandro Parisi. All rights reserved.
//

import Foundation
import UIKit

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
            self.authUser(usernameTextField.text, password:passwordTextField.text)
        }
    }
    
    @IBAction func register(sender: UIButton) {
        performSegueWithIdentifier("to_register", sender: nil)
    }
    
    func authUser(username:String, password:String) {
        
//        authClient = FirebaseSimpleLogin(ref:myRef)
//        authClient.loginWithEmail(username, andPassword: password,
//            withCompletionBlock: { error, user in
//                
//                if (error != nil) {
//                    
//                    var loginRef = self.myRef.childByAppendingPath("login")
//                    loginRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
//                        var snapDict = snapshot.value as Dictionary<String,String>
//                        var val = snapDict[username] as String?
//                        if(val != nil){
//                            var userEmailRef = self.myRef.childByAppendingPath("users").childByAppendingPath(val! as String).childByAppendingPath("email")
//                            userEmailRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
//                                self.authClient.loginWithEmail(snapshot.value as String, andPassword: password,
//                                    withCompletionBlock: { error, user in
//                                        if( error != nil){
//                                            println(error)
//                                        }
//                                        else{
//                                            println("logging in...")
//                                            self.performSegueWithIdentifier("chat_login", sender: user)
//                                            println("logged in")
//                                        }
//                                })
//                            })
//                            
//                        }
//                        else{
//                            println("error::")
//                            println(error)
//                        }
//                    })
//                }
//                else {
//                    
//                    println("logging in...")
//                    self.performSegueWithIdentifier("chat_login", sender: user)
//                    println("logged in")
//                }
//        })
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if(segue.identifier == "chat_login"){

        }
        
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
}