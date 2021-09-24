//
//  MapLocationView.swift
//  Hereminders
//
//  Created by Gabriela Sillis on 18/08/21.
//  Copyright © 2021 Rodrigo Borges. All rights reserved.
//

import UIKit
import MapKit

final class MapLocationView: UIView {
    
    private var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.mapType = MKMapType.standard
        map.isUserInteractionEnabled = false
        
        return map
    }()
    
    init() {
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    public func configure(with viewModel: MapLocationViewModel) {
        let region = MKCoordinateRegion(center: viewModel.coordinate, span: .default)
        self.mapView.setRegion(region, animated: true)
        
        self.mapView.delegate = self
        
        let pin = Annotation(title: viewModel.title, coordinate: viewModel.coordinate)
        self.mapView.addAnnotation(pin)
    }
}

// MARK: - Extension ViewProtocol
extension MapLocationView: ViewProtocol {
    
    func configureSubviews() {
        self.addSubview(self.mapView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            self.mapView.topAnchor.constraint(equalTo: topAnchor),
            self.mapView.bottomAnchor.constraint(equalTo: bottomAnchor),
            self.mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            self.mapView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
}

// MARK: - Extension MKMapViewDelegate
extension MapLocationView : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "customPin"
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            ?? MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        
        annotationView.canShowCallout = true
        if annotation is MKUserLocation {
            return nil
        } else if annotation is Annotation {
            let customPin =  Asset.iconPin.image
            let size = CGSize(width: 50, height: 50)
            UIGraphicsBeginImageContext(size)
            customPin.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            annotationView.image = resizedImage
            return annotationView
        } else {
            return nil
        }
    }
}
