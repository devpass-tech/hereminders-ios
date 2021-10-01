//
//  PlaceSearchViewController.swift
//  Hereminders
//
//  Created by Rodrigo Borges on 6/21/18.
//  Copyright © 2018 Rodrigo Borges. All rights reserved.
//

import UIKit
import MapKit

struct PlaceResult {

    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
}

protocol PlaceSearchViewControllerDelegate: AnyObject {
    func didSelectPlace(_ place: PlaceResult)
    func didCancel()
}

class PlaceSearchViewController: UIViewController {

    weak var delegate: PlaceSearchViewControllerDelegate?

	lazy var placeSearchView: PlaceSearchView = {
		let screen = PlaceSearchView()
		screen.configureDelegate(delegate: self)
		return screen
	}()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = L10n.PlaceSearch.namePlaceholder
        return searchController
    }()

    private var lastSearch: MKLocalSearch?
    private var places: [PlaceResult] = []

	init(delegate: PlaceSearchViewControllerDelegate) {
		self.delegate = delegate
		super.init(nibName: nil, bundle: nil)
	}

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	override func loadView() {
		self.view = placeSearchView
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.async {
            
            self.searchController.searchBar.becomeFirstResponder()
        }
    }

    func configureView() {
        configureNavigationBar()
    }

    func configureNavigationBar() {

        let barButtonItem = UIBarButtonItem.customBarButtonItem(with: Asset.iconCross.image,
                                                                for: self,
                                                                and: #selector(didTapOnCloseButton))
        self.navigationItem.leftBarButtonItem = barButtonItem

        self.definesPresentationContext = true
        self.navigationItem.searchController = self.searchController
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.title = L10n.PlaceSearch.title
    }

    @objc func didTapOnCloseButton() {

        self.delegate?.didCancel()
    }
}

extension PlaceSearchViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {

        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(performSearch(_:)), object: searchController)
        self.perform(#selector(performSearch(_:)), with: searchController, afterDelay: 1)
    }

    @objc func performSearch(_ searchController: UISearchController) {
		
		if searchController.searchBar.text == nil || searchController.searchBar.text == "" {
			return
		}

		  self.placeSearchView.startAnimating()

        self.lastSearch?.cancel()
        self.lastSearch = nil

        let text = searchController.searchBar.text

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = text

        self.lastSearch = MKLocalSearch(request: request)
        self.lastSearch?.start(completionHandler: self.handleSearch)
    }

    func handleSearch(response: MKLocalSearch.Response?, error: Error?) {

        let places: [PlaceResult] = response?.mapItems.map({ mapItem in

            let name = mapItem.name ?? ""
            let address = mapItem.placemark.formattedAddress()
            let coordinate = mapItem.placemark.coordinate
            return PlaceResult(name: name,
                               address: address,
                               coordinate: coordinate)
        }) ?? []

        self.places = places
		  self.placeSearchView.stopAnimating()
    }
}

// MARK: - Extension PlaceSearchViewDelegate
extension PlaceSearchViewController: PlaceSearchViewDelegate {
	
	func numberOfRows() -> Int {
		return self.places.count
	}
	
	func getPlaces(_ indexPath: IndexPath) -> PlaceResult {
		return self.places[indexPath.row]
	}
	
	func didSelectRowAt(_ indexPath: IndexPath) {
		let place = self.places[indexPath.row]
		self.delegate?.didSelectPlace(place)
	}
	
}
