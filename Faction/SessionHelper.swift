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
//    var username: String?
    var friends: [Friend]
    var pendingFriends: [Friend]
    var answeredFactions: [Faction]
    var unansweredFactions: [Faction]
    
    init(){
        self.friends = [Friend]()
        self.pendingFriends = [Friend]()
        self.answeredFactions = [Faction]()
        self.unansweredFactions = [Faction]()
    }
}