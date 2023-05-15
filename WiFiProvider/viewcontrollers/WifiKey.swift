//
//  WifiKey.swift
//  WiFiProvider
//
//  Created by gautam  on 12/05/23.
//

import Foundation


class WifiKey:Codable{
    var status:String?
    var message:String?
    var key:String?
    
    init(status: String? = nil, message: String? = nil, key: String? = nil) {
        self.status = status
        self.message = message
        self.key = key
    }
}
