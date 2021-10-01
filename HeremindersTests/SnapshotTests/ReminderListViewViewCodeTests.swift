//
//  ReminderListViewViewCodeTests.swift
//  HeremindersTests
//
//  Created by Dairan on 25/08/21.
//  Copyright © 2021 Rodrigo Borges. All rights reserved.
//

@testable import Hereminders
import SnapshotTesting
import XCTest

class ReminderListViewViewCodeTests: XCTestCase {
  func testReminderListViewViewCode() throws {

    let titleSubtitleVM: TitleSubtitleViewModel = TitleSubtitleViewModel(title: "Nome do endereço", subtitle: "Rua Bela Cinta, 1200", urlLinkedin: "https://www.linkedin.com/in")
    let reminders: [ReminderItemModel] = [
      ReminderItemModel(description: "Jogar água na planta", event: 1),
      ReminderItemModel(description: "Tirar roupas do varal", event: 0),
      ReminderItemModel(description: "Desligar as luzes", event: 1),
    ]
    let buttonVM = ButtonViewModel(titleButton: L10n.ReminderList.addReminder)

    let viewModel = ReminderListViewViewCodeViewModel(titleSubtitleViewModel: titleSubtitleVM,
                                                      remindersViewModel: reminders,
                                                      buttonViewModel: buttonVM)

    let sut = ReminderListViewViewCode()

    sut.configure(with: viewModel)

    let snapshopSize = CGSize(width: 375, height: 600)
    assertSnapshot(matching: sut, as: .image(size: snapshopSize), record: false)
  }
}
