//
//  CustomAnnotation.swift
//  Hereminders
//
//  Created by Bruna Drago on 22/09/21.
//  Copyright © 2021 Rodrigo Borges. All rights reserved.
//

import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}

