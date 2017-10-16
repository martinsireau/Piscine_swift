//
//  Message.swift
//  rush
//
//  Created by Jordan BOYER on 10/7/17.
//  Copyright © 2017 msireau/joboyer. All rights reserved.
//

import Foundation

struct Message {
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

struct Tag {
    let name : String
    let id : Int
    
    init(n:String,i:Int) {
        self.name = n
        self.id = i
    }
}
