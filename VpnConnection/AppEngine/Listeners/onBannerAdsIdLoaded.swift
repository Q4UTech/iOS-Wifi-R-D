//
//  onBannerAdsIdLoaded.swift
//  Q4U-PhoneSwtich
//
//  Created by Deepti Chawla on 27/04/22.
//

import Foundation

//class  OnBannerAdsIdLoaded {
//
//    func  onBannerFailToLoad();
//    func  loadandshowBannerAds();
//
//}


protocol OnBannerAdsIdLoadedProtocol: class {
    func  onBannerFailToLoad()
    func  loadandshowBannerAds()
  
}

class OnBannerAdsIdLoaded: NSObject{
    var onBannerAdsLoadeddelegates: OnBannerAdsIdLoadedProtocol?
    
    class var adsInstanceHelper: OnBannerAdsIdLoaded {
        struct Static {
            static let instance = OnBannerAdsIdLoaded()
        }
        return Static.instance
    }
    
    func bannerAdsLoaded(){
        onBannerAdsLoadeddelegates?.loadandshowBannerAds()
    }
    
    func bannerAdsFailed() {
        onBannerAdsLoadeddelegates?.onBannerFailToLoad()
    }
    
}
