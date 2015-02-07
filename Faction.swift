//
//  Faction.swift
//  Faction
//
//  Created by Alessandro Parisi on 2015-02-06.
//  Copyright (c) 2015 Alessandro Parisi. All rights reserved.
//

import Foundation

class Faction : NSManagedObject {
    @NSManaged var id:String
    @NSManaged var story:String
    @NSManaged var sender:String
    @NSManaged var fact:String
    
    init(id:String, story:String, sender:String, fact:String){
        self.id = id
        self.story=story
        self.sender = sender
        self.fact = fact
    }
}