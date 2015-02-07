//
//  Faction.swift
//  Faction
//
//  Created by Leonardo Siracusa on 2015-02-06.
//  Copyright (c) 2015 Leonardo Siracusa. All rights reserved.
//

import Foundation
import CoreData

class Faction : NSManagedObject {
    @NSManaged var id:String
    @NSManaged var story:String
    @NSManaged var sender:String
    @NSManaged var fact:String
}