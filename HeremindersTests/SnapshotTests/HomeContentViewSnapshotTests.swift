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
        let sut = HomeView()
        assertSnapshot(matching: sut, as: Snapshotting.image(size: UIScreen.main.bounds.size), record: false)
    }

}
