//
//  API42Delegate.swift
//  rush
//
//  Created by Jordan BOYER on 10/7/17.
//  Copyright © 2017 msireau/joboyer. All rights reserved.
//

import Foundation

protocol API42Delegate : class {
    func treatTopics(arr: [Topic])
    func treatMessages(arr: [Message])
    func treatReplies(arr: [Replies])
    func treatDelete(arr: [Message])
    //    func treatTags(arr: [Tag])
    var userId : Int? {get set}
}
