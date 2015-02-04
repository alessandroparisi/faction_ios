//
//  RequestDealer.swift
//  Faction
//
//  Created by Alessandro Parisi on 2015-02-02.
//  Copyright (c) 2015 Alessandro Parisi. All rights reserved.
//

import Foundation
import UIKit

class RequestDealer {
    
    
    class func auth(params: Dictionary<String,String>, path: String, myVC: UIViewController?, method:String) {
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
                println(data)
                println(response)
                if let httpResponse = response as? NSHTTPURLResponse {
                    println(httpResponse.statusCode)
                    if(httpResponse.statusCode == 200){
                        if let vc = myVC {
                            vc.navigationController!.dismissViewControllerAnimated(true, completion: nil)
                            println("logged in")
                        }
                        else if (method == "PUT"){
                            println("password changed successfully")
                        }
                        else{
                            println("logout successful")
                        }
                    }
                        //leo
                    else if(httpResponse.statusCode == 201){
                        println("Congratumylations you have added a friend")
                    }
                    else if(httpResponse.statusCode == 404){
                        println("Shit doesn't work, help ale")
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
    
    class func logout(){
        var emptyDic = Dictionary<String, String>()

        self.auth(emptyDic, path: path + "/api/user/logout", myVC: nil, method: "POST")
    }
    class func changePassword(oldPass:String, newPass:String){
        var params = ["old":oldPass, "new":newPass]
        self.auth(params, path: path + "/api/user/update-password", myVC:nil, method:"PUT")
    }
    
    class func addFriend(friend:String){
        var params = ["username":friend]
        self.auth(params, path: path + "/api/user/request-friend", myVC:nil, method:"POST")
    }
    
    
    
    
    
}