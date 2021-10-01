//
//  PlaceAnnotation.swift
//  Hereminders
//
//  Created by Rodrigo Borges on 3/25/18.
//  Copyright © 2018 Rodrigo Borges. All rights reserved.
//

import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {

    var place: Place
    var title: String?
    var coordinate: CLLocationCoordinate2D

    init(place: Place) {
        self.place = place
        self.title = place.name
        self.coordinate = place.coordinate
    }
}
