//
//  FBProviderExtension.swift
//  App Engine
//
//  Created by Quantum_MAC_7 on 23/03/20.
//  Copyright © 2020 Pulkit Babbar. All rights reserved.
//

import Foundation
import UIKit
import FBAudienceNetwork


 class FBBannerAd: NSObject {
    var adslistener = AdsListenerHelper()
    
    var contoller = UIViewController()
    static let shared = FBBannerAd()
    var isRemoved = false {
        didSet {
            guard isRemoved else { return }
            //removeBanner()
        }
    }
    
    
    fileprivate var FbBannerViewAd: FBAdView?
    
    fileprivate var bannerFbViewAdUnitID = FB_BANNERHEADER_ID
    private var intervalCounter = 0
    fileprivate var rewardAmountBackup = 1
    func showFBBanner(from viewController: UIViewController, at position: BannerPosition = .bottom,banner_id:String,_ view:UIView,_ heightConstaint:NSLayoutConstraint) {
        guard !isRemoved else { return }
        
        FB_BANNERHEADER_ID = banner_id
        loadFBBannerAd(from: viewController,banner_id: banner_id,view,heightConstaint)
    }
}

var fbBannerview = UIView()
var viewConstraint = NSLayoutConstraint()
private extension FBBannerAd {
    func loadFBBannerAd(from viewController: UIViewController,banner_id:String,_ view:UIView ,_ heightConstaint:NSLayoutConstraint) {
        print("Facebook banner ad loading...\(viewController) \(banner_id)")
        
        FbBannerViewAd?.removeFromSuperview()
        _  = IDFA.shared.identifier
        
        
        // FBAdSettings.addTestDevice(deviceid!)
        FbBannerViewAd = FBAdView(placementID: FB_BANNERHEADER_ID, adSize: kFBAdSizeHeight50Banner, rootViewController: viewController)
        guard let FbBannerViewAd = FbBannerViewAd else { return }
        FbBannerViewAd.frame = CGRect(x: 0,y: 0, width: FbBannerViewAd.frame.size.width, height: FbBannerViewAd.frame.size.height)
        FbBannerViewAd.delegate = self
        contoller = viewController
        //FbBannerViewAd.isHidden = true
       // fbBannerview = view
        viewConstraint = heightConstaint
        AdsListenerHelper.adsInstanceHelper.delegates = self
        FbBannerViewAd.loadAd()
        view.addSubview(FbBannerViewAd)
        
    }
}

extension FBBannerAd: FBAdViewDelegate {
    // Did receive
    func adViewDidLoad(_ adView: FBAdView) {
        FbBannerViewAd?.isHidden = false
        print("FB banner Ad Load\(adView) \(adView.frame.height)")
        viewConstraint.constant = adView.frame.height
        AdsListenerHelper.adsInstanceHelper.adsLoad(adsView: adView, viewcontroller:contoller,viewConstraint)
    }
    
    func adView(_ adView: FBAdView, didFailWithError error: Error) {
        print("FB banner Ad Failed\(error)")
        AdsListenerHelper.adsInstanceHelper.adsFailed(adView,AdsEnum.ADS_ADMOB, error.localizedDescription,contoller,viewConstraint)
        
    }
}


extension FBBannerAd : AdsListenerProtocol{
    func onAdsLoad(view: UIView, viewController: UIViewController, _ heightConstaint: NSLayoutConstraint) {
        
        view.isHidden = false
        fbBannerview.isHidden = false
        fbBannerview.center.x = view.center.x
        fbBannerview.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
      //  fbBannerview.addSubview(view)
        
        heightConstaint.constant = view.frame.height
        
        OnBannerAdsIdLoaded.adsInstanceHelper.bannerAdsLoaded()
    }
    
    func onAdsFailed(view: UIView, provider: AdsEnum, error: String, viewController: UIViewController, _ heightConstaint: NSLayoutConstraint) {
        heightConstaint.constant = 0
        view.isHidden = true
        fbBannerview.isHidden = true
        OnBannerAdsIdLoaded.adsInstanceHelper.bannerAdsFailed()
        
    }
    
}


class FbBannerRectangleAd: NSObject {
   var adslistener = AdsListenerHelper()
   
   var contoller = UIViewController()
   static let shared = FbBannerRectangleAd()
   var isRemoved = false {
       didSet {
           guard isRemoved else { return }
           //removeBanner()
       }
   }
   
   
   fileprivate var FbBannerViewAd: FBAdView?
   
   fileprivate var bannerFbViewAdUnitID = FB_BANNERRECTANGLE_ID
   private var intervalCounter = 0
   fileprivate var rewardAmountBackup = 1
   func showFBBannerRectangle(from viewController: UIViewController, at position: BannerPosition = .bottom,banner_id:String,_ view:UIView,_ heightConstaint:NSLayoutConstraint) {
       guard !isRemoved else { return }
       
       FB_BANNERRECTANGLE_ID = banner_id
       loadFBBannerRectangleAd(from: viewController,banner_id: banner_id,view,heightConstaint)
   }
}

var fbBannerRectangleview = UIView()
var bannerviewConstraint = NSLayoutConstraint()
private extension FbBannerRectangleAd {
   func loadFBBannerRectangleAd(from viewController: UIViewController,banner_id:String,_ view:UIView ,_ heightConstaint:NSLayoutConstraint) {
       print("Facebook banner ad loading...\(viewController) \(banner_id)")
       
       FbBannerViewAd?.removeFromSuperview()
       _  = IDFA.shared.identifier
       FbBannerViewAd = FBAdView(placementID: FB_BANNERHEADER_ID, adSize: kFBAdSizeHeight250Rectangle, rootViewController: viewController)
       guard let FbBannerViewAd = FbBannerViewAd else { return }
       FbBannerViewAd.frame = CGRect(x: 0,y: 0, width: FbBannerViewAd.frame.size.width, height: FbBannerViewAd.frame.size.height)
       FbBannerViewAd.delegate = self
       contoller = viewController
       //FbBannerViewAd.isHidden = true
       //fbBannerRectangleview = view
       bannerviewConstraint = heightConstaint
       AdsListenerHelper.adsInstanceHelper.delegates = self
       FbBannerViewAd.loadAd()
       view.addSubview(FbBannerViewAd)
   }
}

extension FbBannerRectangleAd: FBAdViewDelegate {
   // Did receive
   func adViewDidLoad(_ adView: FBAdView) {
       FbBannerViewAd?.isHidden = false
       bannerviewConstraint .constant = adView.frame.height
       AdsListenerHelper.adsInstanceHelper.adsLoad(adsView: adView, viewcontroller:contoller,bannerviewConstraint)
   }
   
   func adView(_ adView: FBAdView, didFailWithError error: Error) {
       AdsListenerHelper.adsInstanceHelper.adsFailed(adView,AdsEnum.ADS_ADMOB, error.localizedDescription,contoller,bannerviewConstraint)
       
   }
}


extension FbBannerRectangleAd : AdsListenerProtocol{
   func onAdsLoad(view: UIView, viewController: UIViewController, _ heightConstaint: NSLayoutConstraint) {
       
       view.isHidden = false
       fbBannerRectangleview.isHidden = false
       fbBannerRectangleview.center.x = view.center.x
       fbBannerRectangleview.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
    //   fbBannerRectangleview.addSubview(view)
       
       heightConstaint.constant = view.frame.height
       
       OnBannerAdsIdLoaded.adsInstanceHelper.bannerAdsLoaded()
   }
   
   func onAdsFailed(view: UIView, provider: AdsEnum, error: String, viewController: UIViewController, _ heightConstaint: NSLayoutConstraint) {
       heightConstaint.constant = 0
       view.isHidden = true
       fbBannerRectangleview.isHidden = true
//       OnBannerAdsIdLoaded.adsInstanceHelper.bannerAdsFailed()
       
   }
   
}



var fbinterstitial: FBInterstitialAd?

class FBInitFullAds : NSObject{
    static let shared = FBInitFullAds()
    var cache = Bool()
    var contoller = UIViewController()
    
    func createInitFbFullAd(from viewController: UIViewController,adsid:String,isFromCache:Bool) {
        FB_FULLAD_ID = adsid
        print("adsid\(adsid)")
        if  adsid != "" {
            // FBInterstitialAd = FBInterstitialAd.init(placementID: adsid)
            cache = isFromCache
            contoller = viewController
            
            do{
                fbinterstitial = FBInterstitialAd(placementID: adsid)
                fbinterstitial!.delegate = self
                fbinterstitial?.load()
            }
            catch let error{
                FullAdsListener.adsInstanceHelper.FullAdsFailed(AdsEnum.FULL_ADS_FACEBOOK,error.localizedDescription,viewController)
                
            }
        }
        else {
            FullAdsListener.adsInstanceHelper.FullAdsFailed(AdsEnum.FULL_ADS_FACEBOOK,"FullAds Id null",viewController)
        }
    }
    
    
}

extension FBInitFullAds:FBInterstitialAdDelegate{
    
    func interstitialDidReceiveAd(_ ad: FBInterstitialAd) {
        print("FBADSRecieved\(ad)")
    }
    
    func interstitialAdDidClose(_ interstitialAd: FBInterstitialAd) {
        print("FBinterstitialDidInitCoseAd")
        FullAdsListener.adsInstanceHelper.FullAdsClosed(contoller)
        createInitFbFullAd(from: contoller,adsid: FB_FULLAD_ID,isFromCache: false)
    }
    
    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        print("FBinterstitialDidInitReceiveAd \(cache) \(interstitialAd.isAdValid) \(interstitialAd)")
        if (cache)
        {
            FullAdsListener.adsInstanceHelper.fullAdsLoaded()
        }
    }
    
    
    func interstitialAd(_ interstitialAd: FBInterstitialAd, didFailWithError error: Error) {
        print("FBinterstitialDidInitError\(error)")
        FullAdsListener.adsInstanceHelper.FullAdsFailed(AdsEnum.FULL_ADS_FACEBOOK,error.localizedDescription,contoller)
    }

}

class FbFullAds : NSObject{
    static let shared = FbFullAds()
    var contoller = UIViewController()
    func fbshowFullAd(from viewController: UIViewController,adsid:String) {
        
        FB_FULLAD_ID = adsid
        if adsid != ""{
            contoller = viewController
            if  fbinterstitial != nil {
                if fbinterstitial?.isAdValid ?? true{
                    print("Present")
                    fbinterstitial?.show(fromRootViewController: viewController)
                    
                    FullAdsListener.adsInstanceHelper.fullAdsLoaded()
                    UIApplication.shared.isStatusBarHidden = true
                }
                else{
                    FBInitFullAds.shared.createInitFbFullAd(from: viewController,adsid: adsid,isFromCache: false)
                    FullAdsListener.adsInstanceHelper.FullAdsFailed(AdsEnum.FULL_ADS_FACEBOOK,"Fb FullAd not Ready",contoller)
                    fbinterstitial!.delegate = self
                    print("FB Ad not Ready")
                }
            }
            else {
                FBInitFullAds.shared.createInitFbFullAd(from: viewController,adsid: adsid,isFromCache: false)
                FullAdsListener.adsInstanceHelper.FullAdsFailed(AdsEnum.FULL_ADS_FACEBOOK,"FB Interstitial null",contoller)
            }
        }
        else{
            FullAdsListener.adsInstanceHelper.FullAdsFailed(AdsEnum.FULL_ADS_FACEBOOK,"FB FullAds Id null",contoller)
            
        }
        
    }
    
    
}



extension FbFullAds : FBInterstitialAdDelegate {
    func interstitialDidReceiveAd(_ ad: FBInterstitialAd) {
        print("interstitialDidReceiveAd")
    }
    
    
    func interstitialAd(_ interstitialAd: FBInterstitialAd, didFailWithError error: Error) {
        print("FB Full Ads Failed\(error)")
        
    }
    
}



extension FBNativeLargeAds : FBMediaViewDelegate {
    
    func mediaViewDidLoad(_ mediaView: FBMediaView) {
        
    }
    
    
}




extension FBNativeLargeAds :  FBNativeAdDelegate {
    
    
    func nativeAdDidLoad(_ nativeAd: FBNativeAd) {
        
        
        
        let value = showNativeLargeAd(nativeAd: nativeAd)
        
        if value{
            AdsListenerHelper.adsInstanceHelper.adsLoad(adsView: fbnativeAdView, viewcontroller: controller,viewConstraint)
        }
        else{
            AdsListenerHelper.adsInstanceHelper.adsFailed(fbnativeAdView, AdsEnum.ADS_FACEBOOK, " " , controller,viewConstraint)
        }
    }
    
    func nativeAd(_ nativeAd: FBNativeAd, didFailWithError error: Error) {
        AdsListenerHelper.adsInstanceHelper.adsFailed(fbnativeAdView, AdsEnum.ADS_FACEBOOK, error.localizedDescription, controller,viewConstraint)
    }
    
}

extension FBNativeLargeAds{
    func showNativeLargeAd(nativeAd:FBNativeAd) -> Bool{
        let nibObjects = Bundle.main.loadNibNamed("FbNativeView", owner: nil, options: nil)
        let adView = nibObjects?.first as? FbView
        
        viewConstarint.constant = 55
        
        fbnativeAdView = adView
        nativeView.addSubview(fbnativeAdView)
        
        adView?.translatesAutoresizingMaskIntoConstraints = false
        
        adView?.frame.size.height = nativeView.frame.size.height
        adView?.frame.size.width = nativeView.frame.size.width
        //fbsubView = adView
        let viewDictionary = ["_nativeAdView": fbnativeAdView!]
        controller.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[_nativeAdView]|",
                                                                      options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
        controller.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[_nativeAdView]|",
                                                                      options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
        (fbnativeAdView.fbheaderView)?.text = nativeAd.advertiserName
        (fbnativeAdView.fb_ad_social_context)?.text = nativeAd.socialContext
        (fbnativeAdView.native_ad_body)?.text = nativeAd.bodyText
        (fbnativeAdView.sponsored)?.text = nativeAd.sponsoredTranslation
        nativeAd.registerView(forInteraction: fbnativeAdView.self , mediaView: fbnativeAdView!.native_ad_media, iconImageView: fbnativeAdView!.fbicon, viewController: controller)
        fbnativeAdView.fbChoiceView.nativeAd = nativeAd
        fbnativeAdView.fbButton.setTitle(nativeAd.callToAction, for: .normal)
        fbnativeAdView.fbButton.titleEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        return true
    }
}





class FBNativeLargeAds : NSObject {
    
    var fbnativeAdView: FbView!
    static let shared = FBNativeLargeAds()
    var heightConstraint : NSLayoutConstraint?
    var viewConstraint = NSLayoutConstraint()
    var nativeView = UIView()
    var nativeAd: FBNativeAd?
    // var fbsubView = FbView()
    var controller = UIViewController()
    func getFbNativeLargeAdView(from viewController: UIViewController,nativeAdPlaceholder:UIView,adsid:String,_ heightConstaint:NSLayoutConstraint) {
        progressLoader(nativeAdPlaceholder)
        if adsid != ""{
            
            
            
            //request an ad
            nativeAd = FBNativeAd(placementID: adsid)
            nativeAd?.delegate = self
            nativeAd?.loadAd()
            nativeView = nativeAdPlaceholder
            viewConstraint = heightConstaint
            controller = viewController
            
            
        }
        else{
            viewConstarint.constant = 0
            AdsListenerHelper.adsInstanceHelper.adsFailed(nativeAdPlaceholder, AdsEnum.ADS_FACEBOOK, "NativeAds Id null", viewController,viewConstraint)
        }
    }
    
    
    
    
}




extension FBNativeMediumAds : FBMediaViewDelegate {
    
    func mediaViewDidLoad(_ mediaView: FBMediaView) {
        
    }
    
    
}

extension FBNativeMediumAds :  FBNativeAdDelegate {
    
    
    func nativeAdDidLoad(_ nativeAd: FBNativeAd) {

        let value = showNativeMediumAd(nativeAd: nativeAd)
        
        if value{
            viewConstarint.constant = 55
            AdsListenerHelper.adsInstanceHelper.adsLoad(adsView: fbnativeAdView, viewcontroller: controller,viewConstarint)
        }
        else{
            viewConstarint.constant = 0
            AdsListenerHelper.adsInstanceHelper.adsFailed(fbnativeAdView, AdsEnum.ADS_FACEBOOK, " " , controller,viewConstarint)
        }
        
        
    }
    
    
    func nativeAd(_ nativeAd: FBNativeAd, didFailWithError error: Error) {
        viewConstarint.constant = 0
        AdsListenerHelper.adsInstanceHelper.adsFailed(fbnativeAdView, AdsEnum.ADS_FACEBOOK, error.localizedDescription, controller,viewConstarint)
    }
    

    
}

extension FBNativeMediumAds{
    func showNativeMediumAd(nativeAd:FBNativeAd) -> Bool{
        let nibObjects = Bundle.main.loadNibNamed("FbNativeMediumView", owner: nil, options: nil)
        let adView = nibObjects?.first as? FbNativeMediumView
        adView!.frame.size.height = nativeView.frame.size.height
        adView!.frame.size.width = nativeView.frame.size.width
        
        viewConstarint.constant = 55
        fbnativeAdView = adView
        nativeView.addSubview(fbnativeAdView)
        
        adView!.translatesAutoresizingMaskIntoConstraints = false
        
        
        //fbsubView = adView
        let viewDictionary = ["_nativeAdView": fbnativeAdView!]
        controller.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[_nativeAdView]|",
                                                                      options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
        controller.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[_nativeAdView]|",
                                                                      options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
        (fbnativeAdView.fbmediumheaderView)?.text = nativeAd.advertiserName
        (fbnativeAdView.fbmedium_ad_social_context)?.text = nativeAd.socialContext
        (fbnativeAdView.nativemedium_ad_body)?.text = nativeAd.bodyText
        (fbnativeAdView.mediumsponsored)?.text = nativeAd.sponsoredTranslation
        nativeAd.registerView(forInteraction: fbnativeAdView.self , mediaView: fbnativeAdView!.nativemedium_ad_media, iconImageView: fbnativeAdView!.fbmediumicon, viewController: controller)
        fbnativeAdView.fbmediumChoiceView.nativeAd = nativeAd
        fbnativeAdView.fbmediumButton.setTitle(nativeAd.callToAction, for: .normal)
        fbnativeAdView.fbmediumButton.titleEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        return true
    }
}





class FBNativeMediumAds : NSObject {
    
    var fbnativeAdView: FbNativeMediumView!
    static let shared = FBNativeMediumAds()
    var heightConstraint : NSLayoutConstraint?
    var viewConstarint = NSLayoutConstraint()
    var nativeView = UIView()
    var nativeAd: FBNativeAd?
    // var fbsubView = FbView()
    var controller = UIViewController()
    func getFbNativeMediumAdView(from viewController: UIViewController,nativeAdPlaceholder:UIView,adsid:String, _ heightConstarint: NSLayoutConstraint) {
        progressLoader(nativeAdPlaceholder)
        if adsid != "" {
            
            
            //request an ad
            nativeAd = FBNativeAd(placementID: adsid)
            nativeAd?.delegate = self
            nativeAd?.loadAd()
            nativeView = nativeAdPlaceholder
            controller = viewController
            viewConstarint = heightConstarint
            
            
        }
        else{
            viewConstarint.constant = 0
            AdsListenerHelper.adsInstanceHelper.adsFailed(nativeAdPlaceholder, AdsEnum.ADS_FACEBOOK, "NativeAds Id null", viewController,viewConstarint)
        }
    }
     
}


