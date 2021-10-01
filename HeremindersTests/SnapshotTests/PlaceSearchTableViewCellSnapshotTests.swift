//
//  PlaceSearchTableViewCellSnapshotTest.swift
//  HeremindersTests
//
//  Created by joao camargo on 15/09/21.
//  Copyright © 2021 Rodrigo Borges. All rights reserved.
//

import Foundation

@testable import Hereminders
import SnapshotTesting
import XCTest

let tableViewCellSize = CGSize(width: UIScreen.main.bounds.size.width, height: 49)

class PlaceSearchTableViewCellSnapshotTests: XCTestCase {
    
    override class func setUp() {
        isRecording = false
    }
    
    func testPlaceSearchTableViewCell() {
        let sut = PlaceSearchTableViewCell()
        sut.backgroundColor = .systemBackground
        

        let titleSubtitleViewModel = TitleSubtitleViewModel(title: "Nome do Local", subtitle: "rua: nome da rua, numero, bairro, cidade, país", urlLinkedin: "url")
        let placeSearchTableViewCellViewModel = PlaceSearchTableViewCellViewModel(titleSubtitleViewVM: titleSubtitleViewModel)
        sut.configure(with: placeSearchTableViewCellViewModel)
        
        assertSnapshot(matching: sut, as: Snapshotting.image(size: tableViewCellSize), record: false)
    }
}
