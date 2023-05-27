//
//  AdMobMediation.swift
//  Q4U-PhoneSwtich
//
//  Created by Deepti Chawla on 14/07/22.
//

import Foundation
import GoogleMobileAds


class AdMobMediation {
    private static let INSTANCE = AdMobMediation()
    
    static func getInstance() -> AdMobMediation {
        return INSTANCE
    }
    
    var  mTag = "AdMobMediation"

    
    public func adMobMediation(){
        let ads = GADMobileAds.sharedInstance()
        ads.start { status in
            // Optional: Log each adapter's initialization latency.
            let adapterStatuses = status.adapterStatusesByClassName
            for adapter in adapterStatuses {
                let adapterStatus = adapter.value
              
            }
            
           
        }
        
        ads.requestConfiguration.testDeviceIdentifiers =
                [iPhone7 ,iPhone8,iPhoneXR_DC,iPhone7_PB,iPhone7_OFFICE_2]
    }
    
    
    
    public func  admob_GetBannerMediation(from viewController: UIViewController,banner_id:String,_ view:UIView,_ heightConstarint:NSLayoutConstraint){

        ADMobAdaptiveBannerAd.shared.showAdMobAdaptiveBanner(from: viewController, banner_id:banner_id,view,heightConstarint)
     
        
    }
    
}
