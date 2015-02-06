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

    
    @IBOutlet weak var True: UIButton!
    @IBOutlet weak var False: UIButton!
    @IBOutlet var textView: UITextView!
    
    var faction = ""
    
    @IBAction func sendFactionFalse(sender: AnyObject) {
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newLength = countElements(textView.text!) - range.length
        return newLength <= 149
    }
    
    @IBAction func True(sender: UIButton) {
        println("Setting faction to true")
        faction = "true"
    }
    
    @IBAction func False(sender: UIButton) {
        println("Setting faction to false")
        faction = "false"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var vc = segue.destinationViewController as ChooseFriendViewController
        vc.factionText = textView.text
        vc.faction = faction
        
    }
    
}