//
//  HomeViewController+MKMapViewDelegate.swift
//  Hereminders
//
//  Created by Rodrigo Borges on 6/7/18.
//  Copyright © 2018 Rodrigo Borges. All rights reserved.
//

import MapKit

extension HomeViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let annotation = view.annotation, let placeAnnotation = annotation as? PlaceAnnotation else {
            return
        }
        
        let place = placeAnnotation.place
        self.viewModel.selectPlace(place)
        self.mapView.moveToAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        if mapView.selectedAnnotations.isEmpty {
            
            self.viewModel.selectPlace(nil)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let circleView = MKCircleRenderer(overlay: overlay)
        circleView.strokeColor = .black
        circleView.fillColor = .clear
        circleView.lineWidth = 2.0
        return circleView
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "customPin"
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            ?? MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        
        annotationView.canShowCallout = true
        if annotation is MKUserLocation {
            return nil
        } else if annotation is Annotation {
            annotationView.image = configureCustomPin()
            return annotationView
        } else {
            return nil
        }
    }
    
    private func configureCustomPin() -> UIImage {
        let customPin =  Asset.iconPin.image
        let size = CGSize(width: 50, height: 50)
        UIGraphicsBeginImageContext(size)
        customPin.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        return resizedImage
    }
}
