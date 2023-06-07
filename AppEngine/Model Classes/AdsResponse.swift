//
//  AdsResponse.swift
//  App Engine
//
//  Created by Quantum_MAC_7 on 17/03/20.
//  Copyright © 2020 Pulkit Babbar. All rights reserved.
//

import UIKit

class AdsResponse: NSObject {
    
  
    var type = String()
    var provider_id = String()
    var startdate = String()
    var adsprovider = [AdsProvider]()
    var clicklink  = String()
    var ad_id = String()
    var navigation = String()
    var call_native = String()
    var rateapptext = String()
    var rateurl = String()
    var email = String()
    var updatetype = String()
    var appurl = String()
    var promptText = String()
    var version = String()
    var moreurl = String()
    var etc1 = String()
    var etc2 = String()
    var etc3 = String()
    var etc4 = String()
    var etc5 = String()
    var src = String()
    var shareurl  = String()
    var sharetext = String()
    var admob_banner_id = String()
    var admob_bannerlarge_id = String()
    var admob_bannerrect_id = String()
    var admob_full_id = String()
    var admob_native_medium_id = String()
    var admob_native_large_id = String()
    var ourapp = String()
    var websitelink = String()
    var ppolicy = String()
    var tandc = String()
    var facebook = String()
    var instagram = String()
    var twitter = String()
    var bgcolor = String()
    var textcolor = String()
    var descript = String()
    var headertext = String()
    var rate = String()
    var exit  = String()
    var full = String()
    var removeads = String()
      var counts =  [NonRepeatCount]()
    var launch_rate = String()
    var launch_exit = String()
    var launch_full = String()
    var launch_removeads = String()
    var launchCount = [LaunchNonRepeatCount]()
    var show_ad_on_exit_prompt = String()
    var show_native_ad_on_exit_prompt = String()
    var public_key = String()
    var inAppPurchase = [Billing]()
    var faq = String()
    
    func getAdsResponseData(dataArray : [[String:Any]]) -> [AdsResponse] {
        var tempArray = [AdsResponse]()
        
        for i in 0..<dataArray.count {
            let info = AdsResponse()
            info.type = dataArray[i]["type"] as! String
            info.clicklink =  notnull("clicklink",dataArray[i])
            info.startdate  = notnull("start_date",dataArray[i])
            info.navigation =  notnull("nevigation",dataArray[i])
            info.call_native =  notnull("call_native",dataArray[i])
            info.rateapptext =  notnull("rateapptext",dataArray[i])
            info.rateurl =  notnull("rateurl",dataArray[i])
            info.email  = notnull("email",dataArray[i])
            info.updatetype =  notnull("updatetype",dataArray[i])
            info.appurl =  notnull("appurl",dataArray[i])
            info.promptText =  notnull("prompttext",dataArray[i])
            info.version =  notnull("version",dataArray[i])
            info.moreurl =  notnull("moreurl",dataArray[i])
            info.src =  notnull("src",dataArray[i])
            info.show_native_ad_on_exit_prompt = notnull("show_ad_on_exit_prompt", dataArray[i])
            info.show_ad_on_exit_prompt = notnull("show_native_ad_on_exit_prompt", dataArray[i])
            info.ad_id = notnull("ad_id", dataArray[i])
            info.provider_id = notnull("provider_id",dataArray[i])
            info.bgcolor = notnull("bgcolor", dataArray[i])
            info.headertext = notnull("headertext",dataArray[i])
            info.textcolor = notnull("textcolor", dataArray[i])
            info.etc1 = notnull("etc1", dataArray[i])
            info.etc2 = notnull("etc2", dataArray[i])
            info.etc3 = notnull("etc3", dataArray[i])
            info.etc4 = notnull("etc4", dataArray[i])
            info.etc5 = notnull("etc5", dataArray[i])
            info.sharetext = notnull("sharetext", dataArray[i])
            info.shareurl = notnull("shareurl", dataArray[i])
            info.admob_native_medium_id = notnull("admob_native_medium_id", dataArray[i])
            info.admob_banner_id = notnull("admob_banner_id", dataArray[i])
            info.admob_full_id = notnull("admob_full_id", dataArray[i])
            info.admob_native_large_id = notnull("admob_native_large_id", dataArray[i])
            info.admob_bannerlarge_id = notnull("admob_bannerlarge_id", dataArray[i])
            info.admob_bannerrect_id = notnull("admob_bannerrect_id", dataArray[i])
            info.descript = notnull("description", dataArray[i])
            info.ourapp = notnull("ourapp", dataArray[i])
            info.websitelink = notnull("websitelink", dataArray[i])
            info.ppolicy = notnull("ppolicy", dataArray[i])
            info.tandc = notnull("tandc", dataArray[i])
            info.facebook = notnull("facebook", dataArray[i])
            info.instagram = notnull("instagram", dataArray[i])
            info.twitter = notnull("twitter", dataArray[i])
            info.rate = notnull("rate",  dataArray[i])
            info.exit = notnull("exit", dataArray[i])
            info.full = notnull("full", dataArray[i])
            info.removeads = notnull("removeads", dataArray[i])
            info.launch_rate = notnull("launch_rate", dataArray[i])
            info.launch_exit = notnull("launch_exit",  dataArray[i])
            info.launch_full = notnull("launch_full", dataArray[i])
            info.launch_removeads = notnull("launch_removeads", dataArray[i])
            info.public_key = notnull("app_id", dataArray[i])
            
            if let providers = dataArray[i]["providers"] as? [[String:Any]] {
             let obj = AdsProvider()
            info.adsprovider = obj.getAdsProviderData(dataArray: providers)
 
            }
            
           if let launchnonrepeat = dataArray[i]["launch_counts"] as? [[String:Any]] {
                       let obj = LaunchNonRepeatCount()
                      info.launchCount = obj.getLaunchNonRepeatData(dataArray: launchnonrepeat)
              
                      }
            if let nonrepeat = dataArray[i]["counts"] as? [[String:Any]] {
                                let obj = NonRepeatCount()
                               info.counts = obj.getNonRepeatData(dataArray: nonrepeat)
                    
             }
            
             if let inAppPuchaseArray = dataArray[i]["billing"] as? [[String:Any]] {
                        let obj = Billing()
                info.inAppPurchase = obj.getBillingData(dataArray: inAppPuchaseArray)
                
                       }
            tempArray.append(info)
        }
        
        return tempArray
        
    }
    
    
}


func notnull(_ key:String,_ dataArray:[String:Any]) -> String {
    if  dataArray[key] as? String  != nil {
        return dataArray[key] as! String
    }
    else{
        return ""
    }
}






