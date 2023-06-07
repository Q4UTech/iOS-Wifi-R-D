//
//  AdsHelper.swift
//  App Engine
//
//  Created by Quantum_MAC_7 on 23/03/20.
//  Copyright © 2020 Pulkit Babbar. All rights reserved.
//

import Foundation
import AdSupport
import GoogleMobileAds


let fbIntertitialFullAdID = FB_FULLAD_ID

var TYPE_BANNER_HEADER = "top_banner"
var TYPE_BANNER_FOOTER = "bottom_banner"
var  adMobSplashCache = false
var fbSplashCache = false
var ironSourceCache = false
var appLovinSplashCache = false
class AdsHelper{
    static func createRequest() -> GADRequest {
        let request = GADRequest()
        return request
    }
}



func getNewbannerHeader(_ position:Int,_ self:UIViewController,_ view:UIView,_ heightConstarint:NSLayoutConstraint){
    DispatchQueue.global(qos: .background).async {
        DispatchQueue.main.async {
    if (position >= TOP_BANNER_providers.count) {
        return
    }
  
    let provider = TOP_BANNER_providers[position]
    
 
    switch TOP_BANNER_providers[position].provider_id {
    case Provider_Admob_Banner:
       
        ADMobBannerAd.shared.showAdMobBanner(from: self, banner_id:provider.ad_id,view,heightConstarint)
    
        break
        
    case Provider_Admob_Mediation_Banner:
     
        ADMobBannerAd.shared.showAdMobBanner(from: self, banner_id:provider.ad_id,view,heightConstarint)
        break
    case Provider_Facebook_Banner:
        FBBannerAd.shared.showFBBanner(from: self, banner_id: provider.ad_id, view, heightConstarint)
        break
    case Provider_Inhouse_Banner:
      
        if ServiceHelper.sharedInstanceHelper.isConnectedToNetwork(){
            InHouseAds.shared.getInhouseBannerAds(from: self ,type: TYPE_BANNER_HEADER,view,heightConstarint)
        }
        break
    case Provider_IronSource:
//        IronSourceBannerAd.shared.showIronSourceBanner(from: self, banner_id:provider.ad_id,view,heightConstarint)
        break
    case Provider_AppLovin:

        AppLovinBannerAd.shared.getAppLovinBanner(from: self, banner_id:provider.ad_id,view,heightConstarint)
        break
        
    default:
        ADMobBannerAd.shared.showAdMobBanner(from: self,banner_id:provider.ad_id, view,heightConstarint)
        
    }
        }
    }
}

func getNewbannerFooter(_ position:Int,_ self:UIViewController,_ view:UIView,_ heightConstarint:NSLayoutConstraint){
    DispatchQueue.global(qos: .background).async {
        DispatchQueue.main.async {
            print("BOTTOM_BANNER_providers\(BOTTOM_BANNER_providers.count)")
    if (position >= BOTTOM_BANNER_providers.count) {
        return
    }
    
            
    let provider = BOTTOM_BANNER_providers[position]
            print("BOTTOM_BANNER_providers\(provider.provider_id)")
    switch BOTTOM_BANNER_providers[position].provider_id {
    case Provider_Admob_Banner:
        
       
        ADMobAdaptiveBannerAd.shared.showAdMobAdaptiveBanner(from: self, banner_id:provider.ad_id,view,heightConstarint)
        break
    case Provider_Admob_Mediation_Banner:
     
        AdMobMediation.getInstance().admob_GetBannerMediation(from: self, banner_id: provider.ad_id, view, heightConstarint)
        break
    case Provider_Facebook_Banner:
       
        FBBannerAd.shared.showFBBanner(from: self, banner_id: provider.ad_id, view, heightConstarint)
        break
    case Provider_Inhouse_Banner:
        //  SwiftyAdaptiveAd.shared.showAdaptiveAdMobBanner(from: self, banner_id:provider.ad_id)
        if ServiceHelper.sharedInstanceHelper.isConnectedToNetwork(){
            InHouseAds.shared.getInhouseBannerAds(from: self ,type: TYPE_BANNER_FOOTER,view,heightConstarint)
        }
        break
    case Provider_IronSource:
//        IronSourceBannerAd.shared.showIronSourceBanner(from: self, banner_id:provider.ad_id,view,heightConstarint)
        break
    case Provider_AppLovin:
        AppLovinBannerAd.shared.getAppLovinBanner(from: self, banner_id:provider.ad_id,view,heightConstarint)
        break
    default:
       ADMobAdaptiveBannerAd.shared.showAdMobAdaptiveBanner(from: self, banner_id:provider.ad_id,view,heightConstarint)

    }}
    }
    
}



func getbannerRectangle(_ position:Int,_ self:UIViewController,_ view:UIView,_ heightConstarint:NSLayoutConstraint){
    DispatchQueue.global(qos: .background).async {
        DispatchQueue.main.async {
            print("BOTTOM_BANNER_providers\(RECTANGLE_BANNER_providers.count)")
    if (position >= RECTANGLE_BANNER_providers.count) {
        
//        let moreAppView = UINib(nibName: "MoreAppView", bundle: .main).instantiate(withOwner: nil, options: nil).first as! UIView
//
//        view.addSubview(moreAppView)
        return
    }
    
            
    let provider = RECTANGLE_BANNER_providers[position]
    
   print("BOTTOM_BANNER_providers[position].provider_id\(RECTANGLE_BANNER_providers[position].provider_id)")
    switch RECTANGLE_BANNER_providers[position].provider_id {
    case Provider_Admob_Banner_Rectangle:
        AdMobBannerRectangleAd.shared.showAdMobBannerRectangle(from: self, banner_id:provider.ad_id,view,heightConstarint)
        break
    case Provider_Admob_Mediation_Banner:
        AdMobBannerRectangleAd.shared.showAdMobBannerRectangle(from: self, banner_id:provider.ad_id,view,heightConstarint)
        break
    case Provider_Facebook_Banner_Rectangle:
        FbBannerRectangleAd.shared.showFBBannerRectangle(from: self, banner_id: provider.ad_id, view, heightConstarint)
      
        break
    case Provider_Inhouse_Banner:
        //  SwiftyAdaptiveAd.shared.showAdaptiveAdMobBanner(from: self, banner_id:provider.ad_id)
        if ServiceHelper.sharedInstanceHelper.isConnectedToNetwork(){
            InHouseAds.shared.getInhouseBannerAds(from: self ,type: TYPE_BANNER_FOOTER,view,heightConstarint)
        }
        break
    case  Provider_Applovin_Banner_Rectangle:
        //AdMobBannerRectangleAd.shared.showAdMobBannerRectangle(from: self, banner_id:provider.ad_id,view,heightConstarint)
        AppLovinBannerRectangleAd.shared.showAppLovinBannerRectangle(from: self, banner_id: provider.ad_id, view, heightConstarint)
        break
    default:
        AdMobBannerRectangleAd.shared.showAdMobBannerRectangle(from: self, banner_id:provider.ad_id,view,heightConstarint)
    }}
    }
    
}

func loadFullAds(_ position:Int,_ self:UIViewController){
    
   
    DispatchQueue.global(qos: .background).async {
        DispatchQueue.main.async {
            print("positionnn\(position)\(FULL_ADS_providers.count)")
    if (position >= FULL_ADS_providers.count) {
        return
    }
   
    let provider = FULL_ADS_providers[position]
    print("provider.provider_iddd\(provider.provider_id ) ")
   
    switch provider.provider_id {
    case Provider_Admob_FullAds:
        AdsMobFullAds.shared.showFullAd(from: self,adsid: provider.ad_id)
        break
    case provider_Admob_Mediation_Full_Ads:
        AdsMobFullAds.shared.showFullAd(from: self,adsid: provider.ad_id)
        
        break
    case Provider_Facebook_Full_Page_Ads:
        
        FbFullAds.shared.fbshowFullAd(from: self, adsid: provider.ad_id)
        break
    case Provider_Inhouse_FullAds:
        if ServiceHelper.sharedInstanceHelper.isConnectedToNetwork(){
            FULL_ADS_src = provider.src;
            FULL_ADS_clicklink = provider.clicklink;
            InHouseFullAds.shared.InhouseshowFullAds(viewController: self, type: IH_FULL, src:FULL_ADS_src , link:FULL_ADS_clicklink)
        }
              
        break
    case Provider_IronSource_FullAds:
        

//        IronSourceFullAds.shared.ironsourceshowFullAd(from: self,adsid: provider.ad_id, isFromSplash: false)
        break
    case Provider_AppLovin_FullAds:
       AppLovinFullAds.shared.appLovinshowFullAd(from: self, adsid: provider.ad_id, isFromSplash: false)
   
       
        break
    default:
        AdsMobFullAds.shared.showFullAd(from: self,adsid: provider.ad_id)
        
    }}
    }
    
}


func loadForceFullAds(_ position:Int,_ self:UIViewController){
    DispatchQueue.global(qos: .background).async {
        DispatchQueue.main.async {
    if (position >= FULL_ADS_providers.count) {
        return
    }
   
    let provider = FULL_ADS_providers[position]
    
   
    switch provider.provider_id {
    case Provider_Admob_FullAds:
        AdsMobFullAds.shared.showFullAd(from: self,adsid: provider.ad_id)
        break
    case provider_Admob_Mediation_Full_Ads:
        AdsMobFullAds.shared.showFullAd(from: self,adsid: provider.ad_id)
        
        break
    case Provider_Facebook_Full_Page_Ads:
        FbFullAds.shared.fbshowFullAd(from: self, adsid: provider.ad_id)
        break
    case Provider_Inhouse_FullAds:
        if ServiceHelper.sharedInstanceHelper.isConnectedToNetwork(){
            
                   FULL_ADS_src = provider.src
                    FULL_ADS_clicklink = provider.clicklink
                   InHouseFullAds.shared.InhouseshowFullAds(viewController: self, type: IH_FULL, src:FULL_ADS_src , link:FULL_ADS_clicklink )
                }
        break
    case Provider_IronSource_FullAds:
//        IronSourceInitFullAds.shared.loadIronSourceFullAds(from: self, adsid: provider.ad_id,isFromCache: false)
//        IronSourceFullAds.shared.ironsourceshowFullAd(from: self, adsid: provider.ad_id,isFromSplash: true)
        break
    case Provider_AppLovin_FullAds:
        print("appLovinloadforce\(appLovinSplashCache)")
       // IronSourceInitFullAds.shared.loadIronSourceFullAds(from: self, adsid: provider.ad_id,isFromCache: false)
       
        AppLovinFullAds.shared.appLovinshowFullAd(from: self, adsid: provider.ad_id, isFromSplash: false)
        break
        
    default:
        AdsMobFullAds.shared.showFullAd(from: self,adsid: provider.ad_id)

    }
        }}
}

func getNewLaunchCacheFullPageAd(_ position:Int,_ self:UIViewController){
    
    print("position\(position) \(LAUNCH_FULL_ADS_providers.count)")
    DispatchQueue.global(qos: .background).async {
        DispatchQueue.main.async {
            if (position >= LAUNCH_FULL_ADS_providers.count) {
                LaunchFullCallBackListener.adsInstanceHelper.onFullAdsReturn(status:true)
                return
            }

            let provider = LAUNCH_FULL_ADS_providers[position]
            print("provider.provider_id\(provider.provider_id)")

            switch provider.provider_id {
            case Provider_Admob_FullAds:
                adMobSplashCache = true
                
                AdsMobInitFullAds.shared.createInitFullAd(from: self, adsid: provider.ad_id, isFromCache: true)
                break
            case provider_Admob_Mediation_Full_Ads:
                adMobSplashCache = true
                
                AdsMobInitFullAds.shared.createInitFullAd(from: self, adsid: provider.ad_id, isFromCache: true)
                break
                
            case Provider_Facebook_Full_Page_Ads:
                fbSplashCache = true
                     
                FBInitFullAds.shared.createInitFbFullAd(from: self, adsid: provider.ad_id, isFromCache: true)
                break
            case Provider_Inhouse_FullAds:
                  
                if ServiceHelper.sharedInstanceHelper.isConnectedToNetwork(){
                    FullAdsListener.adsInstanceHelper.fullAdsLoaded()
                 }
                else{
                    FullAdsListener.adsInstanceHelper.FullAdsFailed(AdsEnum.FULL_ADS_INHOUSE, "Internet issue", self)
                }
                break
                
            case Provider_IronSource_FullAds:
                ironSourceCache = true
                
//                IronSourceInitFullAds.shared.loadIronSourceFullAds(from: self, adsid: provider.ad_id, isFromCache: true)
               
                break
            case Provider_AppLovin_FullAds:
                print("appLovinNewLaunch\(appLovinSplashCache)")
                appLovinSplashCache = true
                AppLovinInitFullAds.shared.loadAppLovinFullAds(from: self, adsid: provider.ad_id, isFromCache: true)
               
                break
            default:
                AdsMobInitFullAds.shared.createInitFullAd(from: self, adsid: provider.ad_id, isFromCache: true)
                
            }
        }
    }
}

func getNewNavCacheFullPageAd(_ self:UIViewController,_ position:Int) {
    DispatchQueue.global(qos: .background).async {
        DispatchQueue.main.async {
            
    print("CheckCondition")
    if (position >= FULL_ADS_providers.count) {
        LaunchFullCallBackListener.adsInstanceHelper.onFullAdsReturn(status:true)
        return
    }
    let provider = FULL_ADS_providers[position]
    
   
    switch (provider.provider_id) {
    case Provider_Admob_FullAds:
        if (!adMobSplashCache) {
            adMobSplashCache = true
            AdsMobInitFullAds.shared.createInitFullAd(from: self, adsid: provider.ad_id, isFromCache: true)
        }
        
        break
        
    case provider_Admob_Mediation_Full_Ads:
        if (!adMobSplashCache) {
            adMobSplashCache = true
            AdsMobInitFullAds.shared.createInitFullAd(from: self, adsid: provider.ad_id, isFromCache: true)
        }
    break
    case Provider_Facebook_Full_Page_Ads:
        if (!fbSplashCache){
            fbSplashCache = true
            FBInitFullAds.shared.createInitFbFullAd(from: self, adsid: provider.ad_id, isFromCache: true)
            
        }
        break
        
    case Provider_Inhouse_FullAds:
        
         if ServiceHelper.sharedInstanceHelper.isConnectedToNetwork(){
                  FullAdsListener.adsInstanceHelper.fullAdsLoaded()
              }
              else{
                  FullAdsListener.adsInstanceHelper.FullAdsFailed(AdsEnum.FULL_ADS_INHOUSE, "Internet issue", self)
              }
        break;
    case Provider_IronSource_FullAds:
        if (!ironSourceCache){
            ironSourceCache = true
//            IronSourceInitFullAds.shared.loadIronSourceFullAds(from: self, adsid: provider.ad_id, isFromCache: true)
            
        }
        break;
    case Provider_AppLovin_FullAds:
        print("appLovinSplashCache\(appLovinSplashCache)")
        if (!appLovinSplashCache) {
            appLovinSplashCache = true
            print("appLovinSplashCacheeee\(appLovinSplashCache)")
        AppLovinInitFullAds.shared.loadAppLovinFullAds(from: self, adsid: provider.ad_id, isFromCache: true)
        }
        break;
    default:
        AdsMobInitFullAds.shared.createInitFullAd(from: self, adsid: provider.ad_id, isFromCache: true)
      
        break;
    }
        }
    }
}


func showFullAdOnLaunch(_ self:UIViewController,_ position:Int) {
    DispatchQueue.global(qos: .background).async {
        DispatchQueue.main.async {
     print("CheckCondition1\(position) \(LAUNCH_FULL_ADS_providers.count)")
            
            if (position >= LAUNCH_FULL_ADS_providers.count) {
                LaunchFullCallBackListener.adsInstanceHelper.onFullAdsReturn(status: true)
                return
            }
            
    let providers = LAUNCH_FULL_ADS_providers[position]
   
    if (getDaysDiff() >= getStringtoInt(data: LAUNCH_FULL_ADS_start_date)) {
        switch (providers.provider_id) {
        case Provider_Admob_FullAds:
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { timer in
                AdsMobFullAds.shared.showFullAd(from: self,adsid: providers.ad_id)
            })
          
          break
            
            
        case provider_Admob_Mediation_Full_Ads:
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { timer in
                AdsMobFullAds.shared.showFullAd(from: self,adsid: providers.ad_id)
            })
            
            break
            
        case Provider_Facebook_Full_Page_Ads:
           
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { timer in
                FbFullAds.shared.fbshowFullAd(from: self, adsid: providers.ad_id)
            })
          
            break
            
        case Provider_Inhouse_FullAds:

               if ServiceHelper.sharedInstanceHelper.isConnectedToNetwork(){
               LAUNCH_FULL_ADS_src = providers.src;
               LAUNCH_FULL_ADS_clicklink = providers.clicklink;
                
                InHouseFullAds.shared.InhouseshowFullAds(viewController: self, type: IH_LAUNCH_FULL, src:LAUNCH_FULL_ADS_src , link: LAUNCH_FULL_ADS_clicklink)
               }else{
                 FullAdsListener.adsInstanceHelper.FullAdsFailed(AdsEnum.FULL_ADS_INHOUSE,"Internet issue", self)
            }
        
            break
        case Provider_IronSource_FullAds:
            
//            IronSourceFullAds.shared.ironsourceshowFullAd(from: self,adsid: providers.ad_id, isFromSplash: true)
            break
        case Provider_AppLovin_FullAds:
            print("appLovinshowFullAdOnLaunch\(appLovinSplashCache)")
           
                AppLovinFullAds.shared.appLovinshowFullAd(from: self, adsid: providers.ad_id, isFromSplash: true)
        break
            
        default:
            AdsMobFullAds.shared.showFullAd(from: self,adsid: providers.ad_id)
            break
        }
        
    }else{
        FullAdsListener.adsInstanceHelper.FullAdsClosed(self)
     
    }}}
}


func getNewNativeLarge(_ self:UIViewController,_ position:Int,_ view:UIView,_ heightConstarint:NSLayoutConstraint) {
    DispatchQueue.global(qos: .background).async {
        DispatchQueue.main.async {
    if (position >= NATIVE_LARGE_providers.count) {
        return;
    }
    let providers = NATIVE_LARGE_providers[position];
  

    switch (providers.provider_id) {
        case Provider_Admob_Native_Large:
            // new AdmobNativeAdvanced().getNativeAdvancedAds(context, providers.ad_id, true, listener);
            AdmobNativeLargeAd.shared.getAdMobNativeAdView(from: self, nativeAdPlaceholder: view,adsid: providers.ad_id,heightConstarint)

            break;
        
        
        case Provider_Facebook_Native_Large:
            FBNativeLargeAds.shared.getFbNativeLargeAdView(from: self, nativeAdPlaceholder: view,adsid: providers.ad_id,heightConstarint)
          //  FbAdsProvider.getFbObject().getNativeAds(context, true, providers.ad_id, listener);

            break;
        case Provider_Inhouse_Large:
           // new InHouseAds().showNativeLarge(context, InHouseAds.TYPE_NATIVE_LARGE, listener);
            if ServiceHelper.sharedInstanceHelper.isConnectedToNetwork(){
             
                InHouseNativeLargeAds.shared.getNativeLargeAds(from: self, view: view,heightConstarint)
                              }
            break;
        
        default:
         AdmobNativeLargeAd.shared.getAdMobNativeAdView(from: self, nativeAdPlaceholder: view,adsid: providers.ad_id,heightConstarint)

           
            break;
    }}}

}


func getNewNativeMedium(_ self:UIViewController,_ position:Int,_ view:UIView,_ heightConstarint: NSLayoutConstraint) {
    DispatchQueue.global(qos: .background).async {
        DispatchQueue.main.async {
       if (position >= NATIVE_MEDIUM_providers.count) {
           
           return
       }
      let providers = NATIVE_MEDIUM_providers[position]
      

       switch (providers.provider_id) {
           case Provider_Admob_Native_Medium:

            AdmobNativeMediumAd.shared.getAdMobNativeMediumAdView(from: self, nativeAdPlaceholder: view, adsid: providers.ad_id,heightConstarint)
               break;
           case Provider_Facebook_Native_Medium:
            FBNativeMediumAds.shared.getFbNativeMediumAdView(from: self, nativeAdPlaceholder: view, adsid: providers.ad_id,heightConstarint)
               break;
           case Provider_Inhouse_Medium:
            if ServiceHelper.sharedInstanceHelper.isConnectedToNetwork(){
            
               InHouseNativeMediumAds.shared.getNativeMediumAds(from: self, view: view,heightConstarint)
                             }
               break;
       case Provider_AppLovin_Medium:
           AppLovinNativeMediumAd.shared.getAppLovinNativeMediumAdView(from: self, nativeAdPlaceholder: view, adsid: providers.ad_id, heightConstarint)
           break
           default:
            

               break;
       }}}
   }

