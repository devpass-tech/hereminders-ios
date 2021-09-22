//
//  HomeViewSnapshot.swift
//  HeremindersTests
//
//  Created by joao camargo on 22/09/21.
//  Copyright © 2021 Rodrigo Borges. All rights reserved.
//

import Foundation
@testable import Hereminders
import SnapshotTesting
import XCTest


class HomeContentViewSnapshotTests: XCTestCase {
    
    override class func setUp() {
        isRecording = false
    }


    func testHomeContentView() { //para gerar a primeira imagem
        let dataController = DataController()
        let locationController = LocationController()
        let placeController = PlaceDataController(dataController: dataController)
        
        placeController.addPlace(withName: "Casa Branca",
                                 latitude: 38.8977, longitude: 77.0365,
                                 address: "1600 Pennsylvania Avenue NW, Washington, DC 20500, United States")
        
        let reminderController = ReminderDataController(dataController: dataController, placeController: placeController)

        
        //ReminderItemModel(description: "Jogar água na planta", event: 1),
        reminderController.addReminder(withPlaceName: "Casa Branca", latitude: 38.8977,
                                       longitude: 77.0365, description: "SnaoShotTest",
                                       event: 1, radius: 2, notificationIdentifier: "Casa Branca Notif")
        
        let sut = HomeView()
        assertSnapshot(matching: sut, as: Snapshotting.image(size: UIScreen.main.bounds.size), record: false)
    }
    
    
//    func testHomeContentView() { //para gerar a primeira imagem
//        let dataController = DataController()
//        let locationController = LocationController()
//        let placeController = PlaceDataController(dataController: dataController)
//
//        placeController.addPlace(withName: "Casa Branca",
//                                 latitude: 38.8977, longitude: 77.0365,
//                                 address: "1600 Pennsylvania Avenue NW, Washington, DC 20500, United States")
//
//        let reminderController = ReminderDataController(dataController: dataController, placeController: placeController)
//
//
//        //ReminderItemModel(description: "Jogar água na planta", event: 1),
//        reminderController.addReminder(withPlaceName: "Casa Branca", latitude: 38.8977,
//                                       longitude: 77.0365, description: "SnaoShotTest",
//                                       event: 1, radius: 2, notificationIdentifier: "Casa Branca Notif")
//
//        let sut = HomeViewController(viewModel:
//                                        HomeViewModel(locationController: locationController,
//                                                                      placeController: placeController,
//                                                                      reminderController: reminderController))
//
//        assertSnapshot(matching: sut, as: Snapshotting.image(size: UIScreen.main.bounds.size), record: false)
//    }
}
