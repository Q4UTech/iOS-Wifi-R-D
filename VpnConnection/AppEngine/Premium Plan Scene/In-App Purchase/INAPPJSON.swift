//
//  INAPPJSON.swift
//  Q4U_VPNAPP
//
//  Created by Deepti Chawla on 29/04/21.
//

import Foundation


class INAPPJSON: Codable {
    var url: String
    var bundle: String
    var password : String
   

    init(url: String,bundle :String,password:String) {
        self.url = url
        self.bundle = bundle
        self.password = password
    }
    
    
  
}
