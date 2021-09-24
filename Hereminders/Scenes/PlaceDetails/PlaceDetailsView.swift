//
//  PlaceDetailsView.swift
//  Hereminders
//
//  Created by Elena Diniz on 23/09/21.
//  Copyright © 2021 Rodrigo Borges. All rights reserved.
//

import Foundation
import UIKit

class PlaceDetailsView: UIView {
    
    private let stackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let mapLocationView: MapLocationView = {
        
        let mapLocationView = MapLocationView()
        mapLocationView.translatesAutoresizingMaskIntoConstraints = false
        
        return mapLocationView
    }()
    
    private let tableView: UITableView = {
        
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = tableView as? UITableViewDataSource
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        
        return tableView
    }()
    
    private func configureNavigationBar() {
    
        let navigationItem = UINavigationItem()
        navigationItem.title = L10n.PlaceDetails.title
        }
    
    init() {
        super.init(frame: .zero)
        
        self.configureView()
        self.configureConstraints()
        self.configureNavigationBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        
        self.backgroundColor = .black
        self.addSubview(self.stackView)
        self.stackView.addArrangedSubview(self.mapLocationView)
        self.stackView.addArrangedSubview(self.tableView)
    }
    
    private func configureConstraints() {
        
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: topAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            self.mapLocationView.heightAnchor.constraint(equalToConstant: 200),
            self.tableView.heightAnchor.constraint(equalToConstant: 608)
        ])
    }
}

extension PlaceDetailsView: UITableViewDataSource {
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
        let place = Place()
        let cell: TextInputTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure(withPlaceholder: L10n.PlaceDetails.namePlaceholder, andDelegate: self)
        cell.textField.text = place.name
        return cell
    }

    func addressCell(inTableView tableView: UITableView, forIndexPath indexPath: IndexPath) -> UITableViewCell {
        let place = Place()
        var cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell")

        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "AddressCell")
            cell?.selectionStyle = .none
        }

        cell?.textLabel?.text = place.address
        return cell!
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

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

extension PlaceDetailsView: TextInputCellDelegate {
    
        func textFieldDidReturn(_ textField: UITextField) {
    
            if let text = textField.text, !text.isEmpty {
                let place = Place()
    
                place.name = text
                NotificationCenter.default.post(name: .editPlace, object: place)
            }
        }
    }
