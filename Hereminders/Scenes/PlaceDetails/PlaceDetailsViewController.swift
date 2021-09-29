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
    
    let placeDetailsView = PlaceDetailsView()

    private let dataController: DataControllerType

    init(dataController: DataControllerType, place: Place) {

        self.dataController = dataController
        self.place = place
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = PlaceDetailsView()
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
//        self.configureMapLocationView()
    }

    private func configureNavigationBar() {

        self.navigationItem.title = L10n.PlaceDetails.title
    }
}
