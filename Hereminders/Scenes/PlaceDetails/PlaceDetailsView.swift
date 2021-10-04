//
//  PlaceDetailsView.swift
//  Hereminders
//
//  Created by Elena Diniz on 23/09/21.
//  Copyright © 2021 Rodrigo Borges. All rights reserved.
//

import UIKit

protocol PlaceDetailsViewProtocol: AnyObject {
    func didChangePlace()
}

class PlaceDetailsView: UIView {
    
    var place: Place?
    
    weak var delegate: PlaceDetailsViewProtocol?
    
    private let stackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
    
    let mapLocationView: MapLocationView = {
        
        let mapLocationView = MapLocationView()
        mapLocationView.translatesAutoresizingMaskIntoConstraints = false
        
        return mapLocationView
    }()
    
    private lazy var tableView: UITableView = {

        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        
        TextInputTableViewCell.registerXib(in: tableView)

        return tableView
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        configureView()
        configureConstraints()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: PlaceDetailsViewModel) {
        self.place = viewModel.place
        let viewModelMap = MapLocationViewModel(coordinate: self.place!.coordinate, title: self.place!.name, radius: viewModel.place.radius)
        self.mapLocationView.configure(with: viewModelMap)
        self.tableView.reloadData()
    }
}

// MARK: - TableViewDataSource
extension PlaceDetailsView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {

        return 3
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
        case 2:
            return self.radiusCell(inTableView: tableView, forIndexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }

    func nameCell(inTableView tableView: UITableView, forIndexPath indexPath: IndexPath) -> TextInputTableViewCell {
        let cell: TextInputTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure(withPlaceholder: L10n.PlaceDetails.namePlaceholder, andDelegate: self)
        cell.textField.text = self.place?.name
        return cell
    }

    func addressCell(inTableView tableView: UITableView, forIndexPath indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell")

        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "AddressCell")
            cell?.selectionStyle = .none
        }

        cell?.textLabel?.text = self.place?.address
        return cell!
    }

    func radiusCell(inTableView tableView: UITableView, forIndexPath indexPath: IndexPath) -> RadiusTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RadiusCell") as? RadiusTableViewCell ?? RadiusTableViewCell()
        let cellModel = RadiusTableViewCellModel(value: self.place?.radius ?? Int32(100))
        cell.configure(with: cellModel, andDelegate: self)
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        switch section {
        case 0:
            return L10n.PlaceDetails.name
        case 1:
            return L10n.PlaceDetails.address
        case 2:
            return L10n.PlaceDetails.radius
        default:
            return nil
        }
    }
}
//MARK: - Cell Delegate
extension PlaceDetailsView: TextInputCellDelegate {

    func textFieldDidReturn(_ textField: UITextField) {

        if let text = textField.text, !text.isEmpty {

            self.place?.name = text
            self.delegate?.didChangePlace()
        }
    }
}

extension PlaceDetailsView: RadiusTableViewCellDelegate {

    func didChangeSliderValue(to value: Int) {

        guard let place = self.place else {
            return
        }

        place.radius = Int32(value)

        let viewModel = MapLocationViewModel(coordinate: place.coordinate, title: place.name, radius: place.radius)
        self.mapLocationView.configure(with: viewModel)

        self.delegate?.didChangePlace()
    }
}

//MARK: -View Protocol
extension PlaceDetailsView: ViewProtocol {
    func configureSubviews() {
        self.backgroundColor = .white
        self.addSubview(self.stackView)
        self.stackView.addArrangedSubview(self.mapLocationView)
        self.stackView.addArrangedSubview(self.tableView)
    }
    
    func configureConstraints() {
        
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: topAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            self.mapLocationView.heightAnchor.constraint(equalToConstant: 200),
            self.tableView.heightAnchor.constraint(equalToConstant: 608)
        ])
    }
}
