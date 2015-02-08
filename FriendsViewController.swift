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
        var tabBar = self.tabBarController!
        
        var factionNav = tabBar.viewControllers?[2] as UINavigationController
        var factionVC = factionNav.viewControllers?[0] as ReceivedFactionsViewController

        //RequestDealer.updateDB(self, factionVC: factionVC)
        RequestDealer.getAllInfoOnLogin(self, factionVC: factionVC)

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
                if let q = s as String?{
                    cell.textLabel?.text = q
                }
            }
            cell.accept.tag = indexPath.row
            cell.decline.tag = indexPath.row
            cell.selectionStyle = .None
            return cell
        }
        else{
            let cell = self.tableView.dequeueReusableCellWithIdentifier("Friend") as UITableViewCell
            if let f = sh? {
                let s = f.friends[indexPath.row]
                if let q = s as String?{
                    cell.textLabel?.text = q
                }
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
            let selectedUser = user.pendingFriends[sender.tag]
            RequestDealer.acceptedFriendRequest(selectedUser, accepted: "true", vc:self)
            //removePendingFriend(selectedUser)
        }
    }
    @IBAction func declineFriend(sender: AnyObject) {
        if let user = sh? {
            let selectedUser = user.pendingFriends[sender.tag]
            RequestDealer.acceptedFriendRequest(selectedUser, accepted: "false", vc:self)
           // removePendingFriend(selectedUser)
        }
    }
//    func removePendingFriend(user:String){
        
//        println("lines: \(sh?.pendingFriends)")
        
//        let allNames = sh?.pendingFriends
//
//        if let names = allNames {
//            var i = 0
//            for name in names {
//                if user == name {
//                    sh?.pendingFriends.removeAtIndex(i)
//                    break
//                }
//                ++i
//            }
//        }
//
//        let appDel = UIApplication.sharedApplication().delegate as AppDelegate
//        let managedContext = appDel.managedObjectContext!
//        managedContext.deleteObject(user)
//        managedContext.save(nil)
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in self.tableView.reloadData() })

    //}

}