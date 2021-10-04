//
//  MapLocationViewModel.swift
//  Hereminders
//
//  Created by Gabriela Sillis on 18/08/21.
//  Copyright © 2021 Rodrigo Borges. All rights reserved.
//

import Foundation
import MapKit

class MapLocationViewModel {
    var coordinate: CLLocationCoordinate2D
    var title: String
    var radius: Int32

    init(coordinate: CLLocationCoordinate2D, title: String, radius: Int32) {
        self.coordinate = coordinate
        self.title = title
        self.radius = radius
    }
}
