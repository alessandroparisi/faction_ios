//
//  FactionResponse.swift
//  Faction
//
//  Created by Alessandro Parisi on 2015-02-28.
//  Copyright (c) 2015 Alessandro Parisi. All rights reserved.
//

import Foundation

class FactionResponse {
    var id : String
    var responder : String
    var response : Bool
    
    init(faction: Dictionary<String,AnyObject>){
        self.id = faction["factionId"] as String
        self.responder = faction["responderUsername"] as String
        self.response = faction["response"] as Bool
    }
}