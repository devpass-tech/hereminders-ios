//
//  PlaceDetailsViewController.swift
//  Hereminders
//
//  Created by Rodrigo Borges on 7/9/18.
//  Copyright © 2018 Rodrigo Borges. All rights reserved.
//

import UIKit

final class PlaceDetailsViewController: UIViewController {

    let place: Place
    
    lazy var placeDetailsView: PlaceDetailsView = {

        let placeDetailsView = PlaceDetailsView()
        placeDetailsView.delegate = self
        return placeDetailsView
    }()

    private let dataController: DataControllerType
    
    weak var delegate: PlaceDetailsViewProtocol?

    init(dataController: DataControllerType, place: Place) {

        self.dataController = dataController
        self.place = place
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = self.placeDetailsView
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
        self.getDetails()
    }

    private func configureNavigationBar() {

        self.navigationItem.title = L10n.PlaceDetails.title
    }
    
    func getDetails() {
        
        let viewModel = PlaceDetailsViewModel(place: place)
        placeDetailsView.configure(with: viewModel)
    }
}

extension PlaceDetailsViewController: PlaceDetailsViewProtocol {

    func didChangePlace() {
        self.dataController.saveContext()
        NotificationCenter.default.post(name: .editPlace, object: self.place)
    }
}
