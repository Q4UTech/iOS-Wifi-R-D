//
//  OfflineData.swift
//  VpnConnection
//
//  Created by gautam  on 05/06/23.
//

import Foundation

class OfflineData:Equatable{
    static func == (lhs: OfflineData, rhs: OfflineData) -> Bool {
        return lhs.ipName == rhs.ipName
    }
    
    var ipName:String
    var ipDetail:String
    init(ipName: String, ipDetail: String) {
        self.ipName = ipName
        self.ipDetail = ipDetail
    }
}
