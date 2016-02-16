//
//  Meal.swift
//  FoodTracker
//
//  Created by Adam DesLauriers on 2016-02-14.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import UIKit
import Parse


class Meal: PFObject, PFSubclassing {
    // MARK: Properties
    
    @NSManaged var name: String
    @NSManaged var photo: PFFile?
    @NSManaged var rating: Int
    
    class func parseClassName() -> String {
        return "Meal"
    }
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("meals")
    
}





