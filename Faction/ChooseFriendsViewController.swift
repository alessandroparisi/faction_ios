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
    
    var friends = [String]()
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
        getFriends()
        tableView.reloadData()
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
        return friends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        let specificFriend = self.friends[indexPath.row] as String
        print(specificFriend)
        cell.textLabel?.text = self.friends[indexPath.row] as String
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        println("Sending Faction to user at row \(indexPath.row) with name \(friends[indexPath.row])")
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        var selected = isSelected(indexPath.row)
        
        if selected {
            selectedFriends.removeValueForKey(indexPath.row)
            selectedCell.contentView.backgroundColor = UIColor.whiteColor()
        }
        else{
            selectedFriends[indexPath.row] = friends[indexPath.row]
            selectedCell.contentView.backgroundColor = UIColor.greenColor()
            
            //selectedFriends.updateValue(friends[indexPath.row], forKey: indexPath.row)
        }
        println(selectedFriends)
        //RequestDealer.addFriend(friends[indexPath.row])
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        var cellToDeSelect:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        var selected = isSelected(indexPath.row)
        if selected {
            selectedFriends[indexPath.row] = friends[indexPath.row]
            cellToDeSelect.contentView.backgroundColor = UIColor.greenColor()
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
        
        if let session = sh? {
            let myFriends = sh?.friends.map{$0.valueForKey("username") as String}
            self.friends = myFriends!
        }
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