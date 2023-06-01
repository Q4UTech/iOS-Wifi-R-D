//
//  FingScanResponse.swift
//  WiFiProvider
//
//  Created by gautam  on 18/05/23.
//

import Foundation

class FingScanResponse: Codable {
    var lastChangeTimestamp: String?
    var gatewayIpAddress: String?
    var gatewayMacAddress: String?
    var fingNetwork: FingNetwork?
    var fingIsp: FingIsp?
    var nodes: [FingNodes]?
    var progress: Int?
    var enriched: String?
    var completed: String?
    
    enum CodingKeys: String, CodingKey {
        case lastChangeTimestamp = "last_change_timestamp"
        case gatewayIpAddress = "gateway_ip_address"
        case gatewayMacAddress = "gateway_mac_address"
        case fingNetwork = "network"
        case fingIsp = "isp"
        case nodes
        case progress
        case enriched
        case completed
    }
}
