//
//  Topic.swift
//  rush
//
//  Created by Martin SIREAU on 10/7/17.
//  Copyright © 2017 msireau/joboyer. All rights reserved.
//

import Foundation

struct Topic {
    
    let name : String
    let user : String
    let date : String
    let id : String
    
    init(n: String, u:String, d:String, id: String) {
        self.name = n
        self.user = u
        self.date = d
        self.id = id
    }
}

