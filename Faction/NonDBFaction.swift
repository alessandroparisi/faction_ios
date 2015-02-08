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
    var fact : String

    init(faction: Dictionary<String,String>){
        self.id = faction["faction_id"]!
        self.story = faction["story"]!
        self.sender = faction["sender"]!
        self.fact = faction["fact"]!
    }
    
}