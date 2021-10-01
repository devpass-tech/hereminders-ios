//
//  PlaceListViewController.swift
//  Hereminders
//
//  Created by Rodrigo Borges on 7/7/18.
//  Copyright © 2018 Rodrigo Borges. All rights reserved.
//

import UIKit
import RxSwift

protocol PlaceListViewControllerDelegate: AnyObject {
    
    func placeListViewControllerDidSelectPlace(_ place: Place)
    func placeListViewControllerWantsToSearchPlace()
    func placeListViewControllerDidCancel()
}

class PlaceListViewController: UIViewController {
    
    weak var delegate: PlaceListViewControllerDelegate?
    
    var viewModel: PlaceListViewModel
    
    let placeListView: PlaceListView = {
        let placeListView = PlaceListView()
        
        return placeListView
    }()
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: PlaceListViewModel, delegate: PlaceListViewControllerDelegate?) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = placeListView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindViewModel()
        self.configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.reloadPlaces()
    }
    
    func bindViewModel() {
        
        self.viewModel.placesSubject
            .subscribe(onNext: { [weak self] in
                let placeListViewModel = PlaceListViewViewModel(places: self?.viewModel.places ?? [])
                self?.placeListView.configure(with: placeListViewModel, delegate: self as! PlaceListViewDelegate)
            })
            .disposed(by: self.disposeBag)
    }
    
    func configureView() {
        
        configureNavigationBar()
        configureTableView()
    }
    
    func configureNavigationBar() {
        
        let addPlaceButton = UIBarButtonItem(barButtonSystemItem: .add,
                                             target: self,
                                             action: #selector(didTapAddPlaceButton))
        self.navigationItem.rightBarButtonItem = addPlaceButton

        self.navigationItem.title = L10n.PlaceList.title
    }
    
    func configureTableView() {
    }
    
    @objc func didTapOnCloseButton() {
        
        self.delegate?.placeListViewControllerDidCancel()
    }
    
    @objc func didTapAddPlaceButton() {
        
        self.delegate?.placeListViewControllerWantsToSearchPlace()
    }
}

extension PlaceListViewController: PlaceListViewDelegate {
    func didRemovePlace(at index: Int) {
        viewModel.removePlace(at: index)
    }
    
    func didSelectPlace(at index: Int) {
        let place = self.viewModel.place(at: index)
        self.delegate?.placeListViewControllerDidSelectPlace(place)
    }
}
