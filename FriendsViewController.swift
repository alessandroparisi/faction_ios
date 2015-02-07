//
//  FriendsViewController.swift
//  Faction
//
//  Created by Alessandro Parisi on 2015-02-01.
//  Copyright (c) 2015 Alessandro Parisi. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FriendsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(animated: Bool) {
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section){
        case 0:
            if let s = sh?.pendingFriends {
                return s.count
            }
            else{
                return 0
            }
        case 1:
            if let q = sh?.friends {
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
        case 0: return "Pending Requests"
        case 1: return "Friends"
        default:return ""
        }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0){
            let cell = self.tableView.dequeueReusableCellWithIdentifier("PotentialFriend") as PotentialFriendCell
            if let f = sh?{
                let s = f.pendingFriends[indexPath.row]
                cell.textLabel?.text = s.valueForKey("username") as? String
            }
            cell.accept.tag = indexPath.row
            cell.decline.tag = indexPath.row
            cell.selectionStyle = .None
            return cell
        }
        else{
            let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
            if let f = sh? {
                let s = f.friends[indexPath.row]
                cell.textLabel?.text = s.valueForKey("username") as? String
            }
            cell.selectionStyle = .None
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    @IBAction func acceptFriend(sender: AnyObject) {
        if let user = sh?{
            let username = user.pendingFriends[sender.tag]
            RequestDealer.acceptedFriendRequest(username.valueForKey("username") as String, accepted: "true", vc:self)
            removePendingFriend(username)
        }
    }
    @IBAction func declineFriend(sender: AnyObject) {
        if let user = sh? {
            let username = user.pendingFriends[sender.tag]
            RequestDealer.acceptedFriendRequest(username.valueForKey("username") as String, accepted: "false", vc:self)
            removePendingFriend(username)
        }
    }
    func removePendingFriend(username:NSManagedObject){
        let appDel = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDel.managedObjectContext!
        managedContext.deleteObject(username)
        managedContext.save(nil)
    }

}