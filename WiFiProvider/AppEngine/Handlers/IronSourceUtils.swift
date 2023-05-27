////
////  IronSourceExtension.swift
////  M24-PoleShare
////
////  Created by Poornima on 12/09/22.
////
//
//import Foundation
//import UIKit
//import ObjectiveC.runtime
//
//
//final class IronSourceBannerAd:NSObject {
//    
//     var kAPPKEY = String()
//    var ironSourceBannerView = UIView()
//    var viewConstarint = NSLayoutConstraint()
//    var viewController = UIViewController()
//    var bannerView: ISBannerView! = nil
//    static let shared = IronSourceBannerAd()
//    var ironSourceView : ISBannerView? = nil
//    var  bNSize : ISBannerSize?
//    
//    func showIronSourceBanner(from viewController: UIViewController, at position: BannerPosition = .bottom,banner_id:String,_ view:UIView,_ heightConstarint:NSLayoutConstraint) {
//        print("Iron Source")
//         kAPPKEY = banner_id
//        bannerPosition = position
//        IRONSOURCE_BANNERHEADER_ID = banner_id
//        loadIronSourceBannerAd(from: viewController,view,heightConstarint)
//    }
//    
//    
//    func loadIronSourceBannerAd(from viewController: UIViewController,_ view:UIView,_ heightConstarint:NSLayoutConstraint) {
//        self.viewController = viewController
//        ironSourceBannerView = view
//        viewConstarint = heightConstarint
//        let adverstisingID = IronSource.advertiserId()
//        IronSource.setUserId(adverstisingID)
//        IronSource.initWithAppKey(kAPPKEY)
//        IronSource.add(self)
//        IronSource.setBannerDelegate(self)
//        ISIntegrationHelper.validateIntegration()
//        
//        
//        if (ironSourceView != nil) {
//            IronSource.destroyBanner(ironSourceView!)
//            ironSourceView = nil
//            AdsListenerHelper.adsInstanceHelper.adsFailed(ironSourceBannerView,AdsEnum.ADS_IRON_SOURCE, "Iron Source Banner Ad is nil",self.viewController,viewConstarint)
//        }
//        
//        bNSize = ISBannerSize(description: "BANNER",width:Int(UIScreen.main.bounds.width) ,height:65)
//        IronSource.loadBanner(with: viewController, size: bNSize!)
//        
//        AdsListenerHelper.adsInstanceHelper.delegates = self
//        
//        if ironSourceView == nil{
//          
//            bNSize = ISBannerSize(description: "BANNER",width:Int(UIScreen.main.bounds.width) ,height:65)
//            IronSource.loadBanner(with: viewController, size: bNSize!)
//        }else{
//            if bNSize != nil{
//                ironSourceView?.removeFromSuperview()
//               
//            }else{
//                IronSource.destroyBanner(ironSourceView!)
//                bNSize = nil
//             
//            }
//        }
//       
//    }
//}
//
//
//extension IronSourceBannerAd : ISBannerDelegate,ISImpressionDataDelegate {
//    func impressionDataDidSucceed(_ impressionData: ISImpressionData!) {
//        print("Impression\(impressionData)")
//    }
//    
//    func bannerDidLoad(_ bannerView: ISBannerView!) {
//        print("Banner Ads Recieved")
//        self.ironSourceView = bannerView
//        bannerView.isHidden = false
//        ironSourceBannerView.isHidden = false
//        viewConstarint.constant = bannerView.frame.height
//        ironSourceBannerView.addSubview(bannerView)
//        if ironSourceBannerView.frame.height > 0{
//            
//            OnBannerAdsIdLoaded.adsInstanceHelper.bannerAdsLoaded()
//        }
//        AdsListenerHelper.adsInstanceHelper.adsLoad(adsView: bannerView,viewcontroller:self.viewController,viewConstarint)
//    }
//    func setupIronSourceSdk() {
//        
//    }
//    
//    func bannerDidFailToLoadWithError(_ error: Error!) {
//        
//        print("bannerDidFailToLoadWithError")
//        AdsListenerHelper.adsInstanceHelper.adsFailed(ironSourceBannerView,AdsEnum.ADS_IRON_SOURCE, error.localizedDescription,self.viewController,viewConstarint)
//    }
//    
//    func didClickBanner() {
//        print("didClickBanner")
//    }
//    
//    func bannerWillPresentScreen() {
//        print("bannerWillPresentScreen")
//    }
//    
//    func bannerDidDismissScreen() {
//        print("bannerDidDismissScreen")
//    }
//    
//    func bannerWillLeaveApplication() {
//        print("bannerWillLeaveApplication")
//    }
//    
//    
//}
//
//extension IronSourceBannerAd : AdsListenerProtocol{
//    func onAdsLoad(view: UIView, viewController: UIViewController, _ heightConstaint: NSLayoutConstraint) {
//       
//        if view.frame.height > 0{
//            
//            OnBannerAdsIdLoaded.adsInstanceHelper.bannerAdsLoaded()
//        }
//        
//    }
//    
//    func onAdsFailed(view: UIView, provider: AdsEnum, error: String, viewController: UIViewController, _ heightConstaint: NSLayoutConstraint) {
//        ironSourceBannerView.isHidden = true
//        viewConstarint.constant = 0
//        OnBannerAdsIdLoaded.adsInstanceHelper.bannerAdsFailed()
//    }
//    
//}
//
//
//class IronSourceInitFullAds : NSObject {
//    static let shared = IronSourceInitFullAds()
//    var cache = Bool()
//    var contoller = UIViewController()
//    var kAPPKEY = String()
//    
//    func loadIronSourceFullAds(from viewController: UIViewController,adsid:String,isFromCache:Bool) {
//        
//      
//        if  adsid != "" {
//            IRONSOURCE_FULLAD_ID = adsid
//            if IronSource.hasInterstitial(){
//                if isFromCache{
//                    FullAdsListener.adsInstanceHelper.fullAdsLoaded()
//                }
//            }else{
//                IronSource.setInterstitialDelegate(self)
//            }
//            cache = isFromCache
//            contoller = viewController
//            IronSource.initWithAppKey(kAPPKEY)
//            IronSource.loadInterstitial()
//            
//        }
//        else {
//            FullAdsListener.adsInstanceHelper.FullAdsFailed(AdsEnum.FULL_ADS_IRONSOURCE,"FullAds Id null",viewController)
//        }
//    }
//}
//
//
//extension IronSourceInitFullAds : ISInterstitialDelegate {
//    func interstitialDidLoad() {
//       
//        print("Load full ads")
//        FullAdsListener.adsInstanceHelper.fullAdsLoaded()
//        
//    }
//    
//    func interstitialDidFailToLoadWithError(_ error: Error!) {
//        print("fail full ads")
//        if cache{
//            FullAdsListener.adsInstanceHelper.FullAdsFailed(AdsEnum.FULL_ADS_IRONSOURCE,error.localizedDescription,contoller)
//        }
//    }
//    
//    func interstitialDidOpen() {
//        
//    }
//    
//    func interstitialDidClose() {
//        FullAdsListener.adsInstanceHelper.FullAdsClosed(contoller)
//    }
//    
//    func interstitialDidShow() {
//        
//    }
//    
//    func interstitialDidFailToShowWithError(_ error: Error!) {
//        if cache{
//            FullAdsListener.adsInstanceHelper.FullAdsFailed(AdsEnum.FULL_ADS_IRONSOURCE,error.localizedDescription,contoller)
//        }
//    }
//    
//    func didClickInterstitial() {
//        
//    }
//    
//    
//}
//
//
//class IronSourceFullAds : NSObject{
//    static let shared = IronSourceFullAds()
//    var contoller = UIViewController()
//    var isFromSplash = Bool()
//    func ironsourceshowFullAd(from viewController: UIViewController,adsid:String,isFromSplash:Bool) {
//        print("iron source full ads")
//        self.isFromSplash = isFromSplash
//        self.contoller = viewController
//        if  adsid != "" {
//            IRONSOURCE_FULLAD_ID = adsid
//            if IronSource.hasInterstitial(){
//                IronSource.showInterstitial(with: viewController)
//                IronSource.setInterstitialDelegate(self)
//                
//            }else{
//                if !self.isFromSplash{
//                    IronSourceInitFullAds.shared.loadIronSourceFullAds(from: contoller, adsid: IRONSOURCE_FULLAD_ID, isFromCache: false)
//                }
//            }
//            
//        }
//       
//    }
//    
//    
//}
//
//extension IronSourceFullAds : ISInterstitialDelegate {
//    func interstitialDidLoad() {
//       
//        print("Load full ads")
//        FullAdsListener.adsInstanceHelper.fullAdsLoaded()
//        
//    }
//    
//    func interstitialDidFailToLoadWithError(_ error: Error!) {
//        print("fail full ads")
//        
//            FullAdsListener.adsInstanceHelper.FullAdsFailed(AdsEnum.FULL_ADS_IRONSOURCE,error.localizedDescription,contoller)
//        
//    }
//    
//    func interstitialDidOpen() {
//        
//    }
//    
//    func interstitialDidClose() {
//        
//        if !self.isFromSplash{
//            IronSourceInitFullAds.shared.loadIronSourceFullAds(from: contoller, adsid: IRONSOURCE_FULLAD_ID, isFromCache: false)
//        }
//        
//        FullAdsListener.adsInstanceHelper.FullAdsClosed(contoller)
//       
//    }
//    
//    func interstitialDidShow() {
//        
//    }
//    
//    func interstitialDidFailToShowWithError(_ error: Error!) {
//   
//            FullAdsListener.adsInstanceHelper.FullAdsFailed(AdsEnum.FULL_ADS_IRONSOURCE,error.localizedDescription,contoller)
//        
//    }
//    
//    func didClickInterstitial() {
//        
//    }
//    
//    
//}
