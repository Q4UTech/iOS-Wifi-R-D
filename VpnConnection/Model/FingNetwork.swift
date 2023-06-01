//
//  FingNetwork.swift
//  WiFiProvider
//
//  Created by gautam  on 18/05/23.
//

import Foundation

class FingNetwork: Codable {
    var address: String?
    var addressType: String?
    var dnsAddress: String?
    var maskPrefixLength: Int?
    var originalPrefixLength: Int?
    var name: String?
    var timeZone: String?
    
    enum CodingKeys: String, CodingKey {
        case address
        case addressType = "address_type"
        case dnsAddress = "dns_address"
        case maskPrefixLength = "mask_prefix_length"
        case originalPrefixLength = "original_prefix_length"
        case name
        case timeZone = "time_zone"
    }
}
