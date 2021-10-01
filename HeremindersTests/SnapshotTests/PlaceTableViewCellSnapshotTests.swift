//
//  PlaceTableViewCell.swift
//  HeremindersTests
//
//  Created by Alan Silva on 23/09/21.
//  Copyright © 2021 Rodrigo Borges. All rights reserved.
//

import Foundation

@testable import Hereminders
import SnapshotTesting
import XCTest

let tableviewCellTest = CGSize(width: UIScreen.main.bounds.size.width, height: 49)

class PlaceTableViewCellSnapshotTests: XCTestCase {
    
    override class func setUp() {
        isRecording = false
    }
    
    func testPlaceTableViewCell() {
        let sut = PlaceTableViewCell()
        sut.backgroundColor = .systemBackground
    
        let titleSubtitleViewModel = TitleSubtitleViewModel(title: "Nome do Local", subtitle: "rua: nome da rua, numero, bairro, cidade, país", urlLinkedin: "url")
        
        let placeTableViewCellViewModel = PlaceTableViewCellViewModel(titleSubtitleViewVM: titleSubtitleViewModel)
        sut.configure(with: placeTableViewCellViewModel)
        
        assertSnapshot(matching: sut, as: Snapshotting.image(size: tableViewCellSize ), record: false)
    }
    
}
