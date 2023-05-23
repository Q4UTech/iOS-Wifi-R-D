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
struct PasswordData: Codable {
    let status: String
    let message: String
    let routerList: [PasswordDataDetail]
}

struct PasswordDataDetail: Codable {
    let brand: String
    let type: String
    let username: String
    let passwrod: String
}

