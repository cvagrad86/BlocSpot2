//
//  PlacesDetails.swift
//  BlocSpot2
//
//  Created by Eric Chamberlin on 12/3/15.
//  Copyright © 2015 Eric Chamberlin. All rights reserved.
//

import Foundation
import CoreData

//@objc(PlacesDetails)

class PlacesDetails: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    @NSManaged var notes: String?
    @NSManaged var date: NSDate?
    @NSManaged var relationship: NSSet?
    
    // Relationships
    @NSManaged var places: Places
    
}
