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
        let loginPath = path + "/api/user/new"
        let url = NSURL(string: loginPath)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        let myDict = ["email":email, "password":password, "username": username] as Dictionary<String, String>
        let dataLogin: NSData = NSKeyedArchiver.archivedDataWithRootObject(myDict)
        
        
        let task = NSURLSession.sharedSession().uploadTaskWithRequest(request, fromData: dataLogin) { data, response, error -> Void in
            if((error) != nil){
                println(error)
            }
            else{
                //println(data)
                //println(response)
                if let httpResponse = response as? NSHTTPURLResponse {
                    println(httpResponse.statusCode)
                    if(httpResponse.statusCode == 200){
                        println("logging in...")
                        //self.performSegueWithIdentifier("chat_login")
                        println("logged in")
                    }
                } else {
                    assertionFailure("unexpected response")
                }
            }
        }
        task.resume()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
}