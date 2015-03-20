//
//  AnswerFactionViewController.swift
//  Faction
//
//  Created by Alessandro Parisi on 2015-02-01.
//  Copyright (c) 2015 Alessandro Parisi. All rights reserved.
//

import Foundation
import UIKit

class AnswerFactionViewController : UIViewController {
    @IBOutlet var factionText : UITextView!
    @IBOutlet var fictionButton: UIButton!
    @IBOutlet var factButton: UIButton!
    var faction : NonDBFaction?
    var answered = false
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var viewCommentsButton: UIButton!
    @IBOutlet var resultText: UILabel!
    override func viewDidLoad() {
        
        
        factButton.hidden = false
        factButton.hidden = false
        viewCommentsButton.hidden = true
        
        if answered {
            factButton.hidden = true
            fictionButton.hidden = true
            if let f = faction {
                if f.fact {
                    resultText.text = "FACT"
                }
                else{
                    resultText.text = "FICTION"
   
                }
            }
        }
        if let f = faction {
            factionText.text = f.story
            
            if f.comments_enabled && answered{
                println(answered)
                println(f.comments_enabled)
                viewCommentsButton.hidden = false
            }
            if let im = f.image_data {
                imageView.image = UIImage(data: im)!
            }
        }
    }
    @IBAction func fictionSelected(sender: AnyObject) {
        if let f = faction? {
            RequestDealer.respondFaction(f.id, response: false, vc: self)
        }
    }
    @IBAction func factSelected(sender: AnyObject) {
        if let f = faction? {
            RequestDealer.respondFaction(f.id, response: true, vc: self)
        }
    }
    @IBAction func viewComments(sender: AnyObject) {
        self.performSegueWithIdentifier("view_comments", sender: faction)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var vc = segue.destinationViewController as CommentsViewController
        if let t = sender as? NonDBFaction {
            vc.faction = t
        }
    }
}