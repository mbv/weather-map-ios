//
//  CityAnnotation.swift
//  lab3
//
//  Created by Admin on 07.03.17.
//  Copyright © 2017 user. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class CityAnnotation: NSObject, MKAnnotation {
    var id: Int?
    var title: String?
    var subtitle: String?
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
}
