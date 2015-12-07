//
//  Places+CoreDataProperties.swift
//  BlocSpot2
//
//  Created by Eric Chamberlin on 12/3/15.
//  Copyright © 2015 Eric Chamberlin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Places {

    @NSManaged var name: String?
    @NSManaged var longitude: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var location: String?

}
