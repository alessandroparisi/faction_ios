//
//  SessionHelper.swift
//  Faction
//
//  Created by Alessandro Parisi on 2015-02-05.
//  Copyright (c) 2015 Alessandro Parisi. All rights reserved.
//

import Foundation
import CoreData

class SessionHelper {
    var username: String?
    var friends: [NSManagedObject]
    var pendingFriends: [NSManagedObject]
    var answeredFactions: [Faction]
    var unansweredFactions: [Faction]
    
    init(){
        self.friends = [NSManagedObject]()
        self.pendingFriends = [NSManagedObject]()
        self.answeredFactions = [Faction]()
        self.unansweredFactions = [Faction]()
    }
}