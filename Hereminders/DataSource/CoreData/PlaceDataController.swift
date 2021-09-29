//
//  DataController+Place.swift
//  Hereminders
//
//  Created by Rodrigo Borges on 9/8/18.
//  Copyright © 2018 Rodrigo Borges. All rights reserved.
//

import CoreData

protocol PlaceDataControllerType: AnyObject {

    func allPlaces() -> [Place]
    func addPlace(withName name: String,
                  latitude: Double,
                  longitude: Double,
                  address: String) -> Place
    func removePlace(_ place: Place)
    func place(withLatitude latitude: Double,
               andLongitude longitude: Double) -> Place?
}

final class PlaceDataController: PlaceDataControllerType {

    private let dataController: DataControllerType

    init(dataController: DataControllerType) {

        self.dataController = dataController
    }

    func allPlaces() -> [Place] {

        let context = self.dataController.managedObjectContext
        var places: [Place] = []

        do {

            places = try context.fetch(Place.fetchRequest())
        } catch {

            print("Error while fetching places")
        }

        return places
    }

    @discardableResult
    func addPlace(withName name: String, latitude: Double, longitude: Double, address: String) -> Place {

        let context = self.dataController.managedObjectContext
        var place: Place

        if let savedPlace = self.place(withLatitude: latitude,
                                       andLongitude: longitude) {

            place = savedPlace
        } else {
            
            place = NSEntityDescription.insertNewObject(forEntityName: Place.entityName,
                                                        into: context) as! Place
            place.name = name
            place.latitude = latitude
            place.longitude = longitude
            place.address = address
            place.radius = 100
        }

        self.dataController.saveContext()

        return place
    }

    func removePlace(_ place: Place) {

        let context = self.dataController.managedObjectContext
        context.delete(place)
        self.dataController.saveContext()
    }

    func place(withLatitude latitude: Double, andLongitude longitude: Double) -> Place? {

        let request: NSFetchRequest<Place> = Place.fetchRequest()
        request.predicate = NSPredicate(format: "latitude == %lf AND longitude == %lf",
                                        latitude,
                                        longitude)
        let context = self.dataController.managedObjectContext

        do {

            let place = try context.fetch(request).first
            return place
        } catch {

            print("Error while fetching places")
        }

        return nil
    }
}
