//
//  CommentsViewController.swift
//  Faction
//
//  Created by Alessandro Parisi on 2015-03-12.
//  Copyright (c) 2015 Alessandro Parisi. All rights reserved.
//

import Foundation
import UIKit
class CommentsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    var faction : NonDBFaction?

    @IBOutlet var commentBar: UISearchBar!
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
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let q = faction {
            return q.comments.count
        }
        else {
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        if let f = faction {
            cell.textLabel?.text = f.comments[indexPath.row].content
            cell.detailTextLabel?.text = f.comments[indexPath.row].sender
        }
        cell.selectionStyle = .None
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    @IBAction func sendComment(sender: AnyObject) {
        self.view.endEditing(true)
        if let q = faction {
            let d = ["commentId":"123123123", "commenter": "me", "content": commentBar.text]
            q.comments.append(Comment(dic: d))
            RequestDealer.commentFaction(q.id, content: commentBar.text!, vc: self)
        }
    }
}