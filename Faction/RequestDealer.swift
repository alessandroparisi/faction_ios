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
    
    
    class func auth(params: Dictionary<String,String>, path: String, myVC: UIViewController?) {
        var err: NSError?
        
        let url = NSURL(string: path)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
       
        println("logging in...")

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
                        else{
                            println("logout successful")
                        }
                    }
                } else {
                    println("failed")
                    assertionFailure("unexpected response")
                }
            }
        }
        task.resume()
    }
    class func logout(){
        var emptyDic = Dictionary<String, String>()

        self.auth(emptyDic, path: path + "/api/user/logout", myVC: nil)
    }
}