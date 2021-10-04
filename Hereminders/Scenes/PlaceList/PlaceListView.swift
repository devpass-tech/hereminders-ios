//
//  PlaceListView.swift
//  Hereminders
//
//  Created by Felipe Forcinetti on 22/09/21.
//  Copyright © 2021 Rodrigo Borges. All rights reserved.
//

import Foundation
import UIKit

protocol PlaceListViewDelegate: AnyObject {
    func didRemovePlace(at index: Int)
    func didSelectPlace(at index: Int)
}

class PlaceListView: UIView, ViewProtocol {
    
    var viewModel: PlaceListViewViewModel?
    weak var delegate: PlaceListViewDelegate?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .white
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSubviews() {
        addSubview(tableView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
    }
    
    func configure(with viewModel: PlaceListViewViewModel, delegate: PlaceListViewDelegate) {
        self.delegate = delegate
        self.viewModel = viewModel
        tableView.reloadData()
    }
    
}

extension PlaceListView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.places.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "PlaceListCell")
        
        if let place = self.viewModel?.places[indexPath.row] {
            cell.textLabel?.text = place.name
            cell.detailTextLabel?.text = place.address
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.viewModel?.places.remove(at: indexPath.row)
            self.delegate?.didRemovePlace(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.delegate?.didSelectPlace(at: indexPath.row)
    }
}
