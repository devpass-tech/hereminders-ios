//
//  PlaceDetailsViewController.swift
//  Hereminders
//
//  Created by Rodrigo Borges on 7/9/18.
//  Copyright © 2018 Rodrigo Borges. All rights reserved.
//

import UIKit

final class PlaceDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var mapLocationView: MapLocationView!

    let place: Place

    private let dataController: DataControllerType

    init(dataController: DataControllerType, place: Place) {

        self.dataController = dataController
        self.place = place
        super.init(nibName: "PlaceDetailsViewController", bundle: .main)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureView()
    }

    private func configureView() {

        self.configureNavigationBar()
        self.configureTableView()
        self.configureMapLocationView()
    }

    private func configureNavigationBar() {

        self.navigationItem.title = L10n.Placedetails.title
    }

    private func configureTableView() {

        TextInputTableViewCell.registerXib(in: self.tableView)

        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.dataSource = self
    }

    private func configureMapLocationView() {

        let viewModel = MapLocationViewModel(coordinate: self.place.coordinate, title: self.place.name)
       // self.mapLocationView.configure(with: viewModel)
        self.mapLocationView.configureWithCustomPin(with: viewModel)
    }
}

extension PlaceDetailsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {

        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

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
        cell.configure(withPlaceholder: L10n.Placedetails.namePlaceholder, andDelegate: self)
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

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        switch section {
        case 0:
            return L10n.Placedetails.name
        case 1:
            return L10n.Placedetails.address
        default:
            return nil
        }
    }
}

extension PlaceDetailsViewController: TextInputCellDelegate {

    func textFieldDidReturn(_ textField: UITextField) {

        if let text = textField.text, !text.isEmpty {

            self.place.name = text
            self.dataController.saveContext()
            self.configureMapLocationView()
            NotificationCenter.default.post(name: .editPlace, object: self.place)
        }
    }
}
