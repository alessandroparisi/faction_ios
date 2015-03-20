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
    var groups: [Grp]
    var friends: [String]
    var pendingFriends: [String]
    var topThree : [String]
    var factionsReceived : [NonDBFaction]
    var factionsSent : [NonDBFaction]
    var unansweredFactions : [NonDBFaction]
    var factionResponses: [FactionResponse]
    init(){
        self.friends = [String]()
        self.pendingFriends = [String]()
        self.factionsReceived = [NonDBFaction]()
        self.factionsSent = [NonDBFaction]()
        self.unansweredFactions = [NonDBFaction]()
        self.factionResponses = [FactionResponse]()
        self.topThree = [String]()
        self.groups = [Grp]()
    }
}