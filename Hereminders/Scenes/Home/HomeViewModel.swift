//
//  HomeViewModule.swift
//  Hereminders
//
//  Created by Rodrigo Borges on 6/1/18.
//  Copyright © 2018 Rodrigo Borges. All rights reserved.
//

import Foundation
import RxSwift

final class HomeViewModel {

    typealias SelectedPlace = (place: Place, reminders: [Reminder])

    private let locationController: LocationControllerType
    private let placeController: PlaceDataControllerType
    private let reminderController: ReminderDataControllerType

    private lazy var places: [Place] = self.placeController.allPlaces()
    private var selectedPlace: Place?
    private var annotations: [PlaceAnnotation] = []

    var annotationsSubject = BehaviorSubject<[PlaceAnnotation]>(value: [])
    var selectedAnnotationSubject = PublishSubject<PlaceAnnotation>()
    var selectedPlaceSubject = PublishSubject<SelectedPlace?>()

    let title: String = L10n.Home.title

    init(locationController: LocationControllerType,
         placeController: PlaceDataControllerType,
         reminderController: ReminderDataControllerType) {

        self.locationController = locationController
        self.placeController = placeController
        self.reminderController = reminderController

        self.locationController.requestLocation()
        self.reloadAnnotations()
    }

    func reloadAnnotations() {

        self.places = self.placeController.allPlaces()
        self.annotations = self.places.map({ PlaceAnnotation(place: $0) })
        self.annotationsSubject.onNext(self.annotations)
    }

    func selectPlace(_ place: Place?) {

        if let place = place {

            self.selectedPlace = place
            let reminders = self.reminderController.reminders(in: place)
            self.selectedPlaceSubject.onNext((place, reminders))
        } else {

            self.selectedPlace = nil
            self.selectedPlaceSubject.onNext(nil)
        }
    }

    func reloadSelectedPlace() {

        if let place = self.selectedPlace {

            self.selectPlace(place)
        }
    }

    func saveNewPlace(with result: PlaceResult) {

        let place = self.placeController.addPlace(withName: result.name,
                                                  latitude: result.coordinate.latitude,
                                                  longitude: result.coordinate.longitude,
                                                  address: result.address,
                                                  radius: 100)

        self.reloadAnnotations()

        let annotationToSelect = self.annotation(for: place)
        self.selectedAnnotationSubject.onNext(annotationToSelect)
    }

    func annotation(for place: Place) -> PlaceAnnotation {

        guard let annotation = self.annotations.filter({ $0.place == place }).first else {

            fatalError("Could not find annotation for place")
        }

        return annotation
    }

    func removeReminder(_ reminder: Reminder) {

        self.reminderController.removeReminder(reminder)
    }
}
