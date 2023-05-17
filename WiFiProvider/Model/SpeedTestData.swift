//
//  SpeedTestData.swift
//  WiFiProvider
//
//  Created by gautam  on 16/05/23.
//

import Foundation

class SpeedTestData:Codable{
    var time:String?
    var ping:Double?
    var downloadSpeed:Double?
    var uploadSpeed:Double?
    init(time: String? , ping: Double? , downloadSpeed: Double?, uploadSpeed: Double?) {
        self.time = time
        self.ping = ping
        self.downloadSpeed = downloadSpeed
        self.uploadSpeed = uploadSpeed
    }
}
