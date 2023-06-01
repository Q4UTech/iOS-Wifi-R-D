//
//  PasswordData.swift
//  WiFiProvider
//
//  Created by gautam  on 23/05/23.
//

import Foundation

//class PasswordData:Decodable{
//    var status:String?
//    var message:String?
//    var routerlist:[PasswordDataDetail]?
//
//}
struct PasswordData:Codable {
    let status: String
    let message: String
    let routerlist: [PasswordDataDetail]
}

struct PasswordDataDetail:Codable {
    var brand = String()
    var type = String()
    var username = String()
    var passwrod = String()
    
    init(brand: String , type: String , username: String, passwrod: String) {
        self.brand = brand
        self.type = type
        self.username = username
        self.passwrod = passwrod
    }
    

}

