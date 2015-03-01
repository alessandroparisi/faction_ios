//
//  NonDBFaction.swift
//  Faction
//
//  Created by Alessandro Parisi on 2015-02-07.
//  Copyright (c) 2015 Alessandro Parisi. All rights reserved.
//

import Foundation

class NonDBFaction {
    var id : String
    var story : String
    var sender : String
    var fact : Bool

    init(faction: Dictionary<String,AnyObject>){
        self.id = faction["factionId"] as String
        self.story = faction["story"] as String
        self.sender = faction["sender"] as String
        self.fact = faction["fact"] as Bool
    }
    
}