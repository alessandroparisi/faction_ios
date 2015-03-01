//
//  SendFactionViewController.swift
//  Faction
//
//  Created by Alessandro Parisi on 2015-02-01.
//  Copyright (c) 2015 Alessandro Parisi. All rights reserved.
//

import Foundation
import UIKit

class SendFactionViewController: UIViewController, UITextViewDelegate {
    
//    textView(textView: UITextView!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
//    
//    var shouldChange = false
//    
//    if countElements(textField.text) < 150 {
//        shouldChange = true
//    }
//    
//    return shouldChange
//    }

    
    override func viewWillAppear(animated: Bool) {
        textView.text = ""
    }
    
    @IBOutlet weak var True: UIButton!
    @IBOutlet weak var False: UIButton!
    @IBOutlet var textView: UITextView!
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newLength = countElements(textView.text!) - range.length
        return newLength <= 149
    }
    
    @IBAction func True(sender: UIButton) {
        self.performSegueWithIdentifier("pick_friends", sender: true)
    }
    
    @IBAction func False(sender: UIButton) {
        self.performSegueWithIdentifier("pick_friends", sender: false)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var vc = segue.destinationViewController as ChooseFriendViewController
        vc.factionText = textView.text
        if let s = sender as? Bool {
            vc.faction = s
        }
        
    }
    
}