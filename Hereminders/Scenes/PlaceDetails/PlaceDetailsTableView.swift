//
//  File.swift
//  Hereminders
//
//  Created by Elena Diniz on 24/09/21.
//  Copyright © 2021 Rodrigo Borges. All rights reserved.
//

import UIKit

class PlaceDetailsTableView: UITableViewController {
    
    let place: Place

    private let dataController: DataControllerType
    
    init(place: Place, dataController: DataControllerType) {
        self.dataController = dataController
        self.place = place

        super.init(style: .grouped)
        TextInputTableViewCell.registerXib(in: tableView)
        self.tableView.dataSource = self
    }
    
//    init(frame: CGRect = .zero) {
//        super.init(frame: frame)
//
//        configureView()
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    convenience init() {
//        self.init(frame: .zero)
//    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:
            return self.nameCell(inTableView: tableView, forIndexPath: indexPath)
        case 1:
            return self.addressCell(inTableView: tableView, forIndexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }

    func nameCell(inTableView tableView: UITableView, forIndexPath indexPath: IndexPath) -> TextInputTableViewCell {
        let cell: TextInputTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure(withPlaceholder: L10n.PlaceDetails.namePlaceholder, andDelegate: self)
        cell.textField.text = self.place.name
        return cell
    }

    func addressCell(inTableView tableView: UITableView, forIndexPath indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell")

        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "AddressCell")
            cell?.selectionStyle = .none
        }

        cell?.textLabel?.text = self.place.address
        return cell!
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        switch section {
        case 0:
            return L10n.PlaceDetails.name
        case 1:
            return L10n.PlaceDetails.address
        default:
            return nil
        }
    }
}

extension PlaceDetailsTableView: TextInputCellDelegate {

    func textFieldDidReturn(_ textField: UITextField) {

        if let text = textField.text, !text.isEmpty {

            self.place.name = text
            self.dataController.saveContext()
            self.loadView()
            NotificationCenter.default.post(name: .editPlace, object: self.place)
        }
    }
}
