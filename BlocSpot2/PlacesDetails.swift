//
//  PlacesDetails.swift
//  BlocSpot2
//
//  Created by Eric Chamberlin on 12/3/15.
//  Copyright © 2015 Eric Chamberlin. All rights reserved.
//

import Foundation
import CoreData



class PlacesDetails: NSManagedObject {


    @NSManaged var notes: String?
    @NSManaged var date: NSDate?
    @NSManaged var relationship: NSSet?
    
    // Relationships
    @NSManaged var places: Places
    
}
