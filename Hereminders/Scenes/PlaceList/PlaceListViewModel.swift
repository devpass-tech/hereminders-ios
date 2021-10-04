//
//  PlaceListViewModel.swift
//  Hereminders
//
//  Created by Rodrigo Borges on 7/8/18.
//  Copyright © 2018 Rodrigo Borges. All rights reserved.
//

import Foundation
import RxSwift

final class PlaceListViewModel {

    private let placeController: PlaceDataControllerType
    lazy var places: [Place] = self.placeController.allPlaces()
    lazy var placesSubject = PublishSubject<Void>()

    var placeCount: Int {
        get {
            return self.places.count
        }
    }

    init(placeController: PlaceDataControllerType) {

        self.placeController = placeController
    }

    func reloadPlaces() {

        self.places = self.placeController.allPlaces()
        self.placesSubject.onNext(Void())
    }

    func saveNewPlace(with result: PlaceResult) {

        let place = self.placeController.addPlace(withName: result.name,
                                                  latitude: result.coordinate.latitude,
                                                  longitude: result.coordinate.longitude,
                                                  address: result.address,
                                                  radius: 100)

        self.places = self.placeController.allPlaces()
        self.placesSubject.onNext(Void())

        NotificationCenter.default.post(name: Notification.Name.addNewPlace, object: place)
    }

    func removePlace(at index: Int) {
        
        let place = self.places[index]
        NotificationCenter.default.post(name: Notification.Name.removePlace, object: place)

        self.placeController.removePlace(place)

        self.places.remove(at: index)
    }

    func place(at index: Int) -> Place {

        return self.places[index]
    }
}
