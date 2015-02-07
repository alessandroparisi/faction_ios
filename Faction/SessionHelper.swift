//
//  SessionHelper.swift
//  Faction
//
//  Created by Leonardo Siracusa on 2015-02-06.
//  Copyright (c) 2015 Leonardo Siracusa. All rights reserved.
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