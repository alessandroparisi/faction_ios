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
    @IBOutlet var searchBar: UISearchBar!
    
    var fil_unans = [NonDBFaction]()
    var fil_rec = [NonDBFaction]()
    var fil_sent = [NonDBFaction]()
    var filtered = false
    var toAnswer = false
    
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
        filtered = false
        var tabBar = self.tabBarController!
        
        var friendsNav = tabBar.viewControllers?[0] as UINavigationController
        var friendsVC = friendsNav.viewControllers?[0] as FriendsViewController

        RequestDealer.getAllInfoOnLogin(friendsVC, factionVC: self, chooseVC: nil)
        
//        var f1 = ["factionId":"1", "story":"thestoryy", "sender":"ale", "fact":true]
//        var f2 = ["factionId":"2", "story":"mystory", "sender":"ale", "fact":true]
//        var f3 = ["factionId":"3", "story":"helloman", "sender":"danny", "fact":true]
//        var f4 = ["factionId":"4", "story":"qqhello", "sender":"v2", "fact":false]
//        var f5 = ["factionId":"5", "story":"thestoimagineryy", "sender":"ale", "fact":true]
//        var f6 = ["factionId":"6", "story":"wwowoow", "sender":"leo", "fact":false]
//        
//        sh?.factionsReceived = [NonDBFaction(faction: f1), NonDBFaction(faction: f2)]
//        sh?.unansweredFactions = [NonDBFaction(faction: f5), NonDBFaction(faction: f6)]
//        sh?.factionsSent = [NonDBFaction(faction: f3), NonDBFaction(faction: f4)]

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch(section){
        case 0:
            if let q = sh?.unansweredFactions {
                if filtered {return fil_unans.count}
                else { return q.count}
            }
            else{
                return 0
            }
        case 1:
            if let q = sh?.factionsReceived {
                if filtered { return fil_rec.count}
                else { return q.count}
            }
            else {
                return 0
            }
        case 2:
            if let q = sh?.factionsSent {
                if filtered { return fil_sent.count}
                else { return q.count}
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
        case 0: return "Unanswered Factions"
        case 1: return "Received Factions"
        case 2: return "Sent Factions"
        default:return ""
        }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        // DISPLAY DATA
        if(indexPath.section == 0){
            if let f = sh?{
                if filtered {
                    let s = fil_unans[indexPath.row]
                    if let q = s.sender as String?{
                        cell.textLabel?.text = "Faction from \(q)"
                    }
                }
                else{
                    let s = f.unansweredFactions[indexPath.row]
                    if let q = s.sender as String?{
                        cell.textLabel?.text = "Faction from \(q)"
                    }
                }
            }
        }
        else if(indexPath.section == 1){
            if let f = sh?{
                if filtered {
                    let s = fil_rec[indexPath.row]
                    if let q = s.sender as String?{
                        cell.textLabel?.text = "Faction from \(q)"
                    }
                }
                else {
                    let s = f.factionsReceived[indexPath.row]
                    if let q = s.sender as String?{
                        cell.textLabel?.text = "Faction from \(q)"
                    }
                }
            }
        }
        else{
            if let f = sh? {
                if filtered {
                    let s = fil_sent[indexPath.row]
                    cell.textLabel?.text = "Faction sent"
                }
                else {
                    let s = f.factionsSent[indexPath.row]
                    cell.textLabel?.text = "Faction sent"
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
        
        toAnswer = false
        if(indexPath.section == 0){
            if let t = sh?.unansweredFactions[indexPath.row] {
                self.performSegueWithIdentifier("view_faction", sender: t)
            }
        }
        else if(indexPath.section == 1){
            if let t = sh?.factionsReceived[indexPath.row]{
                toAnswer = true
                self.performSegueWithIdentifier("view_faction", sender: t)
            }
        }
        else if (indexPath.section == 2){
            if let t = sh?.factionsSent[indexPath.row] {
                toAnswer = true
                self.performSegueWithIdentifier("view_faction", sender: t)
            }
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var vc = segue.destinationViewController as AnswerFactionViewController
        if let t = sender as? NonDBFaction {
            vc.faction = t
            vc.answered = toAnswer
        }
    }
    
    @IBAction func deleteFaction(sender: AnyObject) {
        if let user = sh? {
            var selectedFactionID = ""
            let point = tableView.convertPoint(CGPointZero, fromView: sender as? UIView)
            if let indexPath = tableView.indexPathForRowAtPoint(point) {
                switch (indexPath.section)
                {
                case 0:
                    if filtered {
                        selectedFactionID = fil_unans[indexPath.row].id
                    }
                    else{
                        selectedFactionID = user.unansweredFactions[indexPath.row].id
                    }
                    break
                case 1:
                    if filtered {
                        selectedFactionID = fil_rec[indexPath.row].id
                    }
                    else {
                        selectedFactionID = user.factionsReceived[indexPath.row].id
                    }
                    break
                case 2:
                    if filtered {
                        selectedFactionID = fil_sent[indexPath.row].id
                    }
                    else{
                        selectedFactionID = user.factionsSent[indexPath.row].id
                   }
                    break
                default: println("error")
                }
            }
           RequestDealer.deleteFaction(selectedFactionID, vc: self)
        }
    }
    @IBAction func filterFactions(sender: AnyObject) {
        println("text \(searchBar!.text)")
        if searchBar!.text != "" {
            println("in")
            filtered = true
            var a = sh?.unansweredFactions.filter( { (f: NonDBFaction) -> Bool in
                return ((f.story.rangeOfString(self.searchBar!.text) != nil) || (f.sender.rangeOfString(self.searchBar!.text) != nil))
            })
            fil_unans = a!
            var b = sh?.factionsReceived.filter( { (f: NonDBFaction) -> Bool in
                return ((f.story.rangeOfString(self.searchBar!.text) != nil) || (f.sender.rangeOfString(self.searchBar!.text) != nil))
            })
            fil_rec = b!
            var c = sh?.factionsSent.filter( { (f: NonDBFaction) -> Bool in
                return ((f.story.rangeOfString(self.searchBar!.text) != nil) || (f.sender.rangeOfString(self.searchBar!.text) != nil))
            })
            fil_sent = c!
        }
        else{
            filtered = false
        }
        self.tableView.reloadData()
    }

}