//
//  PotentialFriendCell.swift
//  Faction
//
//  Created by Alessandro Parisi on 2015-02-05.
//  Copyright (c) 2015 Alessandro Parisi. All rights reserved.
//

import Foundation
import UIKit

class PotentialFriendCell : UITableViewCell {
    
    @IBOutlet var accept: UIButton!
    @IBOutlet var decline: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}