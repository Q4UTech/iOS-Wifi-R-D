//
//  SpeedTestData.swift
//  WiFiProvider
//
//  Created by gautam  on 16/05/23.
//

import Foundation

class SpeedTestData:NSObject{
    var time:String?
    var date:String?
    var ping:Double?
    var downloadSpeed:Double?
    var uploadSpeed:Double?
    init(time: String? , date: String? , ping: Double? , downloadSpeed: Double?, uploadSpeed: Double?) {
        self.time = time
        self.date = date
        self.ping = ping
        self.downloadSpeed = downloadSpeed
        self.uploadSpeed = uploadSpeed
    }
}
