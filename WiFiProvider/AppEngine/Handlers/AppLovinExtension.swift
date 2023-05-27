//
//  AppLovinExtension.swift
//  M24-PoleShare
//
//  Created by Poornima on 13/09/22.
//

import Foundation
import AppLovinSDK

final class AppLovinBannerAd:NSObject {
    
    static let shared = AppLovinBannerAd()
    var adView: MAAdView!
    var viewConstarint = NSLayoutConstraint()
    var viewController = UIViewController()
    var appLovinBannerView = UIView()
    func getAppLovinBanner(from viewController: UIViewController, at position: BannerPosition = .bottom,banner_id:String,_ view:UIView,_ heightConstarint:NSLayoutConstraint) {
        print("Applovinnn")
        bannerPosition = position
        APPLOVIN_BANNERHEADER_ID = banner_id
        loadAppLovinBannerAd(from: viewController, view, heightConstarint)
    }
    func loadAppLovinBannerAd(from viewController: UIViewController,_ view:UIView,_ heightConstarint:NSLayoutConstraint) {
        self.viewController = viewController
        appLovinBannerView = view
        viewConstarint = heightConstarint
        adView = MAAdView(adUnitIdentifier: "934459ef9d501528")
        
        adView.delegate = self
        print("adView\(String(describing: adView))")
        
        let height: CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 90 : 65
        
        let width: CGFloat = UIScreen.main.bounds.width
        
        adView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        heightConstarint.constant = adView.frame.height
        
        view.addSubview(adView)
        
        // Load the first ad
        adView.loadAd()
        
        if (adView == nil) {
            
            AdsListenerHelper.adsInstanceHelper.adsFailed(appLovinBannerView,AdsEnum.ADS_APP_LOVIN, "App Lovin Banner Ad is nil",self.viewController,viewConstarint)
        }else{
            
        }
        
        AdsListenerHelper.adsInstanceHelper.delegates = self
    }
}
extension AppLovinBannerAd : AdsListenerProtocol{
    func onAdsLoad(view: UIView, viewController: UIViewController, _ heightConstaint: NSLayoutConstraint) {
        
        if view.frame.height > 0{
            OnBannerAdsIdLoaded.adsInstanceHelper.bannerAdsLoaded()
        }
    }
    
    func onAdsFailed(view: UIView, provider: AdsEnum, error: String, viewController: UIViewController, _ heightConstaint: NSLayoutConstraint) {
        appLovinBannerView.isHidden = true
        viewConstarint.constant = 0
        OnBannerAdsIdLoaded.adsInstanceHelper.bannerAdsFailed()
    }
    
}

extension AppLovinBannerAd: MAAdViewAdDelegate {
    func didExpand(_ ad: MAAd) {
        print("didExpand")
        
    }
    
    func didCollapse(_ ad: MAAd) {
        print("didCollapse")
    }
    
    func didLoad(_ ad: MAAd) {
        print("didLoad")
        adView.loadAd()
        
    }
    
    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        print("didFailToLoadAd\(error)")
        adView.loadAd()
    }
    
    func didDisplay(_ ad: MAAd) {
        print("didDisplayBannerAd")
    }
    
    func didHide(_ ad: MAAd) {
        print("didHide")
    }
    
    func didClick(_ ad: MAAd) {
        print("didClick")
    }
    
    func didFail(toDisplay ad: MAAd, withError error: MAError) {
        print("didExpand")
    }
    
    
}

var interstitialAd: MAInterstitialAd?
var currentAd : MAAd!
class AppLovinInitFullAds : NSObject {
    static let shared = AppLovinInitFullAds()
    var cache = Bool()
    var contoller = UIViewController()
    
    
    func loadAppLovinFullAds(from viewController: UIViewController,adsid:String,isFromCache:Bool) {
        cache = isFromCache
        contoller = viewController
        if  adsid != "" {
            APPLOVIN_FULLAD_ID = "cf28623a9264d7f7"
            
            //            if interstitialAd == nil{
            interstitialAd = MAInterstitialAd(adUnitIdentifier: APPLOVIN_FULLAD_ID)
            
            interstitialAd?.load()
            interstitialAd?.delegate = self
            
            //            }
            //            else{
            //                print("Applovin FullAds Id null")
            //                FullAdsListener.adsInstanceHelper.FullAdsFailed(AdsEnum.FULL_ADS_APPLOVIN,"Applovin FullAds Id null",viewController)
            //
            //            }
            
            print("App lovin load full ads")
            
        }
        else {
            FullAdsListener.adsInstanceHelper.FullAdsFailed(AdsEnum.FULL_ADS_APPLOVIN,"Applovin FullAds Id null",viewController)
        }
    }
}


extension AppLovinInitFullAds : MAAdDelegate {
    func didExpand(_ ad: MAAd) {
        
    }
    
    func didCollapse(_ ad: MAAd) {
        
    }
    
    func didLoad(_ ad: MAAd) {
        currentAd = ad
        print("currentAd\(currentAd)")
        //        AppLovinFullAds.shared.appLovinshowFullAd(from: contoller, adsid: APPLOVIN_FULLAD_ID, isFromSplash: false)
        
        if cache{
            FullAdsListener.adsInstanceHelper.fullAdsLoaded()
        }
        
    }
    
    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        print("Applovin error\(error.description)")
        if cache{
            FullAdsListener.adsInstanceHelper.FullAdsFailed(AdsEnum.FULL_ADS_APPLOVIN,error.description,contoller)
        }
        
    }
    
    func didDisplay(_ ad: MAAd) {
        
    }
    
    func didHide(_ ad: MAAd) {
        // interstitialAd.load()
        //        FullAdsListener.adsInstanceHelper.FullAdsClosed(contoller)
        
        print("APPLOVIN_FULLAD_ID\(APPLOVIN_FULLAD_ID)")
        FullAdsListener.adsInstanceHelper.FullAdsClosed(contoller)
        loadAppLovinFullAds(from: contoller,adsid: APPLOVIN_FULLAD_ID,isFromCache: false)
    }
    
    func didClick(_ ad: MAAd) {
        
    }
    
    func didFail(toDisplay ad: MAAd, withError error: MAError) {
        
        // interstitialAd.load()
    }
    
}
class AppLovinFullAds : NSObject {
    static let shared = AppLovinFullAds()
    
    var contoller = UIViewController()
    var isFromSplash = Bool()
    func appLovinshowFullAd(from viewController: UIViewController,adsid:String,isFromSplash:Bool) {
        print("App Show lovin full ads")
        
        self.isFromSplash = isFromSplash
        self.contoller = viewController
        APPLOVIN_FULLAD_ID = adsid
        
        print("APPLOVIN_FULLAD_ID\(interstitialAd?.isReady) \(currentAd)")
        if currentAd != nil{
            print("interstitialAdddd\(interstitialAd?.isReady)")
            
            interstitialAd?.show()
            
            interstitialAd?.delegate = self
            FullAdsListener.adsInstanceHelper.fullAdsLoaded()
            
        }else{
            
            
            if !isFromSplash{
                print("APPLOVIN_FULLAD_IDqqq\(APPLOVIN_FULLAD_ID)")
                AppLovinInitFullAds.shared.loadAppLovinFullAds(from: viewController, adsid: APPLOVIN_FULLAD_ID, isFromCache: false)
            }
            //   FullAdsListener.adsInstanceHelper.FullAdsFailed(AdsEnum.FULL_ADS_APPLOVIN,"Ads is null",viewController)
            
            
        }
        
    }
}


extension AppLovinFullAds : MAAdDelegate {
    func didExpand(_ ad: MAAd) {
        
    }
    
    func didCollapse(_ ad: MAAd) {
        
    }
    
    func didLoad(_ ad: MAAd) {
        
        print("Applovin did load")
        
    }
    
    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        FullAdsListener.adsInstanceHelper.FullAdsFailed(AdsEnum.FULL_ADS_APPLOVIN,error.description,contoller)
        print("faileddd\(error.description)")
        //        interstitialAd.load()
    }
    
    func didDisplay(_ ad: MAAd) {
        
    }
    
    func didHide(_ ad: MAAd) {
        //        if !self.isFromSplash{
        AppLovinInitFullAds.shared.loadAppLovinFullAds(from: contoller, adsid: APPLOVIN_FULLAD_ID, isFromCache: false)
        //        }
        FullAdsListener.adsInstanceHelper.FullAdsClosed(contoller)
    }
    
    func didClick(_ ad: MAAd) {
        
    }
    
    func didFail(toDisplay ad: MAAd, withError error: MAError) {
        FullAdsListener.adsInstanceHelper.FullAdsFailed(AdsEnum.FULL_ADS_APPLOVIN,error.description,contoller)
        //        interstitialAd.load()
    }
    
}

class AppLovinNativeMediumAd: NSObject {
    var nativeAdView: MANativeAdView!
    static let shared = AppLovinNativeMediumAd()
    var heightConstraint : NSLayoutConstraint?
    var viewConstarint = NSLayoutConstraint()
    private var nativeAdLoader: MANativeAdLoader? = nil
    private var nativeAd: MAAd?
    var controller = UIViewController()
    var admobMediumView = UIView()
    
    @IBOutlet weak var nativeAdContainerView: UIView!
    //var adLoader: GADAdLoader!
    func getAppLovinNativeMediumAdView(from viewController: UIViewController,nativeAdPlaceholder:UIView,adsid:String,_ heightConstarint:NSLayoutConstraint) {
        progressLoader(nativeAdPlaceholder)
        nativeAdLoader = MANativeAdLoader(adUnitIdentifier:adsid)
        if adsid != ""{
            print("adsid\(adsid)")
            let nativeAdViewNib = UINib(nibName: "NativeManualAdView", bundle: Bundle.main)
            nativeAdView = nativeAdViewNib.instantiate(withOwner: nil, options: nil).first! as! MANativeAdView?
            nativeAdLoader?.loadAd(into: nativeAdView)
            
            
            let adViewBinder = MANativeAdViewBinder(builderBlock: { (builder) in
                builder.titleLabelTag = 1001
                builder.advertiserLabelTag = 1002
                builder.bodyLabelTag = 1003
                builder.iconImageViewTag = 1004
                builder.optionsContentViewTag = 1005
                builder.mediaContentViewTag = 1006
                builder.callToActionButtonTag = 1007
            })
            nativeAdView.bindViews(with: adViewBinder)
            nativeAdLoader?.nativeAdDelegate = self
            controller = viewController
            viewConstarint = heightConstarint
            admobMediumView = nativeAdPlaceholder
            
            
        }
        else{
            viewConstarint.constant = 0
            AdsListenerHelper.adsInstanceHelper.adsFailed(nativeAdPlaceholder, AdsEnum.ADS_ADMOB, "NativeAds Id null", viewController,viewConstarint)
        }
    }
    
    
}
extension AppLovinNativeMediumAd: MANativeAdDelegate {
    func didLoadNativeAd(_ nativeAdView: MANativeAdView?, for ad: MAAd) {
        
        print("didLoadNativeAd")
        nativeAd = ad
        
        
        //self.nativeAdView = adView
        
        admobMediumView.addSubview(nativeAdView!)
        nativeAdView!.translatesAutoresizingMaskIntoConstraints = false
        
        
        let viewDictionary = ["_nativeAdView": nativeAdView!]
        controller.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[_nativeAdView]|",
                                                                      options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
        controller.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[_nativeAdView]|",
                                                                      options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
        
        
        heightConstraint?.isActive = false
        
        
        
        
        
        AdsListenerHelper.adsInstanceHelper.adsLoad(adsView: nativeAdView!, viewcontroller: controller,viewConstarint)
    }
    
    func didFailToLoadNativeAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        print("errorrrr\(error.description)")
    }
    
    func didClickNativeAd(_ ad: MAAd) {
        
    }
    
    
}

class AppLovinBannerRectangleAd: NSObject {
    static let shared = AppLovinBannerRectangleAd()
    
    var isRemoved = false {
        didSet {
            guard isRemoved else { return }
            removeBanner()
        }
    }
    var controller = UIViewController()
    var adView: MAAdView!
    var viewConstarint = NSLayoutConstraint()
    
    
    private override init() { }
    
    
    func showAppLovinBannerRectangle(from viewController: UIViewController, at position: BannerPosition = .bottom,banner_id:String,_ view:UIView,_ heightConstarint:NSLayoutConstraint) {
        
        guard !isRemoved else { return }
        bannerPosition = position
        APPLOVIN_BANNERRECTANGLE_ID = banner_id
        loadAppLovinBannerRectangleAd(from: viewController,view,heightConstarint)
    }
    
    
    
    // MARK: - Remove Banner
    
    /// Remove banner ads
    func removeBanner() {
        //       bannerViewAd?.delegate = nil
        //       bannerViewAd?.removeFromSuperview()
        //       bannerViewAd = nil
    }
    
    func updateOrientation() {
        guard let bannerViewAd = adView else { return }
        // bannerViewAd.adSize = bannerSize
        // setBannerToOnScreenPosition(bannerViewAd, from: bannerViewAd.rootViewController)
    }
}

// MARK: - Requesting Ad
extension AppLovinBannerRectangleAd {
    
    func loadAppLovinBannerRectangleAd(from viewController: UIViewController,_ view:UIView,_ heightConstarint:NSLayoutConstraint) {
        
        
        adView = MAAdView(adUnitIdentifier: APPLOVIN_BANNERRECTANGLE_ID, adFormat: MAAdFormat.mrec)
        adView.delegate = self
        
        // MREC width and height are 300 and 250 respectively, on iPhone and iPad
        let height: CGFloat = 250
        let width: CGFloat = 300
        
        adView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        heightConstarint.constant = adView.frame.height
        // Center the MREC
        adView.center.x = view.center.x
        //view.addSubview(adView)
        view.addSubview(adView)
        // Load the first ad
        adView.loadAd()
        
    }
    
}


// MARK: - GADBannerViewDelegate
extension AppLovinBannerRectangleAd: MAAdViewAdDelegate {
    func didExpand(_ ad: MAAd) {
        
    }
    
    func didCollapse(_ ad: MAAd) {
        
    }
    
    func didLoad(_ ad: MAAd) {
        print("didLOAd")
        AdsListenerHelper.adsInstanceHelper.adsLoad(adsView: adView, viewcontroller: controller,viewConstarint)
    }
    
    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        print("didFailToLoadAd\(error)")
        AdsListenerHelper.adsInstanceHelper.adsFailed(rectangledelegateadmobBannerview,AdsEnum.ADS_APP_LOVIN, error.description,controller,viewConstarint)
    }
    
    func didDisplay(_ ad: MAAd) {
        
    }
    
    func didHide(_ ad: MAAd) {
        
    }
    
    func didClick(_ ad: MAAd) {
        
    }
    
    func didFail(toDisplay ad: MAAd, withError error: MAError) {
        print("didFailToLoadAd\(error)")
    }
    
    
    
}
