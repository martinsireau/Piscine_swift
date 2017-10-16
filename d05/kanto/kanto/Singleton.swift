//
//  Singleton.swift
//  kanto
//
//  Created by Martin SIREAU on 10/9/17.
//  Copyright © 2017 Martin SIREAU. All rights reserved.
//

import Foundation
import MapKit

final class Singleton {
    
    private init() { }
    
    static let shared = Singleton()
    
    var allPlaces = [Places]()
    
    var selectedPlace = Places(name: "42", description: "Ecole trop Stylée", coor: CLLocationCoordinate2D(latitude: 48.896447, longitude: 2.318554))
}
