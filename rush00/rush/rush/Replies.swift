//
//  Replies.swift
//  rush
//
//  Created by Martin SIREAU on 10/8/17.
//  Copyright © 2017 msireau/joboyer. All rights reserved.
//

import Foundation

struct Replies {
    let user : String
    let date : String
    let text : String
    let id : String
    let userId : String
    
    init(u:String,d:String,t:String,id:String,uid:String) {
        self.user = u
        self.date = d
        self.text = t
        self.id = id
        self.userId = uid
    }
}
