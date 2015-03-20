//
//  Group.swift
//  Faction
//
//  Created by Alessandro Parisi on 2015-03-19.
//  Copyright (c) 2015 Alessandro Parisi. All rights reserved.
//

import Foundation
import UIKit
class Group : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var nameText: UITextField!
    var selectedFriends = [Int: String]()

    override func viewWillAppear(animated: Bool) {
        RequestDealer.getAllInfoOnLogin(nil, factionVC: nil, chooseVC: nil, com:nil, g: self)
    }
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section){
        case 0:
            if let s = sh?.groups {
                return s.count
            }
            else{
                return 0
            }
        case 1:
            if let s = sh?.friends {
                return s.count
            }
            else{
                return 0
            }
        default: return 0
        }
    }
    func tableView( tableView : UITableView,  titleForHeaderInSection section: Int)->String
    {
        switch(section)
        {
        case 0: return "Groups"
        case 1: return "Friends"
        default:return ""
        }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0){
            let cell = self.tableView.dequeueReusableCellWithIdentifier("GroupCell") as UITableViewCell
            if let f = sh?{
                let g = f.groups[indexPath.row]
                cell.textLabel?.text = g.name
                cell.detailTextLabel?.text = ", ".join(g.friends)
            }
            cell.selectionStyle = .None
            return cell
        }
        else{
            let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
            if let f = sh? {
                cell.textLabel?.text = f.friends[indexPath.row]
            }
            return cell
        }
        
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

    @IBAction func createGroup(sender: AnyObject) {
        var x = [String]()
        for (row, user) in selectedFriends {
            x.append(user)
        }
        RequestDealer.createGroup(x, name: nameText.text!, vc: self)
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
}