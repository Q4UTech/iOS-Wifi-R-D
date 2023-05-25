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
    var connectionType:String
    var ipAddress:String
    var providerName:String
    init(time: String, ping: String, downloadSpeed: Double, uploadSpeed: Double, connectionType: String, ipAddress: String, providerName: String) {
        self.time = time
        self.ping = ping
        self.downloadSpeed = downloadSpeed
        self.uploadSpeed = uploadSpeed
        self.connectionType = connectionType
        self.ipAddress = ipAddress
        self.providerName = providerName
    }
}
