//
//  singleton.swift
//  twitterClient
//
//  Created by Martin SIREAU on 10/6/17.
//  Copyright © 2017 Martin SIREAU. All rights reserved.
//

import Foundation

final class Singleton {
    
    static let CUSTOMER_KEY = "EGC1w1Jf8SbQiQXAUGSCtdTtx"
    static let CUSTOMER_SECRET = "SpxEjQXP5Vvup1QfToqOfryGB31PNeXJB7TpIyYun1haWgWvCN"
    static let BEARER = ((CUSTOMER_KEY + ":" + CUSTOMER_SECRET).data(using: String.Encoding.utf8))!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue : 0))
    
    static var accessToken = String()
}
