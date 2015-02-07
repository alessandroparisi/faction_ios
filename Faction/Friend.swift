//
//  Friend.swift
//  Faction
//
//  Created by Alessandro Parisi on 2015-02-07.
//  Copyright (c) 2015 Alessandro Parisi. All rights reserved.
//

import Foundation
import CoreData

class Friend : NSManagedObject {
    @NSManaged var username : String
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, username: String, entityName:String) -> Friend {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: moc) as Friend
        newItem.username = username
        
        return newItem
    }
}