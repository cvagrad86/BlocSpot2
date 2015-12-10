//
//  Places.swift
//  BlocSpot2
//
//  Created by Eric Chamberlin on 12/3/15.
//  Copyright © 2015 Eric Chamberlin. All rights reserved.
//

import Foundation
import CoreData

//@objc(Places)


class Places: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    @NSManaged var name: String?
    @NSManaged var longitude: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var location: String?

    @NSManaged var placesDetails: PlacesDetails
    
}
