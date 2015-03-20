//
//  Comment.swift
//  Faction
//
//  Created by Alessandro Parisi on 2015-03-12.
//  Copyright (c) 2015 Alessandro Parisi. All rights reserved.
//

import Foundation


class Comment {
    var id : String
    var sender: String
    var content: String
    
    init(dic: Dictionary<String, AnyObject>){
        self.id = dic["commentId"] as String
        self.sender = dic["commenter"] as String
        self.content = dic["content"] as String
    }
}