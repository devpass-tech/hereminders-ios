//
//  MapHeaderView.swift
//  Hereminders
//
//  Created by Rodrigo Borges on 6/8/18.
//  Copyright © 2018 Rodrigo Borges. All rights reserved.
//

import UIKit
import MapKit

protocol MapHeaderViewDelegate: AnyObject {
    
    func didTapOnAddPlaceButton()
}

struct MapHeaderViewModel {
    
    var placeName: String?
    var placeCoordinate: CLLocationCoordinate2D?
    
    func hasPlace() -> Bool {
        
        return placeName != nil && placeCoordinate != nil
    }
}

class MapHeaderView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addPlaceView: UIView!
    
    weak var delegate: MapHeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        
        Bundle.main.loadNibNamed("MapHeaderView", owner: self, options: nil)
        self.addSubview(contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.mapView.isUserInteractionEnabled = false
    }
    
    func render(with viewModel: MapHeaderViewModel) {
        
        if !viewModel.hasPlace() {
            self.addPlaceView.isHidden = false
            return
        }
        
        guard let placeName = viewModel.placeName,
              let placeCoordinate = viewModel.placeCoordinate else {
            return
        }
        
        self.addPlaceView.isHidden = true
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        let annotation = Annotation(title: placeName,
                                    coordinate: placeCoordinate)
        
        self.mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: placeCoordinate,
                                        span: .default)
        self.mapView.setRegion(region, animated: false)
    }
    
    @IBAction func didTapOnAddPlaceButton(_ sender: Any) {
        
        self.delegate?.didTapOnAddPlaceButton()
    }
}
