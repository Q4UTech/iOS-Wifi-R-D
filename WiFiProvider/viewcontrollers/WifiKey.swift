//
//  WifiKey.swift
//  WiFiProvider
//
//  Created by gautam  on 12/05/23.
//

import Foundation


class WifiKey:Codable{
    var wifiKey:String?
    
    init(wifiKey: String?) {
        self.wifiKey = wifiKey
    }
}
