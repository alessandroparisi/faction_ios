//
//  RequestDealer.swift
//  Faction
//
//  Created by Leonardo Siracusa on 2015-02-06.
//  Copyright (c) 2015 Leonardo Siracusa. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class RequestDealer {
    
    
    class func auth(params: Dictionary<String,String>, path: String, myVC: UIViewController?, method:String, action:String) -> Int{
        var err: NSError?
        
        let url = NSURL(string: path)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if method != "register" && method != "login" {
            if let l = KeychainManager.stringForKey("id"){
                request.addValue("sails.sid=\(l)", forHTTPHeaderField:"Cookie")
            }
        }

        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)

        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error -> Void in
            if((error) != nil){
                println(error)
            }
            else{
                //println(response)
                if let httpResponse = response as? NSHTTPURLResponse {
                    println(httpResponse.statusCode)
                    if(httpResponse.statusCode == 401){
                        if(action == "login"){
                            if let jsonL = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &err) as? Dictionary<String,String> {
                                println(jsonL)
                               // let r = jsonL[0]
                                if let lErr = jsonL["error"] {
                                    self.showMessage(lErr, vc: myVC!)
                                    println(lErr)
                                }
                            }
                        }
                        
                    }
                    else if(httpResponse.statusCode == 200){
                        
                        switch action {
                        case "login", "register":
                            if let vc = myVC {
                            
                                var userDefaults = NSUserDefaults.standardUserDefaults()
                                
                                if (action == "login"){
                                    userDefaults.setValue(params["identifier"], forKey: "username")
                                }
                                else{
                                    userDefaults.setValue(params["username"], forKey: "username")
                                }
                                userDefaults.synchronize()
                                
                                self.storeSessionCookie()
                                vc.navigationController!.dismissViewControllerAnimated(true, completion: nil)
                                println("logged in")
                                newLogin = true
                            }
                        case "changePass":
                            println("password changed successfully")
                            break
                        case "sendFriendRequest":
                            
                            if let res = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &err) as? Dictionary<String,String> {
                                if let friendErr = res["error"] {
                                    println(friendErr)
                                    self.showMessage(friendErr, vc: myVC!)
                                }
                                else{
                                    if let mes = res["message"] {
                                        println(mes)
                                    }
                                    println("friend request sent")
                                    self.showMessage("Friend request sent!", vc: myVC!)
                                }
                            }
                            break
                        case "logout":
                            var userDefaults = NSUserDefaults.standardUserDefaults()
                            userDefaults.removeObjectForKey("username")
                            KeychainManager.removeItemForKey("id")
                            if let vc = myVC as? SettingsViewController {
                                if let myTabVC = vc.tabBarController! as? MainTabBarController {
                                    myTabVC.viewDidAppear(true)
                                }
                            }
                            println("logout successful")
                            break
                        case "acceptFriendRequest":
                            if let vc = myVC as? FriendsViewController{
                                self.updateDatabaseFriends(params)
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
//                    else{
//                        switch action {
//                            case "login":
//                                self.showMessage("Login failed", vc: myVC!)
//                            default:
//                                //should never happen
//                                println("invalid action")
//                            break
//                        }
//                        
//                        /*
//                        switch action {
//                        case "login", "register":
//                            if let info = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &err) as? Dictionary<String,String>{
//                                if let err = info["error"] {
//                                    var alert = UIAlertController(title: "Alert", message: err, preferredStyle: UIAlertControllerStyle.Alert)
//                                    myVC?.presentViewController(alert, animated: true, completion: nil)
//                                }
//                            }
//                        default:
//                            //should never happen
//                            println("invalid action")
//                            break
//                        }*/
//                    }
                }
                else {
                    println("failed")
                    assertionFailure("unexpected response")
                }
            }
        }
        task.resume()
        
        return 0
    }
 
    class func login(username:String, password:String, vc:UIViewController){
        let params = ["identifier":username, "password": password] as Dictionary<String, String>
        RequestDealer.auth(params, path: path + "/api/user/login", myVC: vc, method:"POST", action:"login")
    }
    class func register(username:String, password:String, email:String, vc:UIViewController){
        let params = ["action":"register", "email":email, "password":password, "username": username] as Dictionary<String, String>
        RequestDealer.auth(params, path: path + "/api/user/new", myVC: vc, method:"POST", action:"register")
    }
    class func logout(vc:UIViewController){
        var emptyDic = Dictionary<String, String>()
        //KeychainManager.removeItemForKey("id")

        self.auth(emptyDic, path: path + "/api/user/logout", myVC: vc, method: "POST", action:"logout")
    }
    class func changePassword(oldPass:String, newPass:String){
        var params = ["old":oldPass, "new":newPass]
        self.auth(params, path: path + "/api/user/update-password", myVC:nil, method:"PUT", action:"changePass")
    }
    
    class func sendFriendRequest(friend:String, vc: UIViewController){
        var params = ["username":friend]
        self.auth(params, path: path + "/api/user/request-friend", myVC: vc, method:"POST", action:"sendFriendRequest")
    }
    class func acceptedFriendRequest(username:String, accepted:String, vc: UIViewController){
        var params = ["username":username, "accepted":accepted]
        self.auth(params, path: path + "/api/user/accept-friend", myVC: vc, method: "POST", action: "acceptFriendRequest")
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

    
    class func aleHasAShittyAuth(params: Dictionary<String,AnyObject>, path: String, myVC: UIViewController?, method:String) {
        var err: NSError?
        println(params)
        let url = NSURL(string: path)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let l = params as Dictionary<String, AnyObject>
        
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(l, options: nil, error: &err)
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error -> Void in
            if((error) != nil){
                println(error)
            }
            else{
                //println(response)
                if let httpResponse = response as? NSHTTPURLResponse {
                    println(httpResponse.statusCode)
                    if(httpResponse.statusCode == 201){
                        println("Success, Faction sent")
                    }
                    else if(httpResponse.statusCode == 400){
                        println(data)
                        if let res = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &err) as String?{
                            println("res:  \(res)")
//                            if let myerr = res["error"] {
//                                println(myerr)
//                            }
//                            else{
//                                println("friend request sent")
//                            }
                        }
                    }
                    else{
                        println("Failure, Error.. something went terribly wrong")
                        
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

    class func updateDB(friendVC:FriendsViewController, factionVC: ReceivedFactionsViewController?){
        var err: NSError?
        
        let url = NSURL(string: path + "/api/update")
        
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            //println(response)
            if(error != nil){
                println(error)
            }
            println("-------------------------------------------")
            println("-------------------------------------------")
            if let info = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &err) as? Dictionary<String, AnyObject>{
                println(info)
                if let pending_requests = info["pending_requests"] as? [String]{
                    self.addPendingFriendRequests(pending_requests)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in friendVC.tableView.reloadData() })
                }
                if let unansweredFactions = info["factions"] as? [Dictionary<String,String>]{
                    var arrayOfFactions = [NonDBFaction]()
                    unansweredFactions.map{arrayOfFactions.append(NonDBFaction(faction: $0))}
                    self.addUnansweredFactions(arrayOfFactions)
                    
                    if let factTable = factionVC?.tableView {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in factTable.reloadData() })
                    }
                }
            }
        }
        
        task.resume()
    }
    
    class func addPendingFriendRequests(pending_requests:[String]){
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        loadFriendData()
        
        if let fr = sh?.pendingFriends {
            //println("fr: \(fr)")
            let receivedUsernamesInDB = fr.map{$0.username}
            for req in pending_requests {
                if find(receivedUsernamesInDB, req) == nil{
                    println("adding friend \(req) to ReceivedRequestsFriends")
                    //Friend.createInManagedObjectContext(managedContext, username: req)
                    sh?.pendingFriends.append(Friend.createInManagedObjectContext(managedContext, username: req, entityName:"ReceivedRequestFriends"))
                    var error: NSError?
                    if !managedContext.save(&error) {
                        println("Could not save \(error), \(error?.userInfo)")
                    }
                }
            }
            //loadFriends(managedContext, entityName:"ReceivedRequestFriends")
        }
    }
    class func updateDatabaseFriends(params:Dictionary<String,String>){
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
        
        if let fr = sh?.friends {
            //println("fr: \(fr)")
            let receivedUsernamesInDB = fr.map{$0.username}
            if find(receivedUsernamesInDB, username) == nil{
                println("adding friend \(username) to Friend")
                sh?.friends.append(Friend.createInManagedObjectContext(managedContext, username: username, entityName:"Friends"))
                var error: NSError?
                if !managedContext.save(&error) {
                    println("Could not save \(error), \(error?.userInfo)")
                }
                //loadFriends(managedContext, entityName:"Friends")
                //dispatch_async(dispatch_get_main_queue(), { () -> Void in vc.tableView.reloadData() })
            }
        }
    }
    
    class func loadFriendData(){
        let appDel = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDel.managedObjectContext!
        
        loadFriends(managedContext, entityName:"ReceivedRequestFriends")
        loadFriends(managedContext, entityName:"Friends")
    }
    class func loadFriends(managedContext: NSManagedObjectContext, entityName: String){
        let fetchRequest = NSFetchRequest(entityName: entityName)
        
        var error:NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [Friend]
        
        if let results = fetchedResults {
            println("\(entityName) results: \(results)")
            if entityName == "Friends"{
                sh?.friends = results
            }
            else{
                sh?.pendingFriends = results
            }
            //self.deleteObjects(managedContext, results: results)
        }
            
        else{
            println("Could not fetch \(entityName): \(error)")
        }
        
    }
    class func deleteObjectsFriend(managedContext: NSManagedObjectContext, results: [Friend]){
        for r in results {
            managedContext.deleteObject(r)
        }
        managedContext.save(nil)
    }
    
    class func getAllInfoOnLogin(){
//        var err: NSError?
//        
//        let url = NSURL(string: path + "/api/user/info")
//        
//        
//        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
//            //println(response)
//            if(error != nil){
//                println(error)
//            }
//            if let info = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &err) as? Dictionary<String, AnyObject>{
//                println(info)
//                if let pending_requests = info["pending_requests"]{
//                    
//                }
//            }
//        }
//        
//        task.resume()
    }
    class func addUnansweredFactions(unanswered_factions:[NonDBFaction]){
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        loadFactionData()
        
        
        if let fr = sh?.unansweredFactions {
            //println("fr: \(fr)")
            let unansweredFactionsInDB = fr.map{$0.id}
            for faction in unanswered_factions {
                if find(unansweredFactionsInDB, faction.id) == nil{
                    println("adding faction \(faction) to UnansweredFactions")
                    sh?.unansweredFactions.append(Faction.createInManagedObjectContext(managedContext, entityName: "UnansweredFactions", id: faction.id, story: faction.story, sender: faction.sender, fact: faction.fact))
                    var error: NSError?
                    
                    if !managedContext.save(&error) {
                        println("Could not save \(error), \(error?.userInfo)")
                    }
                }
            }
            //loadFriends(managedContext, entityName:"ReceivedRequestFriends")
        }
    }
//    class func updateDatabaseFactions(params:Dictionary<String,String>){
//        self.saveNewFaction(<#username: String#>)
//    }
//    class func saveNewFaction(id:String, ){
//        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
//        let managedContext = appDelegate.managedObjectContext!
//        
//        if let fr = sh?.answeredFactions {
//            //println("fr: \(fr)")
//            let receivedUsernamesInDB = fr.map{$0.id}
//            if find(receivedUsernamesInDB, username) == nil{
//                println("adding friend \(username) to Friend")
//                sh?.friends.append(Friend.createInManagedObjectContext(managedContext, username: username, entityName:"Friends"))
//                var error: NSError?
//                if !managedContext.save(&error) {
//                    println("Could not save \(error), \(error?.userInfo)")
//                }
//                //loadFriends(managedContext, entityName:"Friends")
//                //dispatch_async(dispatch_get_main_queue(), { () -> Void in vc.tableView.reloadData() })
//            }
//        }
//    }

    class func loadFactionData(){
        let appDel = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDel.managedObjectContext!
        
        loadFactions(managedContext, entityName:"UnansweredFactions")
        loadFactions(managedContext, entityName:"AnsweredFaction")
    }
    class func loadFactions(managedContext: NSManagedObjectContext, entityName: String){
        let fetchRequest = NSFetchRequest(entityName: entityName)
        
        var error:NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [Faction]
        
        if let results = fetchedResults {
            println("\(entityName) results: \(results)")
            if entityName == "AnsweredFaction"{
                sh?.answeredFactions = results
            }
            else{
                sh?.unansweredFactions = results
            }
            //self.deleteObjects(managedContext, results: results)
        }
            
        else{
            println("Could not fetch \(entityName): \(error)")
        }
        
    }
    class func deleteObjects(managedContext: NSManagedObjectContext, results: [Friend]){
        for r in results {
            managedContext.deleteObject(r)
        }
        managedContext.save(nil)
    }
    class func showMessage(message: String, vc: UIViewController) -> Void {
        println("Message to be sent: \(message)")
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let alertController = UIAlertController(title: "Notice", message:
                message, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            vc.presentViewController(alertController, animated: true, completion: nil)
        })
        
        
        
    }
    
    
}