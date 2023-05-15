//
//  ScannedWifiList.swift
//  WiFiProvider
//
//  Created by gautam  on 15/05/23.
//

import Foundation
  
class ScannedWifiList:Codable{

        let bestType: String
        let bestCategory: String
        let bestName: String
        let bestMake: String
        let bestModel: String
        let bestStorage: String
        let bestOS: String
        let macAddress: String
        let vendor: String
        let ipAddresses: [String]
        let hostName: String
        let state: String
        let firstSeenTimestamp: String

        private enum CodingKeys: String, CodingKey {
            case bestType = "best_type"
            case bestCategory = "best_category"
            case bestName = "best_name"
            case bestMake = "best_make"
            case bestModel = "best_model"
            case bestStorage = "best_storage"
            case bestOS = "best_os"
            case macAddress = "mac_address"
            case vendor = "vendor"
            case ipAddresses = "ip_addresses"
            case hostName = "host_name"
            case state = "state"
            case firstSeenTimestamp = "first_seen_timestamp"
        }
    

}
