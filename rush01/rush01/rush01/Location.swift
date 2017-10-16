//
//  Location.swift
//  rush01
//
//  Created by Martin SIREAU on 10/15/17.
//  Copyright © 2017 Marc FAMILARI. All rights reserved.
//

import Foundation
import MapKit

class Location : NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D){
        
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
