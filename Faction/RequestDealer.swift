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
    
    
    class func post(params: Dictionary<String,AnyObject>, path: String, myVC: UIViewController?, method:String, action:String) -> Int{
        var err: NSError?
        
        println("************************request being made!!!********************")
        
        let url = NSURL(string: path)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //add cookie to header (idk if its good)
        if action != "register" && action != "login" {
            if let l = KeychainManager.stringForKey("id"){
                request.addValue("sails.sid=\(l)", forHTTPHeaderField:"Cookie")
            }
        }

        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)

        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error -> Void in
            if((error) != nil){
                if let v = myVC {
                    self.showMessage("could not send request (bad connection)", vc: v)
                }
            }
            else{
                //println(response)
                if let httpResponse = response as? NSHTTPURLResponse {
                    println(httpResponse.statusCode)
                    if (httpResponse.statusCode >= 500){
                        if let v = myVC {
                            println(error)
                            self.showMessage("error", vc: v)
                        }
                    }
                    else if(httpResponse.statusCode == 401 || httpResponse.statusCode == 409 ||
                            httpResponse.statusCode == 403 || httpResponse.statusCode == 400){
                        if let jsonL = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &err) as? Dictionary<String,AnyObject> {
                            if let lErr = jsonL["error"] as? String{
                                if let m = myVC {
                                    self.showMessage(lErr, vc: m)
                                    println(lErr)
                                }
                            }
                        }
                    }
                    else if(httpResponse.statusCode == 200 || httpResponse.statusCode == 201){
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
                            break
                        case "changePass":
                            println("password changed successfully")
                            break
                        case "sendFriendRequest":
                            
                            if let res = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &err) as? Dictionary<String,AnyObject> {
                                if let friendErr = res["error"] as? String{
                                    println(friendErr)
                                    self.showMessage(friendErr, vc: myVC!)
                                }
                                else{
                                    if let mes = res["message"] as? String{
                                        println(mes)
                                        self.showMessage(mes, vc: myVC!)
                                    }
                                    println("friend request sent")
//                                    if let friendVC = myVC as? FriendsViewController {
//                                        self.getAllInfoOnLogin(friendVC, factionVC: nil, chooseVC: nil)
//                                    }
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
                                //self.updateDatabaseFriends(params)
                                //self.updateDB(self, factionVC: s, isNew: <#Bool#>)
                                
                                self.getAllInfoOnLogin(vc, factionVC:nil, chooseVC: nil)
                                
//                                dispatch_async(dispatch_get_main_queue(), { () -> Void in vc.tableView.reloadData() })
                            }
                            println("friend accepted")
                            break
                        case "sendFaction":
                            if let vc = myVC as? ChooseFriendViewController {
                                self.showMessage("faction sent!", vc: vc)
                            }
                            break
                        case "respondFaction":
                            if let vc = myVC as? AnswerFactionViewController {
                                if let res = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &err) as? Dictionary<String,AnyObject> {
                                    println("res: \(res)")
                                    if let data = res["data"] as? Dictionary<String,Bool>{
                                        if let isRight = data["isRight"]{
                                            self.showMessage("\(isRight)", vc: myVC!)
                                        }
                                    }
                                }
                            }
                            break
                        case "deleteFriend":
                            if let vc = myVC as? FriendsViewController {
                                self.getAllInfoOnLogin(vc, factionVC:nil, chooseVC: nil)
                            }
                        case "deleteFaction":
                            if let vc = myVC as? ReceivedFactionsViewController {
                                self.getAllInfoOnLogin(nil, factionVC:vc, chooseVC: nil)
                            }
                        default:
                            //should never happen
                            println("invalid action")
                            break
                        }
                    }
                }
                else {
                    println("failed")
                }
            }
        }
        task.resume()
        
        return 0
    }
 
    class func login(username:String, password:String, vc:UIViewController){
        let params = ["identifier":username, "password": password] as Dictionary<String, String>
        RequestDealer.post(params, path: path + "/api/user/login", myVC: vc, method:"POST", action:"login")
    }
    class func register(username:String, password:String, email:String, vc:UIViewController){
        let params = ["action":"register", "email":email, "password":password, "username": username] as Dictionary<String, String>
        RequestDealer.post(params, path: path + "/api/user/new", myVC: vc, method:"POST", action:"register")
    }
    class func logout(vc:UIViewController){
        var emptyDic = Dictionary<String, String>()
        self.post(emptyDic, path: path + "/api/user/logout", myVC: vc, method: "POST", action:"logout")
    }
    class func changePassword(oldPass:String, newPass:String, vc:UIViewController){
        var params = ["old":oldPass, "new":newPass]
        self.post(params, path: path + "/api/user/update-password", myVC:vc, method:"PUT", action:"changePass")
    }
    
    class func sendFriendRequest(friend:String, vc: UIViewController){
        var params = ["username":friend]
        self.post(params, path: path + "/api/user/request-friend", myVC: vc, method:"POST", action:"sendFriendRequest")
    }
    class func acceptedFriendRequest(username:String, accepted:Bool, vc: UIViewController){
        var params = ["username":username, "accepted":accepted] as Dictionary<String, AnyObject>
        self.post(params, path: path + "/api/user/accept-friend", myVC: vc, method: "POST", action: "acceptFriendRequest")
    }
    class func sendFaction(users:[String], factionText: String, answer:Bool, vc:UIViewController){
        let params = ["to":users,"faction":factionText,"fact":answer] as Dictionary<String, AnyObject>
        self.post(params, path: path + "/api/factions/send", myVC: vc, method:"POST" , action: "sendFaction")
    }
    class func respondFaction(factionID: String, response: Bool, vc: UIViewController){
        var params = ["factionId": factionID, "userResponse": response] as Dictionary <String, AnyObject>
        self.post(params, path: path + "/api/factions/respond", myVC: vc, method: "POST", action: "respondFaction")
    }
    class func deleteFriend(username:String, vc:UIViewController){
        var params = ["username" : username] as Dictionary<String, String>
        self.post(params, path: path + "/api/user/delete-friend", myVC: vc, method: "DELETE", action: "deleteFriend")
    }
    class func deleteFaction(factionId:String, vc:UIViewController){
        var params = ["factionId" : factionId] as Dictionary<String, String>
        self.post(params, path: path + "/api/factions/delete", myVC: vc, method: "POST", action: "deleteFaction")
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

//    class func updateDB(friendVC:FriendsViewController?, factionVC: ReceivedFactionsViewController?){
//        var err: NSError?
//        
//        let url = NSURL(string: path + "/api/user/update")
//        let request = NSMutableURLRequest(URL: url!)
//        request.HTTPMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        var params = ["updateTimestamp":NSUserDefaults.,"viewedFactions":[]()]
//        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
//        
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error -> Void in
//            if((error) != nil){
//                
//            }
//            else{
//                //println(response)
//                if let httpResponse = response as? NSHTTPURLResponse {
//                    println(httpResponse.statusCode)
//
//                  
//                }
//                else {
//                    println("failed")
//                }
//            }
//        }
//        task.resume()
//    }

//    class func splitAndAddFactions(factions: [Dictionary<String, String>]){
//        var userDefaults = NSUserDefaults.standardUserDefaults()
//
//        if let user = userDefaults.valueForKey("username") as? String{
//            for faction in factions {
//                if let sen = faction["sender"]{
//                    if sen == user {
//                        sh?.factionsSent.append(NonDBFaction(faction: faction))
//                    }
//                    else {
//                        sh?.factionsReceived.append(NonDBFaction(faction: faction))
//                    }
//                }
//            }
//        }
//    }
    class func getAllInfoOnLogin(friendVC: FriendsViewController?, factionVC: ReceivedFactionsViewController?, chooseVC: ChooseFriendViewController?){
        var err: NSError?
        
        let url = NSURL(string: path + "/api/user/info")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            //println(response)
            if((error) != nil){
                if let v = friendVC {
                    self.showMessage("could not send request (bad connection)", vc: v)
                }
                else if let v = factionVC {
                    self.showMessage("could not send request (bad connection)", vc: v)
                }
                else if let v = chooseVC {
                    self.showMessage("could not send request (bad connection)", vc: v)
                }
            }
            if let httpResponse = response as? NSHTTPURLResponse {
                println("THE BIG GET \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 200 {
                    if let info = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &err) as? Dictionary<String, AnyObject>{
                        println("THE BIG GET   \(info)")
                        
                        //make sure local db friends are up to date (sync with what we just got)
                        if let friendsGOOD = info["friends"] as? [String]{
                            sh?.friends = friendsGOOD
                        }
                        if let pendingFriends = info["receivedFriendRequests"] as? [String]{
                            sh?.pendingFriends = pendingFriends
                        }
                        if let unasweredFactions = info["pendingFactions"]! as? [Dictionary<String,AnyObject>]{
                            self.addAllUnansweredFactions(unasweredFactions)
                        }
                        if let factionsReceived = info["factionsReceived"]! as? [Dictionary<String,AnyObject>]{
                            self.addAllFactionsRecieved(factionsReceived)
                        }
                        if let factionsSent = info["factionsSent"]! as? [Dictionary<String,AnyObject>]{
                            self.addAllFactionsSent(factionsSent)
                        }
//
//                        if let factionResponses = info["factionResponses"]! as? [Dictionary<String,AnyObject>]{
//                            self.addAllFactionResponses(factionResponses)
//                        }
                        if let f = friendVC {
                            if let tableView = f.tableView {
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in tableView.reloadData() })
                            }
                        }
                        if let f = factionVC {
                            if let tableView = f.tableView {
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in tableView.reloadData() })
                            }
                        }
                        if let f = chooseVC {
                            if let tableView = f.tableView {
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in tableView.reloadData() })
                            }
                        }
                    }
                }
                else{
                }
            }
        }
        
        task.resume()
    }
    
    class func addAllUnansweredFactions(factions:[Dictionary<String,AnyObject>]){
        sh?.unansweredFactions.removeAll()
        if let ansFactDB = sh?.unansweredFactions {
            let ansFactDB_ids = ansFactDB.map{$0.id}
            for faction in factions {
                if find(ansFactDB_ids, faction["factionId"] as String) == nil {
                    sh?.unansweredFactions.append(NonDBFaction(faction: faction))
                }
            }
        }
    }
    class func addAllFactionsSent(factionsReceived:[Dictionary<String,AnyObject>]){
        sh?.factionsSent.removeAll()
        if let ansFactDB = sh?.factionsSent {
            let ansFactDB_ids = ansFactDB.map{$0.id}
            for faction in factionsReceived {
                if find(ansFactDB_ids, faction["factionId"] as String) == nil {
                    var myFaction = ["sender": "me", "story":faction["story"]!, "fact": faction["fact"]!, "factionId":faction["factionId"]!] as Dictionary<String, AnyObject>
                    sh?.factionsSent.append(NonDBFaction(faction: myFaction))
                }
            }
        }
    }
    class func addAllFactionsRecieved(factionsReceived:[Dictionary<String,AnyObject>]){
        sh?.factionsReceived.removeAll()
        if let ansFactDB = sh?.factionsReceived {
            let ansFactDB_ids = ansFactDB.map{$0.id}
            for faction in factionsReceived {
                if find(ansFactDB_ids, faction["factionId"] as String) == nil{
                    if let q = sh?.unansweredFactions {
                        if find(q.map{$0.id}, (faction["factionId"] as String)) == nil {
                            sh?.factionsReceived.append(NonDBFaction(faction: faction))
                        }
                    }
                }
            }
        }
    }
//    class func addAllFactionResponses(factionsReceived:[Dictionary<String,AnyObject>]){
//        sh?.factionResponses.removeAll()
//        if let ansFactDB = sh?.factionResponses {
//            let ansFactDB_ids = ansFactDB.map{$0.id}
//            for faction in factionsReceived {
//                if find(ansFactDB_ids, faction["factionId"] as String) == nil{
//                    sh?.factionResponses.append(FactionResponse(faction: faction))
//                }
//            }
//        }
//    }
    class func showMessage(message: String, vc: UIViewController) -> Void {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let alertController = UIAlertController(title: "Notice", message:
                message, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            vc.presentViewController(alertController, animated: true, completion: nil)
        })
        
        
        
    }
    
    
}