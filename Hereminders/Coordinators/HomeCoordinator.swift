//
//  HomeCoordinator.swift
//  Hereminders
//
//  Created by Rodrigo Borges on 3/28/18.
//  Copyright © 2018 Rodrigo Borges. All rights reserved.
//

import UIKit
import CoreLocation

class HomeCoordinator: CoordinatorType {

    private var viewModel: HomeViewModel?
    private let dataController: DataControllerType
    private let placeController: PlaceDataControllerType
    private let reminderController: ReminderDataControllerType

    var navigationController: UINavigationController
    var childCoordinators: [CoordinatorType] = []

    init(navigationController: UINavigationController,
         dataController: DataControllerType,
         placeController: PlaceDataControllerType,
         reminderController: ReminderDataControllerType) {

        self.navigationController = navigationController
        self.dataController = dataController
        self.placeController = placeController
        self.reminderController = reminderController
    }

    public func start() {

        let locationController = LocationController()

        let viewModel = HomeViewModel(locationController: locationController,
                                      placeController: self.placeController,
                                      reminderController: self.reminderController)
        self.viewModel = viewModel
        
        let viewController = HomeViewController(viewModel: viewModel, delegate: self)
        //viewController.delegate = self
        self.navigationController.addChild(viewController)
    }

    func showReminder(_ reminder: Reminder?, _ place: Place?) {

        let reminderCoordinator = ReminderCoordinator(navigationController: self.navigationController,
                                                      reminderController: self.reminderController,
                                                      reminder: reminder,
                                                      place: place)
        reminderCoordinator.delegate = self
        reminderCoordinator.start()

        self.childCoordinators.append(reminderCoordinator)
    }

    func showNewReminder(forLatitude lat: Double, andLongitude long: Double) {

        self.dismissViewController()

        let place = self.placeController.place(withLatitude: lat, andLongitude: long)

        let newReminderCoordinator = ReminderCoordinator(navigationController: self.navigationController,
                                                         reminderController: self.reminderController,
                                                         reminder: nil,
                                                         place: place)
        newReminderCoordinator.delegate = self

        self.childCoordinators.append(newReminderCoordinator)
        newReminderCoordinator.start()
    }

    func showPlaceSearch() {

        self.dismissViewController()

        let placeSearchCoordinator = PlaceSearchCoordinator(navigationController: self.navigationController)
        placeSearchCoordinator.delegate = self
        placeSearchCoordinator.start()

        self.childCoordinators.append(placeSearchCoordinator)
    }

    func showPlaceList() {

        let placeListCoordinator = PlaceListCoordinator(navigationController: self.navigationController,
                                                        placeController: self.placeController,
                                                        dataController: self.dataController)
        placeListCoordinator.start()

        self.childCoordinators.append(placeListCoordinator)
    }

    func showSettings() {

        let settingsCoordinator = SettingsCoordinator(navigationController: self.navigationController,
                                                      placeController: self.placeController,
                                                      dataController: self.dataController)
        settingsCoordinator.delegate = self
        settingsCoordinator.start()

        self.childCoordinators.append(settingsCoordinator)
    }
}

extension HomeCoordinator: HomeViewControllerDelegate {

    func homeViewControllerDidOpenReminder(_ reminder: Reminder) {
        
        self.showReminder(reminder, nil)
    }

    func homeViewControllerWantsToAddNewReminder(at place: Place?) {

        self.showReminder(nil, place)
    }

    func homeViewControllerWantsToAddNewPlace() {

        self.showPlaceSearch()
    }

    func homeViewControllerWantsToOpenSettings() {

        self.showSettings()
    }
}

extension HomeCoordinator: ReminderCoordinatorDelegate {
    
    func reminderCoordinatorDidSaveReminder(_ coordinator: ReminderCoordinator) {

        self.viewModel?.reloadSelectedPlace()
        self.dismissViewController()
    }

    func reminderCoordinatorDidCancel(_ coordinator: ReminderCoordinator) {

        self.dismissViewController()
    }
}

extension HomeCoordinator: PlaceSearchCoordinatorDelegate {

    func placeSearchCoordinatorDidSelectPlace(_ place: PlaceResult) {

        self.viewModel?.saveNewPlace(with: place)
        self.dismissViewController()
    }

    func placeSearchCoordinatorDidCancel() {

        self.dismissViewController()
    }
}

extension HomeCoordinator: SettingsCoordinatorDelegate {

    func settingsCoordinatorDidCancel() {

        self.dismissViewController()
    }
}
