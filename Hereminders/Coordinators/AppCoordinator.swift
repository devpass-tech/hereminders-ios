//
//  File.swift
//  Hereminders
//
//  Created by Rodrigo Borges on 3/28/18.
//  Copyright © 2018 Rodrigo Borges. All rights reserved.
//

import UIKit

class AppCoordinator: CoordinatorType {

    var navigationController: UINavigationController
    var childCoordinators: [CoordinatorType] = []
    private var homeCoordinator: HomeCoordinator?

    private let dataController: DataControllerType
    private let placeController: PlaceDataControllerType
    private let reminderController: ReminderDataControllerType

    init(navigationController: UINavigationController, dataController: DataControllerType, placeController: PlaceDataControllerType, reminderController: ReminderDataControllerType) {

        self.navigationController = navigationController
        self.dataController = dataController
        self.placeController = placeController
        self.reminderController = reminderController
    }

    public func start() {

        showHome()
    }

    func showHome() {

        let homeCoordinator = HomeCoordinator(navigationController: self.navigationController,
                                              dataController: self.dataController,
                                              placeController: self.placeController,
                                              reminderController: self.reminderController)
        homeCoordinator.start()

        self.homeCoordinator = homeCoordinator
    }

    func showNewReminder(forLatitude lat: Double, andLongitude long: Double) {

        self.homeCoordinator?.showNewReminder(forLatitude: lat, andLongitude: long)
    }

    func showPlaceSearch() {

        self.homeCoordinator?.showPlaceSearch()
    }
}

extension AppCoordinator: ReminderCoordinatorDelegate {

    func reminderCoordinatorDidCancel(_ coordinator: ReminderCoordinator) {

        self.dismissViewController()
    }

    func reminderCoordinatorDidSaveReminder(_ coordinator: ReminderCoordinator) {

        self.dismissViewController()
    }
}

extension AppCoordinator: PlaceSearchCoordinatorDelegate {

    func placeSearchCoordinatorDidSelectPlace(_ result: PlaceResult) {

        _ = self.placeController.addPlace(withName: result.name,
                                          latitude: result.coordinate.latitude,
                                          longitude: result.coordinate.longitude,
                                          address: result.address,
                                          radius: 100)

        self.dismissViewController()
    }

    func placeSearchCoordinatorDidCancel() {

        self.dismissViewController()
    }
}
