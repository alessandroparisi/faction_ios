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
                    if (httpResponse.statusCode == 520){
                        if let vc = myVC as? SearchUsersViewController {
                            self.showMessage("Friend request sent", vc: vc)
                        }
                    }
                    else if (httpResponse.statusCode >= 500){
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
                                
                                self.getAllInfoOnLogin(vc, factionVC:nil, chooseVC: nil, com: nil, g:nil)
                                
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
                                            if isRight {
                                                self.showMessage("correct", vc: myVC!)
                                            }
                                            else {
                                                self.showMessage("incorrect", vc: myVC!)
                                            }
                                        }
                                    }
                                }
                            }
                            break
                        case "deleteFriend":
                            if let vc = myVC as? FriendsViewController {
                                self.getAllInfoOnLogin(vc, factionVC:nil, chooseVC: nil, com:nil, g:nil)
                            }
                        case "deleteFaction":
                            if let vc = myVC as? ReceivedFactionsViewController {
                                self.getAllInfoOnLogin(nil, factionVC:vc, chooseVC: nil, com:nil, g:nil)
                            }
                        case "addComment":
                            if let vc = myVC as? CommentsViewController {
//                                self.showMessage("Comment posted", vc: vc)
                                self.getAllInfoOnLogin(nil, factionVC: nil, chooseVC: nil, com: vc, g:nil)
                            }
                        case "createGroup":
                            if let vc = myVC as? Group {
                                //self.showMessage("Group created", vc: vc)
                                self.getAllInfoOnLogin(nil, factionVC: nil, chooseVC: nil, com: nil, g:vc)
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
 
    class func sendFactPOST(params: Dictionary<String,AnyObject>, path: String, myVC: UIViewController?, method:String, action:String, im: UIImage?) -> Int{
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
                        if let i = im {
                            
                            if let res = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &err) as? Dictionary<String,AnyObject> {

                                if let d = res["data"] as? Dictionary<String,String> {
                                    let q = d["factionId"]!
                                    println("FACITON ID: \(q)")
                                    let imageData = UIImageJPEGRepresentation(i, 0.125)
                                    
                                    i.resize(CGSize(width: 306, height: 408), completionHandler: { (resizedImage, data) -> () in
                                        var err: NSError?
                                        
                                        let url = NSURL(string: "https://faction.notscott.me" + "/api/factions/upload-image")
                                        let request = NSMutableURLRequest(URL: url!)
                                        request.HTTPMethod = "POST"
                                        
                                        let uniqueId = NSProcessInfo.processInfo().globallyUniqueString
                                        var boundary:String = "----WebKitFormBoundary\(uniqueId)"
                                        
                                        var postBody:NSMutableData = NSMutableData()
                                        var postData:String = String()
                                        
                                        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField:"Content-Type")
                                        
                                        postData += "--\(boundary)\r\n"
                                        
                                        postData += "Content-Disposition: form-data; name=\"factionId\"\r\n\r\n"
                                        postData += "\(q)\r\n"
                                        postData += "--\(boundary)\r\n"
                                        
                                        postData += "Content-Disposition: form-data; name=\"image\"; filename=\"\(Int64(NSDate().timeIntervalSince1970*1000)).jpg\"\r\n"
                                        postData += "Content-Type: image/jpeg\r\n\r\n"
                                        
                                        postBody.appendData(postData.dataUsingEncoding(NSUTF8StringEncoding)!)
                                        postBody.appendData(data)
                                        
                                        postData = String()
                                        postData += "\r\n"
                                        postData += "\r\n--\(boundary)--\r\n"
                                        postBody.appendData(postData.dataUsingEncoding(NSUTF8StringEncoding)!)
                                        
                                        request.HTTPBody = NSData(data: postBody)
                                        
                                        
                                        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error -> Void in
                                            
                                            if((error) != nil){
                                                println(error)
                                            }
                                            else{
                                                println(response)
                                                if let httpResponse = response as? NSHTTPURLResponse {
                                                    println(httpResponse.statusCode)
                                                    if let jsonL: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &err) as AnyObject? {
                                                        println(jsonL)
                                                    }
                                                    if httpResponse.statusCode == 201 ||  httpResponse.statusCode == 200{
                                                        
                                                        if let vc = myVC as? ChooseFriendViewController {
                                                            self.showMessage("faction sent!", vc: vc)
                                                        }
                                                    }
                                                    
                                                }
                                            }
                                        }
                                        task.resume()
                                    })
                                }
                            }


                        }
                        else {
                            if let vc = myVC as? ChooseFriendViewController {
                                self.showMessage("faction sent!", vc: vc)
                            }
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
    class func sendFaction(users:[String], factionText: String, answer:Bool, vc:UIViewController, im: UIImage?, com: Bool){
        println("COM: \(com)")
        let params = ["to":users,"faction":factionText,"fact":answer, "commentsEnabled":com] as Dictionary<String, AnyObject>
        self.sendFactPOST(params, path: path + "/api/factions/send", myVC: vc, method:"POST" , action: "sendFaction", im: im)
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
    class func commentFaction(factionId:String, content: String, vc:UIViewController){
        var params = ["factionId" : factionId, "content": content] as Dictionary<String, String>
        self.post(params, path: path + "/api/factions/add-comment", myVC: vc, method: "POST", action: "addComment")
    }
    class func createGroup(users:[String], name:String, vc: UIViewController){
        let params = ["friends":users,"name":name] as Dictionary<String, AnyObject>
        self.post(params, path: path + "/api/group/create", myVC: vc, method:"POST" , action: "createGroup")
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
    class func getAllInfoOnLogin(friendVC: FriendsViewController?, factionVC: ReceivedFactionsViewController?, chooseVC: ChooseFriendViewController?, com: CommentsViewController?, g: Group?){
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
                            self.addAllUnansweredFactions(unasweredFactions, factionVC: factionVC)
                        }
                        if let factionsReceived = info["factionsReceived"]! as? [Dictionary<String,AnyObject>]{
                            self.addAllFactionsRecieved(factionsReceived, factionVC: factionVC)
                        }
                        if let factionsSent = info["factionsSent"]! as? [Dictionary<String,AnyObject>]{
                            self.addAllFactionsSent(factionsSent, factionVC: factionVC)
                        }
                        if let grr = info["groups"] as? [Dictionary<String, AnyObject>] {
                            self.addGroups(grr)
                        }
                        
                        var err: NSError?
                        
                        let url2 = NSURL(string: "https://faction.notscott.me/api/user/top-three")
                        let task2 = NSURLSession.sharedSession().dataTaskWithURL(url2!) {(data, response, error) in

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
                            else{
                                if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                                    if let info = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &err) as? Dictionary<String, AnyObject>{
                                        if let data = info["data"] as? Dictionary<String, Array<String>>{
                                            if let tt = data["topThree"] {
                                                sh?.topThree = tt
                                                //println("TOP THREE \(sh?.topThree)")
                                                if let f = friendVC {
                                                    if let tableView = f.tableView {
                                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in tableView.reloadData() })
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        task2.resume()
//
//                        if let factionResponses = info["factionResponses"]! as? [Dictionary<String,AnyObject>]{
//                            self.addAllFactionResponses(factionResponses)
//                        }
                        if let f = friendVC {
                            if let tableView = f.tableView {
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in tableView.reloadData() })
                            }
                        }
//                        if let f = factionVC {
//                            if let tableView = f.tableView {
//                                dispatch_async(dispatch_get_main_queue(), { () -> Void in tableView.reloadData() })
//                            }
//                        }
                        if let f = chooseVC {
                            if let tableView = f.tableView {
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in tableView.reloadData() })
                            }
                        }
                        if let f = com {
                            if let tableView = f.tableView {
                                println("reload")
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in tableView.reloadData() })
                            }
                        }
                        if let f = g {
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
    class func addGroups(grr: [Dictionary<String, AnyObject>]){
        sh?.groups.removeAll()
        for g in grr {
            sh?.groups.append(Grp(d: g))
        }
    }
    class func addAllUnansweredFactions(factions:[Dictionary<String,AnyObject>], factionVC: ReceivedFactionsViewController?){
        sh?.unansweredFactions.removeAll()
        if let ansFactDB = sh?.unansweredFactions {
            let ansFactDB_ids = ansFactDB.map{$0.id}
            for faction in factions {
                if find(ansFactDB_ids, faction["factionId"] as String) == nil {
                    if let q = faction["imageUrl"] as? String{
                        var err: NSError?
                        
                        let url = NSURL(string:path + "/" + q)
                        
                        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
                            if(error != nil){
                                println(error)
                            }
                            else{
                                sh?.unansweredFactions.append(NonDBFaction(faction: faction, data: data))
                                if let f = factionVC {
                                    if let tableView = f.tableView {
                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in tableView.reloadData() })
                                    }
                                }
                            }
                        }
                        task.resume()
                    }
                    else{
                        sh?.unansweredFactions.append(NonDBFaction(faction: faction, data:nil))
                        if let f = factionVC {
                            if let tableView = f.tableView {
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in tableView.reloadData() })
                            }
                        }
                    }
                }
            }
        }
    }
    class func addAllFactionsSent(factionsReceived:[Dictionary<String,AnyObject>], factionVC: ReceivedFactionsViewController?){
        sh?.factionsSent.removeAll()
        if let ansFactDB = sh?.factionsSent {
            let ansFactDB_ids = ansFactDB.map{$0.id}
            for faction in factionsReceived {
                if find(ansFactDB_ids, faction["factionId"] as String) == nil {
                    
                    var myFaction = ["sender": "me", "story":faction["story"]!, "fact": faction["fact"]!, "factionId":faction["factionId"]!, "commentsEnabled":faction["commentsEnabled"]!, "comments":faction["comments"]!] as Dictionary<String, AnyObject>
                    
                    if let q = faction["imageUrl"] as? String{
                        var err: NSError?
                        
                        let url = NSURL(string:path + "/" + q)
                        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
                            println("GET IMAGE ***")
                            if(error != nil){
                                println(error)
                            }
                            else{
                                sh?.factionsSent.append(NonDBFaction(faction: myFaction, data: data))
                                if let f = factionVC {
                                    if let tableView = f.tableView {
                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in tableView.reloadData() })
                                    }
                                }
                            }
                        }
                        task.resume()
                    }
                    else{
                        sh?.factionsSent.append(NonDBFaction(faction: myFaction, data:nil))
                        if let f = factionVC {
                            if let tableView = f.tableView {
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in tableView.reloadData() })
                            }
                        }
                    }
                }
            }
        }
    }
    class func addAllFactionsRecieved(factionsReceived:[Dictionary<String,AnyObject>], factionVC: ReceivedFactionsViewController?){
        sh?.factionsReceived.removeAll()
        if let ansFactDB = sh?.factionsReceived {
            let ansFactDB_ids = ansFactDB.map{$0.id}
            for faction in factionsReceived {
                if find(ansFactDB_ids, faction["factionId"] as String) == nil{
                    if let q = sh?.unansweredFactions {
                        if find(q.map{$0.id}, (faction["factionId"] as String)) == nil {
                            if let q = faction["imageUrl"] as? String{
                                var err: NSError?
                                
                                let url = NSURL(string:path + "/" + q)
                                
                                let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
                                    if(error != nil){
                                        println(error)
                                    }
                                    else{
                                        sh?.factionsReceived.append(NonDBFaction(faction: faction, data: data))
                                        if let f = factionVC {
                                            if let tableView = f.tableView {
                                                dispatch_async(dispatch_get_main_queue(), { () -> Void in tableView.reloadData() })
                                            }
                                        }
                                    }
                                }
                                task.resume()
                            }
                            else{
                                sh?.factionsReceived.append(NonDBFaction(faction: faction, data:nil))
                                if let f = factionVC {
                                    if let tableView = f.tableView {
                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in tableView.reloadData() })
                                    }
                                }
                            }
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
extension UIImage {
    public func resize(size:CGSize, completionHandler:(resizedImage:UIImage, data:NSData)->()) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { () -> Void in
            var newSize:CGSize = size
            let rect = CGRectMake(0, 0, newSize.width, newSize.height)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            self.drawInRect(rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let imageData = UIImageJPEGRepresentation(newImage, 0.5)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(resizedImage: newImage, data:imageData)
            })
        })
    }
}