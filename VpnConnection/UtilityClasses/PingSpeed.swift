//
//  PingSpeed.swift
//  WiFiProvider
//
//  Created by gautam  on 12/05/23.
//

import Foundation

struct PingSpeed:Codable{
    var regionName:String
    var query:String
    var city:String
  
    
    init(regionName: String,query:String,city:String) {
        self.regionName = regionName
        self.query = query
        self.city = city
    }
    
    
}

