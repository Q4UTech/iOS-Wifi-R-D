//
//  BannerRectangleStatus.swift
//  Q4U-PhoneSwtich
//
//  Created by Deepti Chawla on 19/07/22.
//

import Foundation
import Foundation




protocol BannerRectangleStatusProtocol: class {
   
    func  loadandshowBannerRectangleAds(status:Bool)
  
}

class BannerRectangleStatus: NSObject{
    var onBannerRectangleAdsLoadeddelegates: BannerRectangleStatusProtocol?
    
    class var adsInstanceHelper: BannerRectangleStatus {
        struct Static {
            static let instance = BannerRectangleStatus()
        }
        return Static.instance
    }
    
    func bannerRectangleAdsLoaded(status:Bool){
        onBannerRectangleAdsLoadeddelegates?.loadandshowBannerRectangleAds(status:status )
    }
    
    
}
