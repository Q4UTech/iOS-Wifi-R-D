//
//  FingIsp.swift
//  WiFiProvider
//
//  Created by gautam  on 18/05/23.
//

import Foundation

class FingIsp: Codable {
    var address: String?
    var hostName: String?
    var countryCode: String?
    var countryName: String?
    var countryRegionCode: String?
    var countryRegion: String?
    var countryCity: String?
    var countryPostalCode: String?
    var ispName: String?
    var organization: String?
    
    enum CodingKeys: String, CodingKey {
        case address
        case hostName = "host_name"
        case countryCode = "country_code"
        case countryName = "country_name"
        case countryRegionCode = "country_region_code"
        case countryRegion = "country_region"
        case countryCity = "country_city"
        case countryPostalCode = "country_postal_code"
        case ispName = "isp_name"
        case organization
    }
}
