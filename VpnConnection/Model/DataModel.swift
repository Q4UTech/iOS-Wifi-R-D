//
//  DataModel.swift
//  Q4U_VPNAPP
//
//  Created by Poornima on 20/10/22.
//

import Foundation
class DataModel: Codable {
    var vpnname = String()
    var vpncode = String()
    var username = String()
    var password = String()
    var vpn_flag = String()
    var file_location = String()
    var purchsedType = String()
    
    init(vpnname: String , vpncode: String , username: String , password: String , vpn_flag: String , file_location: String , purchsedType: String ) {
        self.vpnname = vpnname
        self.vpncode = vpncode
        self.username = username
        self.password = password
        self.vpn_flag = vpn_flag
        self.file_location = file_location
        self.purchsedType = purchsedType
    }
}
