//
//  MKMapView + Ex.swift
//  Hotel App
//
//  Created by Ivan Puzanov on 01.11.2022.
//

import MapKit

class HAMapPin: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title          = title
        self.locationName   = locationName
        self.coordinate     = coordinate
    }
}

extension MKMapView {
    func setPinUsingMKAnnotation(title: String = "", locationName: String = "", location: CLLocationCoordinate2D) {
        let pin1 = HAMapPin(title: title, locationName: locationName, coordinate: location)
        let coordinateRegion = MKCoordinateRegion(center: pin1.coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
        self.setRegion(coordinateRegion, animated: true)
        self.addAnnotations([pin1])
    }
}
