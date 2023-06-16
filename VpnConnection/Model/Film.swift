//
//  Film.swift
//  VpnConnection
//
//  Created by gautam  on 15/06/23.
//

import Foundation

struct Film:Codable{
    var regionName:String
    var query:String
    var city:String
  
    
    init(regionName: String,query:String,city:String) {
        self.regionName = regionName
        self.query = query
        self.city = city
    }
    
    
}
