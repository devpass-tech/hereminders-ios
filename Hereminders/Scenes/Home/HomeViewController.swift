//
//  HomeViewController.swift
//  Hereminders
//
//  Created by Rodrigo Borges on 3/24/18.
//  Copyright © 2018 Rodrigo Borges. All rights reserved.
//

import UIKit
import MapKit
import RxSwift

protocol HomeViewControllerDelegate: AnyObject {
    
    func homeViewControllerDidOpenReminder(_ reminder: Reminder)
    func homeViewControllerWantsToAddNewReminder(at place: Place?)
    func homeViewControllerWantsToAddNewPlace()
    func homeViewControllerWantsToOpenSettings()
}

final class HomeViewController: UIViewController {
    
    weak var delegate: HomeViewControllerDelegate?
    
    lazy var homeView: HomeView = {
        let screen = HomeView()
        screen.configureDelegate(delegate: self)
        return screen
    }()
    
    let viewModel: HomeViewModel

    private let disposeBag = DisposeBag()
    
    init(viewModel: HomeViewModel, delegate: HomeViewControllerDelegate) {
        self.delegate = delegate
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindViewModel()
        self.configureView()
        self.addNotificationObservers()
    }
    
    func addNotificationObservers() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleAddNewPlaceNotification(_:)),
                                               name: Notification.Name.addNewPlace,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleRemovePlaceNotification(_:)),
                                               name: Notification.Name.removePlace,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleEditPlaceNotification(_:)),
                                               name: Notification.Name.editPlace,
                                               object: nil)
    }
    
    func bindViewModel() {
        
        self.viewModel.annotationsSubject
            .subscribe(onNext: { [weak self] annotations in
                self?.homeView.mapView.replaceAnnotations(with: annotations)
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.selectedPlaceSubject
            .subscribe(onNext: { [weak self] selectedPlace in
                self?.handleSelectedPlaceEvent(selectedPlace)
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.selectedAnnotationSubject
            .subscribe(onNext: { [weak self] annotation in
                
                self?.homeView.mapView.moveToAnnotation(annotation)
                self?.homeView.mapView.selectAnnotation(annotation, animated: true)
            })
            .disposed(by: self.disposeBag)
    }
    
    func handleSelectedPlaceEvent(_ selectedPlace: (Place, [Reminder])?) {
        
        self.homeView.mapView.removeOverlays(self.homeView.mapView.overlays)
        
        if let place = selectedPlace {
            
            let viewModel = ReminderListViewModel(placeName: place.0.name,
                                                  placeAddress: place.0.address,
                                                  reminders: place.1)
            self.homeView.reminderListView.render(with: viewModel)
            
            let coordinate = CLLocationCoordinate2D(latitude: place.0.latitude,
                                                    longitude: place.0.longitude)
            let circle = MKCircle(center: coordinate, radius: 100)
            self.homeView.mapView.addOverlay(circle)
        } else {
            
            self.homeView.reminderListView.render(with: nil)
        }
    }
    
    func configureView() {
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        self.configureNavigationBar()
        self.configureMapView()
        self.configureReminderListView()
    }
    
    func configureNavigationBar() {
        
        let barButtonItem = UIBarButtonItem.customBarButtonItem(with: Asset.iconSettings.image,
                                                                for: self,
                                                                and: #selector(didTapOnSettingsButton))
        self.navigationItem.rightBarButtonItem = barButtonItem
        
        self.navigationItem.title = self.viewModel.title
    }
    
    func configureMapView() {
        
        self.homeView.mapView.delegate = self
        self.homeView.mapView.showsUserLocation = true
    }
    
    func configureReminderListView() {
        
        self.homeView.reminderListView.delegate = self
    }
    
    @objc func didTapOnSettingsButton() {
        
        self.delegate?.homeViewControllerWantsToOpenSettings()
    }
    
    @objc func handleAddNewPlaceNotification(_ notification: Notification) {
        
        guard let place = notification.object as? Place else {
            
            return
        }
        
        let annotation = PlaceAnnotation(place: place)
        self.homeView.mapView.addAnnotation(annotation)
    }
    
    @objc func handleRemovePlaceNotification(_ notification: Notification) {
        
        guard let place = notification.object as? Place else {
            
            return
        }
        
        let annotations = self.homeView.mapView.annotations
            .compactMap({ $0 as? PlaceAnnotation })
            .filter({ $0.coordinate.latitude == place.coordinate.latitude && $0.coordinate.longitude == place.coordinate.longitude })
        
        if let annotation = annotations.first {
            
            self.homeView.mapView.removeAnnotation(annotation)
        }
    }
    
    @objc func handleEditPlaceNotification(_ notification: Notification) {
        
        guard let place = notification.object as? Place else {
            
            return
        }
        
        let annotations = self.homeView.mapView.annotations
            .compactMap({ $0 as? PlaceAnnotation })
            .filter({ $0.coordinate.latitude == place.coordinate.latitude && $0.coordinate.longitude == place.coordinate.longitude })
        
        if let annotation = annotations.first {
            
            let newPlaceAnnotation = PlaceAnnotation(place: place)
            self.homeView.mapView.removeAnnotation(annotation)
            self.homeView.mapView.addAnnotation(newPlaceAnnotation)
        }
    }
}

extension HomeViewController: ReminderListViewDelegate {
    
    func reminderListViewDidTapOnAddReminderButton() {
        
        guard let annotation = self.homeView.mapView.selectedAnnotations.first,
              let placeAnnotation = annotation as? PlaceAnnotation else {
            return
        }
        
        let place = placeAnnotation.place
        self.delegate?.homeViewControllerWantsToAddNewReminder(at: place)
    }
    
    func reminderListViewDidTapOnAddNewPlaceButton() {
        
        self.delegate?.homeViewControllerWantsToAddNewPlace()
    }
    
    func reminderListViewWantsToRemoveReminder(_ reminder: Reminder) {
        
        self.viewModel.removeReminder(reminder)
    }
}



extension HomeViewController: HomeViewControllerDelegate {
    func homeViewControllerDidOpenReminder(_ reminder: Reminder) {
        self.delegate?.homeViewControllerDidOpenReminder(reminder)
    }
    
    func homeViewControllerWantsToAddNewReminder(at place: Place?) {
        self.delegate?.homeViewControllerWantsToAddNewReminder(at: place)
    }
    
    func homeViewControllerWantsToAddNewPlace() {
        self.delegate?.homeViewControllerWantsToAddNewPlace()
    }

    func homeViewControllerWantsToOpenSettings() {
        self.delegate?.homeViewControllerWantsToOpenSettings()
    }
}
