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

    func textView(textField: UITextView!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
        
        return false
        
    }
    
    @IBOutlet var textView: UITextView!
    @IBAction func sendFaction(sender: AnyObject) {
    
    }
}