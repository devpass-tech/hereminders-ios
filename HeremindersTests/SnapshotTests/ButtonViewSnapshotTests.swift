//
//  ButtonViewSnapshotTests.swift
//  HeremindersTests
//
//  Created by sara.batista.d.felix on 19/08/21.
//  Copyright © 2021 Rodrigo Borges. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Hereminders

class ButtonViewSnapshotTests: XCTestCase {
    
    func testButtonView(){
        let button = ButtonView()
        let buttonViewModel = ButtonViewModel(titleButton: "Add new place")
        button.configure(with: buttonViewModel)
        
        assertSnapshot(matching: button, as: Snapshotting.image(size: CGSize(width: 343, height: 44)), record: false)
        
    }
    
}
