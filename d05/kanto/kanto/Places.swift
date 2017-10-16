//
//  Places.swift
//  kanto
//
//  Created by Martin SIREAU on 10/9/17.
//  Copyright © 2017 Martin SIREAU. All rights reserved.
//

import Foundation
import MapKit

struct Places {
    let name : String
    let desc : String
    let coor : CLLocationCoordinate2D
    
    init(name: String, description: String, coor: CLLocationCoordinate2D) {
        self.name = name
        self.desc = description
        self.coor = coor
    }
}
