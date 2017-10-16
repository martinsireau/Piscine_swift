//
//  mySingleton.swift
//  deathNote
//
//  Created by Martin SIREAU on 10/4/17.
//  Copyright © 2017 Martin SIREAU. All rights reserved.
//

import Foundation

final class Singleton {
    
    // Can't init is singleton
    private init() { }
    
    // MARK: Shared Instance
    
    static let shared = Singleton()
    
    // MARK: Local Variable
    
    var name : [String] = ["Donald Pmurt", "Joffrey Baratheon", "Ben Solo"]
    var death : [String] = ["Noyé dans son vomi", "Emposoinné", "Tué par Snoke"]
    var date : [String] = ["21 October 2017 17:50:25", "04 October 2017 17:50:25", "30 October 2017 17:30:25"]
}
