//
//  AdsProvider.swift
//  App Engine
//
//  Created by Quantum_MAC_7 on 17/03/20.
//  Copyright © 2020 Pulkit Babbar. All rights reserved.
//

import UIKit

class AdsProvider: NSObject {

       var provider_id = String()
       var ad_id = String()
       var clicklink  = String()
       var src = String()
    

    func getAdsProviderData(dataArray : [[String:Any]]) -> [AdsProvider] {

        var tempArray = [AdsProvider]()
             for i in 0..<dataArray.count {
                    let info = AdsProvider()
                    info.provider_id =  notnull("provider_id",dataArray[i])
                    info.ad_id  = notnull("ad_id",dataArray[i])
                    info.clicklink =  notnull("clicklink",dataArray[i])
                    info.src =  notnull("src",dataArray[i])
               
                    tempArray.append(info)
                    }
                return tempArray
                
            }

}
