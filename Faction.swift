//
//  Faction.swift
//  Faction
//
//  Created by Leonardo Siracusa on 2015-02-06.
//  Copyright (c) 2015 Leonardo Siracusa. All rights reserved.
//

import Foundation
import CoreData
//
//class Faction : NSManagedObject {
//    @NSManaged var id:String
//    @NSManaged var story:String
//    @NSManaged var sender:String
//    @NSManaged var fact:String
//    
//    
//    class func createNewFaction(moc: NSManagedObjectContext, entityName:String, id: String, story:String, sender:String, fact:String) -> Faction {
//        let newItem = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: moc) as Faction
//        newItem.id = id
//        newItem.story = story
//        newItem.sender = sender
//        newItem.fact = fact
//        
//        return newItem
//    }
//    class func createFaction(managedContext: NSManagedObjectContext, entityName:String, faction:NonDBFaction) -> Faction{
//        return createNewFaction(managedContext, entityName: entityName, id: faction.id, story: faction.story, sender: faction.sender, fact: faction.fact)
//    }
//    
//}