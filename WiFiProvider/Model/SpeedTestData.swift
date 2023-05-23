//
//  SpeedTestData.swift
//  WiFiProvider
//
//  Created by gautam  on 16/05/23.
//

import Foundation

class SpeedTestData:Codable{
    var time:String
    var ping:String
    var downloadSpeed:Double
    var uploadSpeed:Double
    init(time: String , ping: String , downloadSpeed: Double, uploadSpeed: Double) {
        self.time = time
        self.ping = ping
        self.downloadSpeed = downloadSpeed
        self.uploadSpeed = uploadSpeed
    }
}
