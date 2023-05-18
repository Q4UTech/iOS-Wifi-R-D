//
//  FingNodes.swift
//  WiFiProvider
//
//  Created by gautam  on 18/05/23.
//

import Foundation



class FingNodes: Codable {
    var bestType: String?
    var bestCategory: String?
    var bestName: String?
    var bestMake: String?
    var bestModel: String?
    var bestStorage: String?
    var bestOS: String?
    var macAddress: String?
    var vendor: String?
    var ipAddresses: [String]?
    var hostName: String?
    var state: String?
    var firstSeenTimestamp: String?
    
    enum CodingKeys: String, CodingKey {
        case bestType = "best_type"
        case bestCategory = "best_category"
        case bestName = "best_name"
        case bestMake = "best_make"
        case bestModel = "best_model"
        case bestStorage = "best_storage"
        case bestOS = "best_os"
        case macAddress = "mac_address"
        case vendor
        case ipAddresses = "ip_addresses"
        case hostName = "host_name"
        case state
        case firstSeenTimestamp = "first_seen_timestamp"
    }
}
