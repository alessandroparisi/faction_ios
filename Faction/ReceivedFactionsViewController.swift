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
    
    var currentText: String = ""
    
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

        RequestDealer.updateDB(friendsVC, factionVC: self)
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
        switch(section){
        case 0:
            if let s = sh?.unansweredFactions {
                return s.count
            }
            else{
                return 0
            }
        case 1:
            if let q = sh?.answeredFactions {
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
        case 0: return "Unanaswered Factions"
        case 1: return "Factions"
        default:return ""
        }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        // DISPLAY DATA
        if(indexPath.section == 0){
            if let f = sh?{
                let s = f.unansweredFactions[indexPath.row]
                if let q = s.sender as String?{
                    cell.textLabel?.text = q
                }
            }
        }
        else{
            if let f = sh? {
                let s = f.answeredFactions[indexPath.row]
                if let q = s.sender as String?{
                    cell.textLabel?.text = q
                }
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
        println("Faction at row: \(indexPath.row): has string: \(sh?.unansweredFactions[indexPath.row].story)")
        if let t = sh?.unansweredFactions[indexPath.row].story {
            currentText = t
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var vc = segue.destinationViewController as AnswerFactionViewController
        println("Current text \(currentText)")
        vc.textViewText = currentText
        
    }
    
    
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