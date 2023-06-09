//
//  AHandler.swift
//  App Engine
//
//  Created by Quantum_MAC_7 on 23/03/20.
//  Copyright © 2020 Pulkit Babbar. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds
import FBAudienceNetwork

var adMobinterstitial: GADInterstitialAd?
var defaultView = UIView()
var timer = Timer()
var crossButton  =  UIButton()

class AdsMobInitFullAds : NSObject {
    static let shared = AdsMobInitFullAds()
    var cache = Bool()
    var contoller = UIViewController()
    
    func createInitFullAd(from viewController: UIViewController,adsid:String,isFromCache:Bool) {
        
        ADMOB_FULLAD_ID = adsid
        if  adsid != "" {
            cache = isFromCache
            contoller = viewController
            
            do{
                let request = GADRequest()
                GADInterstitialAd.load(withAdUnitID:adsid,
                                       request: request,
                                       completionHandler: { [self] ad, error in
                    if let error = error {
                        print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                        return
                    }
                    adMobinterstitial = ad
                    adMobinterstitial!.fullScreenContentDelegate = self
                    
                }
                )
            }
            
        }
        
        else {
            FullAdsListener.adsInstanceHelper.FullAdsFailed(AdsEnum.FULL_ADS_ADMOB,"FullAds Id null",viewController)
        }
    }
}


extension AdsMobInitFullAds : GADFullScreenContentDelegate {
    func interstitial(ad: GADInterstitialAd!, didFailToReceiveAdWithError error: Error!) {
        print("\(#function): \(error.localizedDescription)")
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitialAd) {
        FullAdsListener.adsInstanceHelper.FullAdsClosed(contoller)
    }
    
    func interstitialWillPresentScreen(ad: GADInterstitialAd!) {
        print("interstitialWillPresentScreen")
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitialAd) {
        print("interstitialDidReceiveAdcache\(cache)")
        if(cache){
            print("cache")
            FullAdsListener.adsInstanceHelper.fullAdsLoaded()
        }
        
    }
    
    /// Tells the delegate an ad request failed.
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        if cache{
            FullAdsListener.adsInstanceHelper.FullAdsFailed(AdsEnum.FULL_ADS_ADMOB,error.localizedDescription,contoller)
        }
    }
    
    /// Tells the delegate that an interstitial will be presented.
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        FullAdsListener.adsInstanceHelper.FullAdsClosed(contoller)
        createInitFullAd(from: contoller,adsid: ADMOB_FULLAD_ID,isFromCache: false)
    }
    
    /// Tells the delegate the interstitial had been animated off the screen.
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitialAd) {
        print("interstitialWillLeaveApplication")
    }
    
}



class AdsMobFullAds : NSObject{
    
    static let shared = AdsMobFullAds()
    
    var contoller = UIViewController()
    
    func showFullAd(from viewController: UIViewController,adsid:String) {
        print("AdMobAdsId\(adsid)")
        ADMOB_FULLAD_ID = adsid
        
        if adsid != ""{
            contoller = viewController
            if  adMobinterstitial != nil {
                
                if adMobinterstitial != nil {
                    print("Present")
                    adMobinterstitial?.present(fromRootViewController: viewController)
                    FullAdsListener.adsInstanceHelper.fullAdsLoaded()
                }
                else{
                    AdsMobInitFullAds.shared.createInitFullAd(from: viewController,adsid: ADMOB_FULLAD_ID,isFromCache: false)
                    FullAdsListener.adsInstanceHelper.FullAdsFailed(AdsEnum.FULL_ADS_ADMOB,"Ad not Ready",contoller)
                    print("Ad not Ready")
                }
            }
            else {
                FullAdsListener.adsInstanceHelper.FullAdsFailed(AdsEnum.FULL_ADS_ADMOB,"Admob Interstitial null",viewController)
            }
        }
        else{
            FullAdsListener.adsInstanceHelper.FullAdsFailed(AdsEnum.FULL_ADS_ADMOB,"FullAds Id null",viewController)
            
        }
        
    }
    
    
}

extension AdsMobFullAds{
    func createInterstitial() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:ADMOB_FULLAD_ID,
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            adMobinterstitial = ad
            adMobinterstitial!.fullScreenContentDelegate = self
            
        }
        )
    }
}

extension AdsMobFullAds : GADFullScreenContentDelegate {
    func interstitial(ad: GADInterstitialAd!, didFailToReceiveAdWithError error: Error!) {
        print("\(#function): \(error.localizedDescription)")
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitialAd) {
        // Recycle interstitial
        //createInterstitial()
    }
    
    func interstitialWillPresentScreen(ad: GADInterstitialAd!) {
        print("interstitialWillPresentScreen")
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitialAd) {
        print("interstitialDidReceiveAd")
        
        FullAdsListener.adsInstanceHelper.fullAdsLoaded()
    }
    
    /// Tells the delegate an ad request failed.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("interstitial:didFailToReceiveAdWithError: \(error)")
        FullAdsListener.adsInstanceHelper.FullAdsFailed(AdsEnum.FULL_ADS_ADMOB,error.localizedDescription,contoller)
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("interstitialWillPresentScreen")
        FullAdsListener.adsInstanceHelper.fullAdsLoaded()
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("interstitialWillDismissScreen")
        FullAdsListener.adsInstanceHelper.FullAdsClosed(contoller)
        AdsMobInitFullAds.init().createInitFullAd(from: contoller,adsid: ADMOB_FULLAD_ID,isFromCache: false)
    }
    
    /// Tells the delegate the interstitial had been animated off the screen.
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitialAd) {
        print("interstitialWillLeaveApplication")
    }
    
}



public class CallAppLaunch{
    public  static let shared = CallAppLaunch()
    public   func v2CallonAppLaunch(from viewController: UIViewController,value:String,type:String){
        
        let hasInAppPurchased = UserDefaults.standard.bool(forKey: IN_APP_PURCHASED)
        print("Bool Value: \(hasInAppPurchased)")
        
        if !hasInAppPurchased  {
            print("CheckviewController\(viewController)")
            // setFulladsCount(viewController, 0)
            
            print("Bool value check: \(hasInAppPurchased)")
            HandleLaunchPrompt.init().handle_launch_prompt(viewController: viewController)
            cacheNavigationFullAd(from: viewController)
        }
        
        
        
        
        //          checkForForceUpdates(viewController)
        //          checkForNormalUpdates(viewController)
        
        // doTopicRequest(viewController)
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
            timer.invalidate()
            self.callingForMapper(from: viewController,value,type)
            
        }
        
    }
    
    func callingForMapper(from viewController: UIViewController,_ value:String,_ type:String){
        print("MapperValueFetch \(value) type: \(type)")
        
        do {
            if (type != "" && value != "") {
                if (type == "url") {
                    let url = NSURL(string:value)! as URL
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    
                } else if type == "deeplink" {
                    switch (value) {
                    case gcmMoreApp:
                        moreAppurl()
                        break
                    case gcmRateApp:
                        rateApp(showCustom: true, self: viewController)
                        break
                        
                    case gcmFeedbackApp:
                        if #available(iOS 13.0, *) {
                            let popOverVC = UIStoryboard(name: "Engine", bundle: nil).instantiateViewController(identifier: "FeedbackVC") as! FeedbackVC
                            viewController.addChild(popOverVC)
                            popOverVC.view.frame = viewController.view.frame
                            viewController.view.addSubview(popOverVC.view)
                            popOverVC.didMove(toParent: viewController)
                            
                        }
                        else{
                            let popOverVC =  UIStoryboard(name: "Engine", bundle: nil).instantiateViewController(withIdentifier: "FeedbackVC")
                            viewController.addChild(popOverVC)
                            popOverVC.view.frame = viewController.view.frame
                            viewController.view.addSubview(popOverVC.view)
                            popOverVC.didMove(toParent: viewController)
                        }
                        
                        break
                    case gcmShareApp:
                        //showSharePrompt(viewController)
                        if #available(iOS 13.0, *) {
                            let popOverVC = UIStoryboard(name: "Engine", bundle: nil).instantiateViewController(identifier: "ShareAppVC") as! ShareAppVC
                            viewController.addChild(popOverVC)
                            popOverVC.view.frame = viewController.view.frame
                            viewController.view.addSubview(popOverVC.view)
                            popOverVC.share_text = SHARE_TEXT
                            popOverVC.share_url = SHARE_URL
                            popOverVC.didMove(toParent: viewController)
                        }
                        else{
                            let popOverVC =  UIStoryboard(name: "Engine", bundle: nil).instantiateViewController(withIdentifier: "ShareAppVC")
                            viewController.addChild(popOverVC)
                            popOverVC.view.frame = viewController.view.frame
                            viewController.view.addSubview(popOverVC.view)
                            popOverVC.didMove(toParent: viewController)
                        }
                        break
                        
                    case gcmForceAppUpdate:
                        if #available(iOS 13.0, *) {
                            let popOverVC = UIStoryboard(name: "Engine", bundle: nil).instantiateViewController(identifier: "CheckForceUpdateVC") as! CheckForceUpdateVC
                            viewController.addChild(popOverVC)
                            popOverVC.view.frame = viewController.view.frame
                            viewController.view.addSubview(popOverVC.view)
                            popOverVC.didMove(toParent: viewController)
                        }
                        else{
                            let popOverVC =  UIStoryboard(name: "Engine", bundle: nil).instantiateViewController(withIdentifier: "CheckForceUpdateVC")
                            viewController.addChild(popOverVC)
                            popOverVC.view.frame = viewController.view.frame
                            viewController.view.addSubview(popOverVC.view)
                            popOverVC.didMove(toParent: viewController)
                        }
                        break
                    case gcmRemoveAds :
                        if #available(iOS 13.0, *) {
                            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PurchaseVC") as! PurchaseVC
                            vc.fromMoreTool = true
                            viewController.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                        
//                    case MYPROJECTS:
//                        if #available(iOS 13.0, *) {
//                            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyProjectVCViewController") as! MyProjectVCViewController
//                            viewController.navigationController?.pushViewController(vc, animated: true)
//                            
//                        }
//                        else{
//                            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyProjectVCViewController") as! MyProjectVCViewController
//                            viewController.navigationController?.pushViewController(vc, animated: true)
//                        }
                    default:
                        break
                    }
                }
            }
        } catch  {
            print("Error\(error.localizedDescription)")
        }
    }
    
    
    
    
    
    
    
    
    func cacheNavigationFullAd(from viewController: UIViewController) {
        
        let hasInAppPurchased = UserDefaults.standard.bool(forKey: IN_APP_PURCHASED)
        
        
        if  hasInAppPurchased || ServiceHelper.sharedInstanceHelper.isConnectedToNetwork() {
            return
        }
        else {
            UserDefaults.standard.set(0, forKey: FULLAD_LOAD_DATA_POSITION)
            loadNavigationCacheFullAds(from: viewController, pos: UserDefaults.standard.integer(forKey: FULLAD_LOAD_DATA_POSITION));
        }
        
    }
    
    
    func loadNavigationCacheFullAds(from viewController: UIViewController, pos:Int) {
        FullAdsListener.init().fulladsdelegates = self
        getNewNavCacheFullPageAd(viewController, pos)
        
    }
    
    
}


extension CallAppLaunch : FullAdsListenerProtocol{
    public func onFullAdClosed(_ viewController: UIViewController) {
        print("Full Ads Closedddddddd")
        
    }
    
    
    
    public func onFullAdsLoad() {
        print("AHandler.onFullAdLoaded")
    }
    
    public func onFullAdsFailed(provider: AdsEnum, error: String, viewController: UIViewController) {
        print("FullAdsError\(error)")
        
        let currtpos =  UserDefaults.standard.integer(forKey: FULLAD_LOAD_DATA_POSITION)
        let pos =  currtpos + 1
        UserDefaults.standard.set(pos, forKey: FULLAD_LOAD_DATA_POSITION)
        loadNavigationCacheFullAds(from: viewController, pos: pos)
    }
}


public class BannerHeader :NSObject{
    public  static let bannerHeaderInstance = BannerHeader()
    public func getBannerHeader(_ viewController:UIViewController,_ view:UIView,_ heightConstraint:NSLayoutConstraint){
        let hasInAppPurchased = UserDefaults.standard.bool(forKey: IN_APP_PURCHASED)
        print("hasInAppPurchased\(hasInAppPurchased)")
        if  hasInAppPurchased {
            view.isHidden = true
            heightConstraint.constant = 0
        } else {
            UserDefaults.standard.set(0, forKey: LOAD_DATA_POSITION)
            AdsListenerHelper.adsInstanceHelper.delegates = self
            print("getDaysDiffsjjsjss()\(getDaysDiff())  \(getStringtoInt(data: TOP_BANNER_STARTDATE))")
            if getDaysDiff() >= getStringtoInt(data: TOP_BANNER_STARTDATE){
                view.isHidden = false
                
                if TYPE_TOP_BANNER == TOP_BANNER_call_native{
                    view.isHidden = false
                    print("TOPBANNER\(TYPE_TOP_BANNER) \(TOP_BANNER_call_native)")
                    getNewbannerHeader(UserDefaults.standard.integer(forKey: LOAD_DATA_POSITION), viewController,view,heightConstraint)
                }else{
                    
                }
                
            }
            else{
                view.isHidden = true
                heightConstraint.constant = 0
                
                OnBannerAdsIdLoaded.adsInstanceHelper.bannerAdsFailed()
            }
        }
        
    }
}

extension BannerHeader : AdsListenerProtocol {
    func onAdsLoad(view: UIView, viewController: UIViewController, _ heightConstaint: NSLayoutConstraint) {
        
    }
    
    func onAdsFailed(view: UIView, provider: AdsEnum, error: String, viewController: UIViewController, _ heightConstaint: NSLayoutConstraint) {
        let  value = UserDefaults.standard.integer(forKey: LOAD_DATA_POSITION)
        
        let pos = value + 1
        
        UserDefaults.standard.set(pos, forKey: LOAD_DATA_POSITION)
        getNewbannerHeader(pos,viewController, view, heightConstaint)
    }
    
    
    
}

class BannerFooter :NSObject{
    
    static let bannerFooterInstance = BannerFooter()
    
    func getBannerFooter(_ viewController:UIViewController,_ view:UIView,_ heightConstraint:NSLayoutConstraint){
        
        let hasInAppPurchased = UserDefaults.standard.bool(forKey: IN_APP_PURCHASED)
        print("hasInAppPurchased\(hasInAppPurchased)")
        if  hasInAppPurchased {
            view.isHidden = true
            heightConstraint.constant = 0
        } else {
            UserDefaults.standard.set(0, forKey: LOAD_DATA_POSITION)
            print("getDaysDiff0 \(getDaysDiff()) \(getStringtoInt(data: BOTTOM_BANNER_STARTDATE))")
            
            if getDaysDiff() >= getStringtoInt(data: BOTTOM_BANNER_STARTDATE){
                AdsListenerHelper.adsInstanceHelper.delegates = self
                print("getDaysDiff()\(getDaysDiff()) \(getStringtoInt(data: BOTTOM_BANNER_STARTDATE))")
                print("TYPE_BOTTOM_BANNER 0 \(TYPE_BOTTOM_BANNER) \(getStringtoInt(data: BOTTOM_BANNER_call_native))")
                if TYPE_BOTTOM_BANNER == BOTTOM_BANNER_call_native{
                    
                    print("TYPE_BOTTOM_BANNER\(TYPE_BOTTOM_BANNER) \(getStringtoInt(data: BOTTOM_BANNER_call_native))")
                    view.isHidden = false
                    //                    heightConstraint.constant = 65
                    getNewbannerFooter(UserDefaults.standard.integer(forKey: LOAD_DATA_POSITION), viewController,view,heightConstraint)
                    
                }else if TYPE_BANNER_LARGE == BOTTOM_BANNER_call_native {
                    
                }
            }
            else{
                print("Banner Ads Failed")
                view.isHidden = true
                heightConstraint.constant = 0
                OnBannerAdsIdLoaded.adsInstanceHelper.bannerAdsFailed()
            }
        }
        
        
    }
}

extension BannerFooter : AdsListenerProtocol {
    func onAdsLoad(view: UIView, viewController: UIViewController, _ heightConstaint: NSLayoutConstraint) {
        
    }
    
    func onAdsFailed(view: UIView, provider: AdsEnum, error: String, viewController: UIViewController, _ heightConstaint: NSLayoutConstraint) {
        let  value = UserDefaults.standard.integer(forKey: LOAD_DATA_POSITION)
        
        let pos = value + 1
        print("Failed Position\(value)")
        UserDefaults.standard.set(pos, forKey: LOAD_DATA_POSITION)
        getNewbannerFooter(pos,viewController, view, heightConstaint)
    }
    
    
    
    
}



public class BannerRectangle :NSObject{
    public  static let bannerRectangleInstance = BannerRectangle()
    public func getBannerRectangle(_ viewController:UIViewController,_ view:UIView,_ heightConstraint:NSLayoutConstraint){
        let hasInAppPurchased = UserDefaults.standard.bool(forKey: IN_APP_PURCHASED)
        if  hasInAppPurchased {
            view.isHidden = true
            heightConstraint.constant = 0
        } else {
            UserDefaults.standard.set(0, forKey: LOAD_DATA_POSITION)
            AdsListenerHelper.adsInstanceHelper.delegates = self
            if getDaysDiff() >= getStringtoInt(data: RECTANGLE_BANNER_start_date){
                view.isHidden = false
                getbannerRectangle(UserDefaults.standard.integer(forKey: LOAD_DATA_POSITION), viewController,view,heightConstraint)
                
            }
            else{
                view.isHidden = true
                heightConstraint.constant = 0
                BannerRectangleStatus.adsInstanceHelper.bannerRectangleAdsLoaded(status: false)
            }
        }
        
    }
}

extension BannerRectangle : AdsListenerProtocol {
    func onAdsLoad(view: UIView, viewController: UIViewController, _ heightConstaint: NSLayoutConstraint) {
        
    }
    
    func onAdsFailed(view: UIView, provider: AdsEnum, error: String, viewController: UIViewController, _ heightConstaint: NSLayoutConstraint) {
        let  value = UserDefaults.standard.integer(forKey: LOAD_DATA_POSITION)
        
        let pos = value + 1
        
        UserDefaults.standard.set(pos, forKey: LOAD_DATA_POSITION)
        getbannerRectangle(pos,viewController, view, heightConstaint)
    }
}




public func showFullAds(viewController:UIViewController,isForce:Bool){
    
    let hasInAppPurchased = UserDefaults.standard.bool(forKey: IN_APP_PURCHASED)
    
    if  hasInAppPurchased {
        return
    }
    else {
        if (getDaysDiff() >= getStringtoInt(data: FULL_ADS_start_date)){
            
            setFulladsCount(viewController, -1)
            if isForce {
                ShowForceFullAds.init().forceFullAds(viewController: viewController)
            }
            else{
                print("Full Ads Count \(getFullAdsCount(viewController))  \(getStringtoInt(data: FULL_ADS_nevigation)) ")
                if getFullAdsCount(viewController) >= getStringtoInt(data: FULL_ADS_nevigation){
                    setFulladsCount(viewController, 0)
                    
                    ShowFullAds.init().FullAds(viewController: viewController)
                }
                
            }
        }
    }
    
}

class ShowFullAds {
    
    
    func FullAds(viewController:UIViewController){
        //  UserDefaults.standard.set(0, forKey: FULLAD_LOAD_DATA_POSITION)
        loadFullAds(UserDefaults.standard.integer(forKey: FULLAD_LOAD_DATA_POSITION), viewController);
        FullAdsListener.adsInstanceHelper.fulladsdelegates = self
        
    }
    
}




extension ShowFullAds : FullAdsListenerProtocol{
    func onFullAdClosed(_ viewController: UIViewController) {
        print("Full Ads Closedllllll")
        //        ShowForceFullAdsCloseListener.adsInstanceHelper.ForcefullAdsClose(status: true)
        
    }
    
    func onFullAdsLoad() {
        print("Show Force Full Ads")
        
    }
    
    func onFullAdsFailed(provider: AdsEnum, error: String, viewController: UIViewController) {
        print("Show Full Ads Error\(error)")
        //        ShowForceFullAdsCloseListener.adsInstanceHelper.ForcefullAdsClose(status: false)
        let  value = UserDefaults.standard.integer(forKey: FULLAD_LOAD_DATA_POSITION)
        print("vshhhhdhdhdh\(value)")
        let pos = value + 1
        print("podddyyddy\(pos)")
        UserDefaults.standard.set(pos, forKey: FULLAD_LOAD_DATA_POSITION)
        loadForceFullAds(pos,viewController)
    }
    
    
}




class ShowForceFullAds {
    
    func forceFullAds(viewController:UIViewController){
        //  UserDefaults.standard.set(0, forKey: FULLAD_LOAD_DATA_POSITION)
        print("Force Forllrlrl")
        
        loadForceFullAds(UserDefaults.standard.integer(forKey: FULLAD_LOAD_DATA_POSITION), viewController);
        FullAdsListener.adsInstanceHelper.fulladsdelegates = self
    }
    
    
}

extension ShowForceFullAds : FullAdsListenerProtocol{
    func onFullAdClosed(_ viewController: UIViewController) {
        print("Full Ads Closedssssss")
        ShowForceFullAdsCloseListener.adsInstanceHelper.ForcefullAdsClose(status: true)
        
    }
    
    
    func onFullAdsLoad() {
        print("Show Force Full Ads")
    }
    
    func onFullAdsFailed(provider: AdsEnum, error: String, viewController: UIViewController) {
        print("Show Full Ads Error\(error)")
        ShowForceFullAdsCloseListener.adsInstanceHelper.ForcefullAdsClose(status: false)
        let  value = UserDefaults.standard.integer(forKey: FULLAD_LOAD_DATA_POSITION)
        print("vshhhhdhdhdh\(value)")
        let pos = value + 1
        print("podddyyddy\(pos)")
        UserDefaults.standard.set(pos, forKey: FULLAD_LOAD_DATA_POSITION)
        loadForceFullAds(pos,viewController)
    }
}


public class HandleLaunchPrompt {
    public  func  handle_launch_prompt(viewController:UIViewController) {
        var rate_nonRepeat = Int()
        // var cp_nonRepeat = Int()
        //  var full_nonRepeat : Int?
        var  full_nonRepeat : Int = 0
        //  var removeads_nonRepeat = Int()
        
        if  LAUNCH_NON_REPEAT_COUNT.count > 0 {
            for i in 0..<LAUNCH_NON_REPEAT_COUNT.count {
                rate_nonRepeat =  getStringtoInt(data: LAUNCH_NON_REPEAT_COUNT[i].launch_rate)
                // cp_nonRepeat = getStringtoInt(data: LAUNCH_NON_REPEAT_COUNT[i].launch_exit)
                full_nonRepeat = getStringtoInt(data: LAUNCH_NON_REPEAT_COUNT[i].launch_full)
                //removeads_nonRepeat = getStringtoInt(data: LAUNCH_NON_REPEAT_COUNT[i].launch_removeads)
                
                
                if (APP_LAUNCH_COUNT == rate_nonRepeat) {
                    //                    rateApp(showCustom: false, self: viewController)
                }
                
            }
        }
        
        
        if (LAUNCH_REPEAT_EXIT != "" && APP_LAUNCH_COUNT % getStringtoInt(data: LAUNCH_REPEAT_EXIT) == 0) {
            
            // showCPStart((Activity) context);
        } else if (LAUNCH_REPEAT_RATE != ""  && APP_LAUNCH_COUNT % getStringtoInt(data:LAUNCH_REPEAT_RATE) == 0 ) {
            
            //            rateApp(showCustom: false, self: viewController)
            
        }
        //        else if (LAUNCH_REPEAT_REMOVEADS != nil && APP_LAUNCH_COUNT % getStringtoInt(data: LAUNCH_REPEAT_REMOVEADS) == 0) {
        //
        //            //   showRemoveAdsPrompt(context);
        //        }
    }
    var deepvalue = String()
    var deeptype = String()
    func  showFullAdsOnLaunch(_ viewController:UIViewController,_ value:String,_ type:String) {
        print("ShoWFullads onlaunch")
        deepvalue = value
        deeptype = type
        // UserDefaults.standard.set(0, forKey:FULLAD_LOAD_DATA_POSITION)
        loadFullAdsOnLaunch(viewController: viewController, pos: UserDefaults.standard.integer(forKey: FULLAD_LOAD_DATA_POSITION ))
        // FullAdsListener.adsInstanceHelper.fulladsdelegates = self
    }
    
    
    func  loadFullAdsOnLaunch(viewController:UIViewController,pos:Int) {
        print("loadFullAdsOnLaunch")
        FullAdsListener.adsInstanceHelper.fulladsdelegates = self
        showFullAdOnLaunch(viewController,pos)
        
        
        
    }
    
}


extension HandleLaunchPrompt :FullAdsListenerProtocol{
    public func onFullAdClosed(_ viewController: UIViewController) {
        // onCloseFullAd(viewController)
        print("Full AdsClosedhhhh")
        AppFullAdsCloseListner.adsInstanceHelper.fulladsclosedelegates = self
        AppFullAdsCloseListner.adsInstanceHelper.FullAdsClos(viewController: viewController)
    }
    
    
    public func onFullAdsLoad() {
        print("Show Full Adsqqqq")
    }
    
    public func onFullAdsFailed(provider: AdsEnum, error: String, viewController: UIViewController) {
        print("FULLAdsFailedviewController\(viewController)")
        let pos = UserDefaults.standard.integer(forKey: FULLAD_LOAD_DATA_POSITION)
        let curntpos = pos + 1
        
        UserDefaults.standard.set(curntpos, forKey: FULLAD_LOAD_DATA_POSITION)
        //loadFullAdsOnLaunch(viewController: viewController, pos:UserDefaults.standard.integer(forKey: FULLAD_LOAD_DATA_POSITION));
        
        print("Show Full Ads Errorqqqqq\(error)")
        
        if (pos >= LAUNCH_FULL_ADS_providers.count) {
            //  listener.onFullAdClosed();
            AppFullAdsCloseListner.adsInstanceHelper.fulladsclosedelegates = self
            AppFullAdsCloseListner.adsInstanceHelper.FullAdsClos(viewController: viewController)
        } else {
            loadFullAdsOnLaunch(viewController: viewController, pos: UserDefaults.standard.integer(forKey: FULLAD_LOAD_DATA_POSITION ))
        }
    }
    
    
}


extension HandleLaunchPrompt:AppFullAdsCloseProtocol{
    public func onFullAdClosed(viewController: UIViewController) {
        
        print("Full Ads Closedrrrryyyyyy\(viewController)")
        //        viewController.dismiss(animated: true, completion: nil)
        FullAdsCloseListener.adsInstanceHelper.FullAdsClose(viewController)
        //  crossButton.isHidden = true
    }
}


public class HandleLaunchFullAds {
    var value = String()
    var type = String()
    public  static let shared = HandleLaunchFullAds()
    public func handle_launch_For_FullAds(viewController:UIViewController,value:String,type:String,crossButtons:UIButton) {
        // UserDefaults.standard.set(0, forKey: FULLSERVICECOUNT)
        self.value = value
        self.type = type
        crossButton = crossButtons
        var full_nonRepeat = Int()
        if (LAUNCH_NON_REPEAT_COUNT.count > 0) {
            for i in 0..<LAUNCH_NON_REPEAT_COUNT.count  {
                full_nonRepeat = getStringtoInt(data: LAUNCH_NON_REPEAT_COUNT[i].launch_full)
                
                if (APP_LAUNCH_COUNT == full_nonRepeat){
                    
                    
                    
                    HandleLaunchPrompt.init().showFullAdsOnLaunch(viewController,value,type)
                    
                    AppFullAdsCloseListner.adsInstanceHelper.fulladsclosedelegates = self
                    
                    return
                }
            }
            
        }
        print("LAUNCH_REPEAT_FULL_ADSddddd\(LAUNCH_REPEAT_FULL_ADS)")
        if (LAUNCH_REPEAT_FULL_ADS != "" && APP_LAUNCH_COUNT % getStringtoInt(data: LAUNCH_REPEAT_FULL_ADS) == 0) {
            HandleLaunchPrompt.init().showFullAdsOnLaunch(viewController,value,type)
            
            AppFullAdsCloseListner.adsInstanceHelper.fulladsclosedelegates = self
            return;
        }
        
        //AppFullAdsCloseListner.adsInstanceHelper.fulladsclosedelegates = self
        
        AppFullAdsCloseListner.adsInstanceHelper.fulladsclosedelegates = self
        AppFullAdsCloseListner.adsInstanceHelper.FullAdsClos(viewController: viewController)
    }
    
}


extension HandleLaunchFullAds:AppFullAdsCloseProtocol{
    public func onFullAdClosed(viewController: UIViewController) {
        print("Full Ads Closedrrrr")
        viewController.dismiss(animated: true, completion: nil)
        print()
        
        crossButton.isHidden = true
        
    }
}


func onCloseFullAd(_ viewController:UIViewController) {
    
    let state = UIApplication.shared.applicationState
    print("State\(state)")
    switch UIApplication.shared.applicationState {
    case .background, .inactive: break
        // background
    case .active:
        // AppFullAdsCloseListner.adsInstanceHelper.FullAdsClos(viewController: viewController)
        break
    default:
        break
    }
}


class NativeLargeAds{
    
    func getNativeLarge(viewController:UIViewController,view:UIView,heightConstarint:NSLayoutConstraint){
        let hasInAppPurchased = UserDefaults.standard.bool(forKey: IN_APP_PURCHASED)
        
        if  hasInAppPurchased {
            view.isHidden = true
            heightConstarint.constant = 0
        } else {
            if (!ServiceHelper.sharedInstanceHelper.isConnectedToNetwork()) {
                //  getDefaultView()
            }
            
            if (getDaysDiff() >= getStringtoInt(data: NATIVE_LARGE_start_date)) {
                print("NativeLarge\(NATIVE_LARGE_call_native)")
                view.isHidden = false
                if  NATIVE_TYPE_LARGE == NATIVE_LARGE_call_native {
                    
                    
                    UserDefaults.standard.set(0, forKey: NATIVE_LOAD_POSITION)
                    loadNativeLarge(viewController, UserDefaults.standard.integer(forKey: NATIVE_LOAD_POSITION),view,heightConstarint)
                    
                    
                    
                } else if (NATIVE_TYPE_MEDIUM == NATIVE_LARGE_call_native) {
                    // return getNativeMedium(context);
                    NativeMediumAds.init().getNativeMedium(viewController: viewController,view: view, heightConstarint: heightConstarint)
                    
                } else if (TYPE_TOP_BANNER == NATIVE_LARGE_call_native) {
                    BannerHeader.bannerHeaderInstance.getBannerHeader(viewController, view,heightConstarint)
                }
            }else{
                heightConstarint.constant = 0
                view.isHidden = true
            }
        }
        
    }
    
    
    func loadNativeLarge(_ viewController:UIViewController,_ pos:Int,_ view:UIView ,_ heightConstraint:NSLayoutConstraint) {
        
        print("GetNativeLarge")
        getNewNativeLarge(viewController,pos,view,heightConstraint)
        AdsListenerHelper.adsInstanceHelper.delegates = self
    }
    
}

extension NativeLargeAds:AdsListenerProtocol{
    func onAdsLoad(view: UIView, viewController: UIViewController, _ heightConstaint: NSLayoutConstraint) {
        print("NativeAdsLoad")
    }
    
    func onAdsFailed(view: UIView, provider: AdsEnum, error: String, viewController: UIViewController, _ heightConstaint: NSLayoutConstraint) {
        let  value = UserDefaults.standard.integer(forKey: NATIVE_LOAD_POSITION)
        print("vshhhhdhdhdh\(value)")
        let pos = value + 1
        print("podddyyddy\(pos)")
        UserDefaults.standard.set(pos, forKey: NATIVE_LOAD_POSITION)
        getNewNativeLarge(viewController,UserDefaults.standard.integer(forKey: NATIVE_LOAD_POSITION) , view,heightConstaint)
    }
    
    
    
}

class NativeMediumAds{
    
    func getNativeMedium(viewController:UIViewController,view:UIView,heightConstarint:NSLayoutConstraint){
        
        if ServiceHelper.sharedInstanceHelper.isConnectedToNetwork(){
            
            let hasInAppPurchased = UserDefaults.standard.bool(forKey: IN_APP_PURCHASED)
            if  hasInAppPurchased  {
                view.isHidden = true
                heightConstarint.constant = 0
                
            } else {
                
                if (getDaysDiff() >= getStringtoInt(data: NATIVE_MEDIUM_start_date)) {
                    view.isHidden = false
                    if  NATIVE_TYPE_MEDIUM == NATIVE_MEDIUM_call_native {
                        
                        UserDefaults.standard.set(0, forKey: NATIVE_MEDIUM_LOAD_POSITION)
                        loadNativeMedium(viewController, UserDefaults.standard.integer(forKey: NATIVE_MEDIUM_LOAD_POSITION),view,heightConstarint)
                        
                    } else if (NATIVE_TYPE_MEDIUM == NATIVE_LARGE_call_native) {
                        NativeLargeAds.init().getNativeLarge(viewController: viewController,view: view,heightConstarint: heightConstarint)
                        
                    } else if (TYPE_TOP_BANNER == NATIVE_LARGE_call_native) {
                        BannerHeader.bannerHeaderInstance.getBannerHeader(viewController, view,heightConstarint)
                        
                    }
                }else{
                    BannerRectangleStatus.adsInstanceHelper.bannerRectangleAdsLoaded(status: false)
                    heightConstarint.constant = 0
                    view.isHidden = true
                }
            }
            
        }else{
            let moreAppView = UINib(nibName: "MoreAppView", bundle: .main).instantiate(withOwner: nil, options: nil).first as! UIView
            
            view.addSubview(moreAppView)
            
        }
        
        
        
        
    }
    
    
    func loadNativeMedium(_ viewController:UIViewController,_ pos:Int,_ view:UIView, _ heightConstarint: NSLayoutConstraint) {
        
        
        getNewNativeMedium(viewController,pos,view,heightConstarint)
        AdsListenerHelper.adsInstanceHelper.delegates = self
    }
    
}

extension NativeMediumAds:AdsListenerProtocol{
    func onAdsLoad(view: UIView, viewController: UIViewController, _ heightConstaint: NSLayoutConstraint) {
        print("NativeMediumAdsLoad")
    }
    
    func onAdsFailed(view: UIView, provider: AdsEnum, error: String, viewController: UIViewController, _ heightConstaint: NSLayoutConstraint) {
        let  value = UserDefaults.standard.integer(forKey: NATIVE_MEDIUM_LOAD_POSITION)
        print("vshhhhdhdhdh\(value)")
        let pos = value + 1
        print("podddyyddy\(pos)")
        UserDefaults.standard.set(pos, forKey: NATIVE_MEDIUM_LOAD_POSITION)
        getNewNativeMedium(viewController,UserDefaults.standard.integer(forKey: NATIVE_MEDIUM_LOAD_POSITION),view,heightConstaint)
    }
    
    
}


func getDefaultView()->UIView{
    let view = UIView()
    return view
}




public class CallBGAppLaunch{
    
    let launchcount = UserDefaults.standard.integer(forKey: LAUNCH_COUNT)
    let device_token = UserDefaults.standard.string(forKey: DEVICE_TOKEN)
    public  static let shared = CallBGAppLaunch()
    public func v2CallOnBGLaunch(from viewController: UIViewController){
        initService(false, launchCount:launchcount , deviceToken:device_token ?? "")
        CallOnSplash.init().cacheLaunchFullAd(viewContoller: viewController)
        setFulladsCount(viewController, -1)
        
    }
}

func googleTestDeviceID(){
    
    AdMobMediation.getInstance().adMobMediation()
    
    
    
}


func fbTestDeviceID(){
    //FBAdSettings.addTestDevice(FBAdSettings.testDeviceHash())
    FBAudienceNetworkAds.initialize(with: nil, completionHandler: {status in
        
        print("Status\(status.isSuccess) \(status.message)")
    })
    FBAdSettings.addTestDevice(FBAdSettings.testDeviceHash())
    FBAdSettings.setAdvertiserTrackingEnabled(true)
}


public func doGCMrequest(fcmtoken:String){
    var params = [String:Any]()
    let count = UserDefaults.standard.integer(forKey: LAUNCH_COUNT)
    print("DOGCMrequest\(count)")
    params = ["app_id": APP_ID, "country": countryname.getCountryNameInfo(), "screen": screenHeight.getScreenHeightResolution(), "launchcount": UserDefaults.standard.integer(forKey: LAUNCH_COUNT) , "version": appVersionInfo.getAppVersionInfo(), "osversion": osVersion.getOSInfo(), "dversion": systemversion.getDeviceName(), "os": "2", "gcmid": fcmtoken, "unique_id": generateUniqueId(), "virtual_id": UserDefaults.standard.string(forKey: VIRTUAL_ID) ?? ""]
    print(params)
    let jsonData = try! JSONSerialization.data(withJSONObject: params, options: .sortedKeys)
    let jsonString1 = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
    let encodedString = hexadecimal.encrypt(text:jsonString1)
    var parametr = [String:String]()
    parametr = ["data":encodedString!]
    ServiceHelper.sharedInstanceHelper.createPostRequest(method: .post, showHud: true, params: parametr, apiName: fcmApi) { (result, error) in
        if result != nil{
            let decryptString = decryptvalue.decrypt(hexString:result! as! String)
            print("Decrypthdhdhhdhdhdhdgghhjjjj\(decryptString!)")
            //            //
            let dict1 = dictnry.convertToDictionary(text: decryptString!)
            print("Dictionary1 \(dict1!)")
            let code = dict1!["status"] as! String
            if(code == "0"){
                let reqvalue = dict1!["reqvalue"] as! String
                print("reqvalue\(reqvalue)")
                UserDefaults.standard.set(reqvalue, forKey: VIRTUAL_ID)
            }
        }else{
        }
    }
}

