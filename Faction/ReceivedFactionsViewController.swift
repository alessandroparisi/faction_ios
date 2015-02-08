//
//  ReceivedFactionsViewController.swift
//  Faction
//
//  Created by Alessandro Parisi on 2015-02-01.
//  Copyright (c) 2015 Alessandro Parisi. All rights reserved.
//

import Foundation
import UIKit

class ReceivedFactionsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewWillAppear(animated: Bool) {
        var tabBar = self.tabBarController!
        
        var friendsNav = tabBar.viewControllers?[0] as UINavigationController
        var friendsVC = friendsNav.viewControllers?[0] as FriendsViewController

        
        //RequestDealer.updateDB(friendsVC, factionVC: self)
        RequestDealer.getAllInfoOnLogin(friendsVC, factionVC: self, chooseVC: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("sent \(sh?.factionsReceived)")
        println("received \(sh?.factionsSent)")

        switch(section){
        case 0:
            if let s = sh?.factionsReceived {
                println(sh?.factionsReceived)
                return s.count
            }
            else{
                return 0
            }
        case 1:
            if let q = sh?.factionsSent {
                return q.count
            }
            else {
                return 0
            }
        default: return 0
        }
    }
    func tableView( tableView : UITableView,  titleForHeaderInSection section: Int)->String
    {
        switch(section)
        {
        case 0: return "Received Factions"
        case 1: return "Sent Factions"
        default:return ""
        }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        // DISPLAY DATA
        if(indexPath.section == 0){
            if let f = sh?{
                let s = f.factionsReceived[indexPath.row]
                if let q = s.sender as String?{
                    cell.textLabel?.text = "Faction from \(q)"
                }
            }
        }
        else{
            if let f = sh? {
                let s = f.factionsSent[indexPath.row]
                cell.textLabel?.text = "Faction sent"
            }
            cell.selectionStyle = .None
        }
        return cell
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        println("getting text")
        if(indexPath.section == 0){
            if let t = sh?.factionsReceived[indexPath.row].story {
                self.performSegueWithIdentifier("view_faction", sender: t)
            }
        }
        else{
            if let t = sh?.factionsSent[indexPath.row].story {
                self.performSegueWithIdentifier("view_faction", sender: t)
            }
        }
        
    }
//    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var vc = segue.destinationViewController as AnswerFactionViewController
        if let t = sender as? String {
            println("setting text \(t)")
            vc.textViewText = t
        }
    }
//
    
    func getFactions() -> Void {
    
        
//        let url = NSURL(string: path + "/api/update")
//        let session = NSURLSession.sharedSession()
//        let dataTask = session.dataTaskWithURL(url!, completionHandler: { (data: NSData!, response:NSURLResponse!,
//            error: NSError!) -> Void in
//            println("ok")
//            println(response)
//            println(error)
//            println(data)
//            var err: NSError?
//            let jsonDict = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &err) as NSDictionary
//            println(jsonDict)
//
//            self.factions = jsonDict["factions"] as Array
//            println(self.factions)
//        })
    }
    
}