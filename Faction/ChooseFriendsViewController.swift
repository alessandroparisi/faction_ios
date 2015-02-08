//
//  ChooseFriendsViewController.swift
//  Faction
//
//  Created by Alessandro Parisi on 2015-02-01.
//  Copyright (c) 2015 Alessandro Parisi. All rights reserved.
//

import Foundation
import UIKit


class ChooseFriendViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {

  
    @IBOutlet var tableView: UITableView!
    
    var selectedFriends = [Int: String]()
    var factionText : String?
    var faction : String = ""
    
  
    @IBOutlet weak var sendFaction: UIButton!

    //var selectedFriends = as Dictionary<String, String>
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(animated: Bool) {
        var tabBar = self.tabBarController!
        
        var factionNav = tabBar.viewControllers?[2] as UINavigationController
        var factionVC = factionNav.viewControllers?[0] as ReceivedFactionsViewController
        
        var friendsNav = tabBar.viewControllers?[0] as UINavigationController
        var friendsVC = friendsNav.viewControllers?[0] as FriendsViewController
        
        RequestDealer.getAllInfoOnLogin(friendsVC, factionVC: factionVC, chooseVC: self)
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
        if let f = sh?.friends {
            return f.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        if let f = sh?.friends {
            let specificFriend = f[indexPath.row]
            cell.textLabel?.text = f[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        var selected = isSelected(indexPath.row)
        
        if selected {
            selectedFriends.removeValueForKey(indexPath.row)
            selectedCell.contentView.backgroundColor = UIColor.whiteColor()
        }
        else{
            if let f = sh?.friends {
                selectedFriends[indexPath.row] = f[indexPath.row]
                selectedCell.contentView.backgroundColor = UIColor.greenColor()
            }
            //selectedFriends.updateValue(friends[indexPath.row], forKey: indexPath.row)
        }
        println(selectedFriends)
        //RequestDealer.addFriend(friends[indexPath.row])
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        var cellToDeSelect:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        var selected = isSelected(indexPath.row)
        if selected {
            if let f = sh?.friends {
                selectedFriends[indexPath.row] = f[indexPath.row]
                cellToDeSelect.contentView.backgroundColor = UIColor.greenColor()
            }
        }
        else{
            selectedFriends.removeValueForKey(indexPath.row)
            cellToDeSelect.contentView.backgroundColor = UIColor.whiteColor()
            
            //selectedFriends.updateValue(friends[indexPath.row], forKey: indexPath.row)
        }
        
        //cellToDeSelect.contentView.backgroundColor = UIColor.greenColor()
    }
    
    // checks if row was already selected
    func isSelected(row: Int) -> Bool {
        for selectedRow in selectedFriends.keys {
            if selectedRow == row{
                return true
            }
        }
        return false
    }
    
    @IBAction func sendFaction(sender: UIButton) {
        // maybe need to clear array? dunno how this works
        
        var x = [String]()
        for (row, user) in selectedFriends {
            x.append(user)
        }
        println("Send button was pressed*********************************")
        println(x)
        println(factionText!)
        println(faction)
        
        let params = ["to":x,"faction":factionText!,"fact":faction] as Dictionary<String, AnyObject>
        RequestDealer.aleHasAShittyAuth(params, path: path + "/api/factions/send", myVC: self, method:"POST")
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func getFriends() -> Void {
        // Placeholder code until they fix the fucking backend
        
//        if let session = sh? {
//            let myFriends = sh?.friends.map{$0.username}
//            self.friends = myFriends!
//        }
        //println(friends)
//        var err: NSError?
//        
//        let url = NSURL(string: "https://faction.notscott.me/api/user/search")
//        
//        
//        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
//            self.friends =  NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as Array<String>
//            println(self.friends)
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in self.tableView.reloadData() })
//        }
//        
//        task.resume()
    }

}