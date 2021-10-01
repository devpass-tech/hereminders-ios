//
//  ReminderListView.swift
//  Hereminders
//
//  Created by Rodrigo Borges on 6/25/18.
//  Copyright © 2018 Rodrigo Borges. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

protocol ReminderListViewDelegate: AnyObject {

    func reminderListViewDidTapOnAddReminderButton()
    func reminderListViewDidTapOnAddNewPlaceButton()
    func reminderListViewWantsToRemoveReminder(_ reminder: Reminder)
}

struct ReminderListViewModel {

    let placeName: String
    let placeAddress: String
    var reminders: [Reminder]

    init(placeName: String, placeAddress: String, reminders: [Reminder]) {

        self.placeName = placeName
        self.placeAddress = placeAddress
        self.reminders = reminders
    }
}

final class ReminderListView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var addReminderButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectPlaceLabel: UILabel!
    @IBOutlet weak var addNewPlaceButton: UIButton!

    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var emptyListView: UIView!
    @IBOutlet weak var emptyListLabel: UILabel!
    
    weak var delegate: ReminderListViewDelegate?

    var viewModel: ReminderListViewModel? = nil {

        didSet {


            if self.viewModel == nil {

                self.listView.isHidden = true
                self.emptyView.isHidden = false

            } else {
                let noReminders = self.viewModel?.reminders.isEmpty ?? true

                self.listView.isHidden = false
                self.emptyView.isHidden = true
                self.emptyListView.isHidden = !noReminders
                self.tableView.isHidden = noReminders
            }

            self.placeNameLabel.text = viewModel?.placeName
            self.placeAddressLabel.text = viewModel?.placeAddress
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {

        self.configureView()
        self.configureTableView()
    }

    private func configureView() {

        Bundle.main.loadNibNamed("ReminderListView", owner: self, options: nil)
        self.addSubview(contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.listView.isHidden = true
        self.emptyView.isHidden = false

        self.addReminderButton.setTitle(L10n.ReminderList.addReminder, for: .normal)
        self.addReminderButton.titleLabel?.lineBreakMode = .byWordWrapping
        self.selectPlaceLabel.text = L10n.ReminderList.selectOrAddPlace
        self.addNewPlaceButton.setTitle(L10n.ReminderList.addNewPlace, for: .normal)
        self.titleLabel.text = L10n.ReminderList.welcome
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 21)

        self.emptyListLabel.text = L10n.ReminderList.noHereminders
    }

    private func configureTableView() {

        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    @IBAction func didTapOnAddReminderButton(_ sender: UIButton) {

        self.delegate?.reminderListViewDidTapOnAddReminderButton()
    }

    @IBAction func didTapOnAddNewPlaceButton(_ sender: UIButton) {

        self.delegate?.reminderListViewDidTapOnAddNewPlaceButton()
    }

    func render(with viewModel: ReminderListViewModel?) {

        self.viewModel = viewModel
        self.tableView.reloadData()
    }
}

extension ReminderListView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.viewModel?.reminders.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let viewModel = self.viewModel else {

            return UITableViewCell()
        }

        var cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell")

        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "ReminderCell")
        }

        let reminder = viewModel.reminders[indexPath.row]

        cell?.textLabel?.text = reminder.desc
        cell?.detailTextLabel?.text = reminder.event == 0 ? L10n.ReminderList.onEntry : L10n.ReminderList.onExit

        return cell!
    }
}

extension ReminderListView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {

        return .none
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let doneAction = UIContextualAction(style: .normal,
                                            title: L10n.ReminderList.done,
                                            handler: { [weak self] action, view, completionHandler in

            self?.handleDoneAction(at: indexPath)
            completionHandler(true)
        })

        doneAction.backgroundColor = UIColor.heremindersGreen

        let configuration = UISwipeActionsConfiguration(actions: [doneAction])
        return configuration
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        return nil
    }

    private func handleDoneAction(at indexPath: IndexPath) {

        let reminder = self.viewModel?.reminders[indexPath.row]
        let notificationIdentifier = reminder?.notificationIdentifier ?? ""

        self.delegate?.reminderListViewWantsToRemoveReminder(reminder!)

        self.viewModel?.reminders.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)

        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
    }
}
