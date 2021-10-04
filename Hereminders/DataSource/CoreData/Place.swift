//
//  Place+CoreDataClass.swift
//  Hereminders
//
//  Created by Rodrigo Borges on 3/25/18.
//  Copyright © 2018 Rodrigo Borges. All rights reserved.
//
//

import Foundation
import CoreData
import CoreLocation

@objc(Place)
public class Place: NSManagedObject {

    @nonobjc public class var entityName: String {

        return "Place"
    }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Place> {

        return NSFetchRequest<Place>(entityName: Place.entityName)
    }

    @NSManaged public var name: String
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var reminders: NSSet?
    @NSManaged public var address: String
    @NSManaged public var radius: Int32
}

extension Place {
    
    var coordinate: CLLocationCoordinate2D {
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
