//
//  Singleton.swift
//  rush
//
//  Created by Martin SIREAU on 10/8/17.
//  Copyright © 2017 msireau/joboyer. All rights reserved.
//

import Foundation

final class Singleton {
    
    private init() { }
    
    static let shared = Singleton()
    
    var token : String?
    var userId : Int?
    var API42 : API42Controller?
    var topicId : String?
    var messageId : String?
    var repliesId : String?

}
