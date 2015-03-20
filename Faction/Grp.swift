//
//  Grp.swift
//  Faction
//
//  Created by Alessandro Parisi on 2015-03-19.
//  Copyright (c) 2015 Alessandro Parisi. All rights reserved.
//

import Foundation

class Grp {

    var name : String
    var id : String
    var friends : [String]
    
    init(d: Dictionary<String, AnyObject>){
        self.name = d["name"] as String
        self.id = d["groupId"] as String
        self.friends = d["friends"] as [String]
    }

}