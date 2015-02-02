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
            self.authUser(usernameTextField.text, password:passwordTextField.text)
        }
    }
    
    @IBAction func register(sender: UIButton) {
        performSegueWithIdentifier("to_register", sender: nil)
    }
    
    func authUser(username:String, password:String) {
        
        let loginPath = path + "/api/user/login"
        let url = NSURL(string: loginPath)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        let myDict = ["email":username, "password":password] as Dictionary<String, String>
        let dataLogin: NSData = NSKeyedArchiver.archivedDataWithRootObject(myDict)

        
        let task = NSURLSession.sharedSession().uploadTaskWithRequest(request, fromData: dataLogin) { data, response, error -> Void in
            if((error) != nil){
                println(error)
            }
            else{
            
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
        
//        let task = NSURLConnection.sendAsynchronousRequest(request, fromData: dataLogin, completionHandler: { data, response, error -> Void in
//            
//            println("JSON recieved")
//
//            if((error) != nil)
//            {
//                println(error.localizedDescription)
//            }
//            
//            println("Parsing JSON")
//            var err: NSError?
//            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
//            
//            if(err != nil)
//            {
//                println("Json error");
//            }
//            println("Building Array result list from JSON")
//            
//            println(jsonResult["results"])
//            //var results = jsonResult["results"] as NSArray
//            //self.delegate?.didReceiveAPIResult(jsonResult)
//            
//            println("Done with JSON response")
//            
//        })
        task.resume()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
}