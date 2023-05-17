//
//  SpeedData.swift
//  WiFiProvider
//
//  Created by gautam  on 17/05/23.
//

import Foundation

class SpeedData:Decodable{
    var ping:Int?
    var uploadSpeed:Double?
    var downloadSpeed:Double?
    var time:String?
    
    init(ping: Int? , uploadSpeed: Double?, downloadSpeed: Double?, time: String? ) {
        self.ping = ping
        self.uploadSpeed = uploadSpeed
        self.downloadSpeed = downloadSpeed
        self.time = time
    }
}
