//
//  Tweet.swift
//  twitterClient
//
//  Created by Martin SIREAU on 10/6/17.
//  Copyright © 2017 Martin SIREAU. All rights reserved.
//

import Foundation

struct Tweet : CustomStringConvertible{
    let name : String
    let text : String
    let date : String
    
    var description: String {
        return "\(name): \(text)"
    }
}
