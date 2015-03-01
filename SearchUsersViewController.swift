//
//  SearchUsersViewController.swift
//  Faction
//
//  Created by Alessandro Parisi on 2015-02-01.
//  Copyright (c) 2015 Alessandro Parisi. All rights reserved.
//

import Foundation
import UIKit

class SearchUsersViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var users: Array<Dictionary<String,String>> = []

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
    override func viewWillAppear(animated: Bool) {
        getUsers("")
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        let x = self.users[indexPath.row]
        cell.textLabel?.text = x["username"]
        cell.detailTextLabel?.text = x["email"]
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        println("Adding user at row \(indexPath.row) with name \(users[indexPath.row])")
        let user = users[indexPath.row]
        RequestDealer.sendFriendRequest(user["username"]!, vc: self)

        //var image : UIImage = UIImage(named: "osx_design_view_messages")!
        //cell.imageView.image = image
        
    }
    func getUsers(param:String) -> Void {
        self.users = []
        var err: NSError?
        
        let url = NSURL(string: path + "/api/user/search?search=" + param)
     
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            //println(response)
            if let u = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &err) as? Dictionary<String,AnyObject> {
                if let allUsers = u["data"] as? [Dictionary<String, String>]{
                    var def = NSUserDefaults.standardUserDefaults()
                    if let defaultName:AnyObject = def.valueForKey("username"){
                        for user in allUsers {
                            if(user["username"] != (defaultName as String)){
                                self.users.append(user)
                            }
                        }
                    }
                    else{
                        println("else")
                        self.users = allUsers
                    }
                }
            }
            println(self.users)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in self.tableView.reloadData() })
        }
        
        task.resume()

        
    }
    @IBAction func doSearch(sender: AnyObject) {
        getUsers(searchBar!.text)
    }
    
}