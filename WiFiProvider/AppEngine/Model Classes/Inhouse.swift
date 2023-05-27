//
//  Inhouse.swift
//  App Engine
//
//  Created by Quantum_MAC_7 on 27/03/20.
//  Copyright © 2020 Pulkit Babbar. All rights reserved.
//

import Foundation

class Inhouse:NSObject{
    var type = String()
    var clicklink = String()
    var campType  = String()
    var html = String()
    var src = String()
    var fullAdssrc = String()
    var fullAdshtml = String()
    var fullAdscampType = String()
    var  fullAdsClickLink = String()
    func getInHouseData(dataArray : [String:Any]) -> Inhouse {
        let info = Inhouse()
        info.type = dataArray.validatedValue("type", expected: String() as AnyObject) as! String
        print("info.type\(info.type)")
        if info.type == "bottom_banner" || info.type == "top_banner"{
            info.clicklink = dataArray.validatedValue("clicklink", expected: String() as AnyObject) as! String
            info.campType = dataArray.validatedValue("campType", expected: String() as AnyObject) as! String
            info.html = dataArray.validatedValue("html", expected: String() as AnyObject) as! String
            info.src = dataArray.validatedValue("src", expected: String() as AnyObject) as! String
        }
        if info.type == "launch_full_ads" || info.type == "full_ads" {
            info.fullAdsClickLink = dataArray.validatedValue("clicklink", expected: String() as AnyObject) as! String
            info.fullAdscampType = dataArray.validatedValue("campType", expected: String() as AnyObject) as! String
            info.fullAdshtml = dataArray.validatedValue("html", expected: String() as AnyObject) as! String
            info.fullAdssrc = dataArray.validatedValue("src", expected: String() as AnyObject) as! String
        }
        return info
    }
    
}

