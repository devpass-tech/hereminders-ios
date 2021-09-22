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
        self.homeView.mapView.moveToAnnotation(annotation)
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
}
