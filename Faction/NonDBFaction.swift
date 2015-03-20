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
    var comments : [Comment]
    var image_data: NSData?
    var comments_enabled : Bool
    
    init(faction: Dictionary<String,AnyObject>, data: NSData?){
        //println(faction)
        self.id = faction["factionId"] as String
        self.story = faction["story"] as String
        self.sender = faction["sender"] as String
        self.fact = faction["fact"] as Bool
        
        self.comments_enabled = false
        
        if let ce = faction["commentsEnabled"] as? Bool {
            self.comments_enabled = ce
        }
        self.comments = []

        
        if let all_comments = faction["comments"] as? [Dictionary<String, AnyObject>] {
            for com in all_comments {
                self.comments.append(Comment(dic:com))
            }
        }
        self.image_data = nil
        
        if let d = data {
            self.image_data = d
        }
    }
}