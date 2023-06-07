//
//  UpdateResponse.swift
//  App Engine
//
//  Created by Quantum_MAC_7 on 30/03/20.
//  Copyright © 2020 Pulkit Babbar. All rights reserved.
//

import Foundation


class UpdateResponse: NSObject {

       var updateResponse = String()
     
    
    
    
//    func getAdsProviderData(dataArray : [[String:Any]]) -> [AdsProvider] {
//
//        var tempArray = [AdsProvider]()
//             for i in 0..<dataArray.count {
//                    let info = AdsProvider()
//
//                    info.provider_id =  notnull("provider_id",dataArray[i])
//
//                    info.ad_id  = notnull("ad_id",dataArray[i])
//                    info.clicklink =  notnull("clicklink",dataArray[i])
//                    info.src =  notnull("src",dataArray[i])
//                     tempArray.append(info)
//                    }
//                return tempArray
//
//            }
            
    func setresponse(response:String){
        
        updateResponse = response
    }
    
    
}
