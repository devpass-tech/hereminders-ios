//
//  PlaceSearchView.swift
//  Hereminders
//
//  Created by Alexandre Cardoso on 01/09/21.
//  Copyright © 2021 Rodrigo Borges. All rights reserved.
//

import UIKit

protocol PlaceSearchViewDelegate: AnyObject {
	func numberOfRows() -> Int
	func getPlaces(_ indexPath: IndexPath) -> PlaceResult
	func didSelectRowAt(_ indexPath: IndexPath)
}

class PlaceSearchView: UIView {
	
	// MARK: - UI Element
	 lazy var tableView: UITableView = {
		let tableView = UITableView(frame: .zero)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.delegate = self
		tableView.dataSource = self
		return tableView
	}()
	
	private var activityIndicator: UIActivityIndicatorView = {
		let activity = UIActivityIndicatorView(frame: .zero)
		activity.translatesAutoresizingMaskIntoConstraints = false
		activity.style = .medium
		return activity
	}()
	
	private var mainView: UIView = {
		let view = UIView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .systemGray
		view.isHidden = true
		return view
	}()
	
	private weak var delegate: PlaceSearchViewDelegate?
	
	// MARK: - Initialize
	override init(frame: CGRect = .zero) {
		super.init(frame: frame)
		configureView()
	}
		
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		
		configureView()
	}
	
	// MARK: - Function
	func configureDelegate(delegate: PlaceSearchViewDelegate?) {
		self.delegate = delegate
	}
	
	func startAnimating() {
		self.tableView.isHidden = true
		self.mainView.isHidden = false
		self.activityIndicator.isHidden = false
		self.activityIndicator.startAnimating()
	}
	func stopAnimating() {
		self.tableView.isHidden = false
		self.mainView.isHidden = true
		self.activityIndicator.stopAnimating()
		self.tableView.reloadData()
    }
}

// MARK: - Extension ViewProtocol
extension PlaceSearchView: ViewProtocol {
	
	func configureSubviews() {
		addSubview(tableView)
		mainView.addSubview(activityIndicator)
		addSubview(mainView)
	}
	
	func configureConstraints() {
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
			
			mainView.topAnchor.constraint(equalTo: tableView.topAnchor),
			mainView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
			mainView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
			mainView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
			
			activityIndicator.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
			activityIndicator.centerXAnchor.constraint(equalTo: mainView.centerXAnchor)
		])
	}
}

// MARK: - Extension UITableViewDataSource
extension PlaceSearchView: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.delegate?.numberOfRows() ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceSearchCell"),
				let place = self.delegate?.getPlaces(indexPath)
		else {
			return UITableViewCell(style: .subtitle, reuseIdentifier: "PlaceSearchCell")
		}
				
		cell.textLabel?.text = place.name
		cell.detailTextLabel?.text = place.address
		
		return cell
	}
}

// MARK: - Extension UITableViewDelegate
extension PlaceSearchView: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {		
		tableView.deselectRow(at: indexPath, animated: true)
		self.delegate?.didSelectRowAt(indexPath)
	}
}
