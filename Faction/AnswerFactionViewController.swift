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
    var textViewText = ""
    
    override func viewDidLoad() {
        factionText.text = textViewText
        
        println("Text view text: \(textViewText)")
    }
}