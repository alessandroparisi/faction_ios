//
//  RequestDealer.swift
//  Faction
//
//  Created by Alessandro Parisi on 2015-02-02.
//  Copyright (c) 2015 Alessandro Parisi. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class RequestDealer {
    
    
    class func auth(params: Dictionary<String,String>, path: String, myVC: UIViewController?, method:String, action:String) {
        var err: NSError?
        
        let url = NSURL(string: path)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
       

        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error -> Void in
            if((error) != nil){
                println(error)
            }
            else{
                println(response)
                if let httpResponse = response as? NSHTTPURLResponse {
                    println(httpResponse.statusCode)
                    if(httpResponse.statusCode == 200){
                        
                        switch action {
                        case "login", "register":
                            if let vc = myVC {
                                self.storeSessionCookie()
                                vc.navigationController!.dismissViewControllerAnimated(true, completion: nil)
                                println("logged in")
                            }
                        case "changePass":
                            println("password changed successfully")
                            break
                        case "sendFriendRequest":
                            println("friend request sent")
                            break
                        case "logout":
                            KeychainManager.removeItemForKey("id")
                            println("logout successful")
                            break
                        case "acceptFriendRequest":
                            if let vc = myVC as? FriendsViewController{
                                self.updateDatabaseFriends(params, myVC:vc)
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in vc.tableView.reloadData() })
                                
                            }
                            
                            println("friend accepted")
                            break
                        default:
                            //should never happen
                            println("invalid action")
                            break
                        }
                        
                        
                    }
                    else{/*
                        switch action {
                        case "login", "register":
                            if let info = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &err) as? Dictionary<String,String>{
                                if let err = info["error"] {
                                    var alert = UIAlertController(title: "Alert", message: err, preferredStyle: UIAlertControllerStyle.Alert)
                                    myVC?.presentViewController(alert, animated: true, completion: nil)
                                }
                            }
                        default:
                            //should never happen
                            println("invalid action")
                            break
                        }*/
                    }
                }
                else {
                    println("failed")
                    assertionFailure("unexpected response")
                }
            }
        }
        task.resume()
    }
    class func login(username:String, password:String, vc:UIViewController){
        let params = ["identifier":username, "password": password] as Dictionary<String, String>
        RequestDealer.auth(params, path: path + "/api/user/login", myVC: vc, method:"POST", action:"login")
    }
    class func register(username:String, password:String, email:String, vc:UIViewController){
        let params = ["action":"register", "email":email, "password":password, "username": username] as Dictionary<String, String>
        RequestDealer.auth(params, path: path + "/api/user/new", myVC: vc, method:"POST", action:"register")
    }
    class func logout(){
        var emptyDic = Dictionary<String, String>()

        self.auth(emptyDic, path: path + "/api/user/logout", myVC: nil, method: "POST", action:"logout")
    }
    class func changePassword(oldPass:String, newPass:String){
        var params = ["old":oldPass, "new":newPass]
        self.auth(params, path: path + "/api/user/update-password", myVC:nil, method:"PUT", action:"changePass")
    }
    
    class func sendFriendRequest(friend:String){
        var params = ["username":friend]
        self.auth(params, path: path + "/api/user/request-friend", myVC:nil, method:"POST", action:"sendFriendRequest")
    }
    class func acceptedFriendRequest(username:String, accepted:String, vc: UIViewController){
        var params = ["username":username, "accepted":accepted]
        self.auth(params, path: path + "api/users/accept-friend", myVC: vc, method: "POST", action: "acceptFriendRequest")
    }
    
    class func storeSessionCookie(){
        var cookie : NSHTTPCookie?
        var cookieJar : NSHTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()

        for cookie in cookieJar.cookies as [NSHTTPCookie]{
            if cookie.name == "sails.sid" {
                if let val = cookie.value {
                    KeychainManager.setString(val, forKey: "id")
                    break
                }
            }
        }
    }
    class func updateDatabaseFriends(params:Dictionary<String,String>, myVC:FriendsViewController){
        if let val = params["accepted"] {
            if val == "true" {
                if let name = params["username"] {
                    self.saveNewFriend(name)
                }
            }
        }
    }
    class func saveNewFriend(username:String){
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        let entity =  NSEntityDescription.entityForName("Friends", inManagedObjectContext: managedContext)
        let friend =  NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
        friend.setValue(username, forKey: "username")
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
    }

    
    
}