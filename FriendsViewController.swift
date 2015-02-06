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
        self.updateDB()

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
            if let s = sh?.pendingFriends? {
                return s.count
            }
            else{
                return 0
            }
        case 1:
            if let q = sh?.friends? {
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
            if let f = sh?.pendingFriends?{
                let s = f[indexPath.row]
                cell.textLabel?.text = s.valueForKey("username") as? String
            }
            cell.accept.tag = indexPath.row
            cell.decline.tag = indexPath.row
            return cell
        }
        else{
            let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
            if let f = sh?.friends? {
                let s = f[indexPath.row]
                cell.textLabel?.text = s.valueForKey("username") as? String
            }
            cell.selectionStyle = .None
            cell.userInteractionEnabled = false
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
        if let user = sh?.pendingFriends? {
            let username = user[sender.tag]
            removePendingFriend(username)
            RequestDealer.acceptedFriendRequest(username.valueForKey("username") as String, accepted: "true", vc:self)
        }
    }
    @IBAction func declineFriend(sender: AnyObject) {
        if let user = sh?.pendingFriends? {
            let username = user[sender.tag]
            removePendingFriend(username)
            RequestDealer.acceptedFriendRequest(username.valueForKey("username") as String, accepted: "false", vc:self)
        }
    }
    func removePendingFriend(username:NSManagedObject){
        let appDel = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDel.managedObjectContext!
        managedContext.deleteObject(username)
        managedContext.save(nil)
    }
    func updateDB(){
        var err: NSError?
        
        let url = NSURL(string: path + "/api/update")
        
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            println(response)
            if(error != nil){
                println(error)
            }
            println("-------------------------------------------")
            println("-------------------------------------------")
            if let info = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &err) as? Dictionary<String, Array<String>>{
                println(info)
                if let pending_requests = info["pending_requests"]{
                    self.addPendingRequests(pending_requests)
                }
            }
        }
        
        task.resume()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in self.tableView.reloadData() })
    }
    func addPendingRequests(pending_requests:[String]){
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let entity =  NSEntityDescription.entityForName("ReceivedRequestFriends", inManagedObjectContext: managedContext)
        loadData()
        
        var already_exists = false
        
        if let fr = sh?.pendingFriends {
            for req in pending_requests {
                for u in fr {
                    if u == req {
                        already_exists = true
                    }
                }
                if(!already_exists){
                    let friend =  NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
                    friend.setValue(req, forKey: "username")
                    var error: NSError?
                    if !managedContext.save(&error) {
                        println("Could not save \(error), \(error?.userInfo)")
                    }
                }
                already_exists = false
            }
        }
    }
    func loadData(){
        let appDel = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDel.managedObjectContext!
        loadFriends(managedContext, entityName:"Friends")
        loadFriends(managedContext, entityName:"ReceivedRequestFriends")
    }
    func loadFriends(managedContext: NSManagedObjectContext, entityName: String){
        let fetchRequest = NSFetchRequest(entityName: entityName)
        
        var error:NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
        
        if let results = fetchedResults {
            if entityName == "Friends"{
                sh?.friends = results
            }
            else{
                sh?.pendingFriends = results
            }
//            for r in results {
//                managedContext.deleteObject(r)
//            }
        }

        else{
            println("Could not fetch \(entityName): \(error), \(error!.userInfo)")
        }
        //managedContext.save(nil)

    }
}