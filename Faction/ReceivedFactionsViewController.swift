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
    
    
    var factions: [String] = ["Does Ale have a bad bitch?", "Sup homes, this true", "I aint going public"]
    var sender: [String] = ["Bobby Morrisane", "Robert Montoya", "Elon Muskatchi"]
    var currentText: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getFactions()
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
        return factions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        // DISPLAY DATA
        cell.textLabel?.text = self.sender[indexPath.row] as String
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Faction at row: \(indexPath.row): has string: \(factions[indexPath.row])")
        currentText = factions[indexPath.row]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var vc = segue.destinationViewController as AnswerFactionViewController
        println("Current text \(currentText)")
        vc.tableViewText = currentText
        
    }
    
    
    func getFactions() -> Void {
        println("a")
        
    
        
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