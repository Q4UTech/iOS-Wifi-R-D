////
////  AdMobExtension.swift
////  App Engine
////
////  Created by Quantum_MAC_7 on 23/03/20.
////  Copyright © 2020 Pulkit Babbar. All rights reserved.
////
//
import Foundation
import UIKit
import GoogleMobileAds


//NativeAd
extension AdmobNativeLargeAd : GADVideoControllerDelegate {

  func videoControllerDidEndVideoPlayback(_ videoController: GADVideoController) {
   // videoStatusLabel.text = "Video playback has ended."
  }
}

extension AdmobNativeLargeAd : GADAdLoaderDelegate {

  func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
    print("\(adLoader) failed with error: \(error.localizedDescription)")
     AdsListenerHelper.adsInstanceHelper.adsFailed(nativeAdView, AdsEnum.ADS_ADMOB,error.localizedDescription,controller ,viewConstarint!)
  
  }
    
    
}

extension AdmobNativeLargeAd : GADNativeAdLoaderDelegate {

  func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
    
    let nibObjects = Bundle.main.loadNibNamed("UnifiedNativeAdView", owner: nil, options: nil)
    let adView = nibObjects?.first as? GADNativeAdView
            viewConstarint!.constant = 55
           nativeAdView = adView
           adMobNativeView.addSubview(nativeAdView)
           nativeAdView.translatesAutoresizingMaskIntoConstraints = false
         
    
           let viewDictionary = ["_nativeAdView": nativeAdView!]
        controller.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[_nativeAdView]|",
                                                                   options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
       controller.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[_nativeAdView]|",
                                                                   options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
    
    nativeAdView.nativeAd = nativeAd

    nativeAd.delegate = self

   
    heightConstraint?.isActive = false

   
    (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
    nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent

   
    let mediaContent = nativeAd.mediaContent
    if mediaContent.hasVideoContent {
     
       mediaContent.videoController.delegate = self
     
    }
    else {
    
    }

   
    if let mediaView = nativeAdView, nativeAd.mediaContent.aspectRatio > 0 {
      heightConstraint = NSLayoutConstraint(item: mediaView,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: mediaView,
                                            attribute: .width,
                                            multiplier: CGFloat(1 / nativeAd.mediaContent.aspectRatio),
                                            constant: 0)
      heightConstraint?.isActive = true
    }

   
    (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
    nativeAdView.bodyView?.isHidden = nativeAd.body == nil

    (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
    nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil

    (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
    nativeAdView.iconView?.isHidden = nativeAd.icon == nil

    (nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(from:nativeAd.starRating)
    nativeAdView.starRatingView?.isHidden = nativeAd.starRating == nil

    (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
    nativeAdView.storeView?.isHidden = nativeAd.store == nil

    (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
    nativeAdView.priceView?.isHidden = nativeAd.price == nil

    (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
    nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil

   
    nativeAdView.callToActionView?.isUserInteractionEnabled = false
    
    AdsListenerHelper.adsInstanceHelper.adsLoad(adsView: nativeAdView, viewcontroller: controller, viewConstarint!)
  }
    
    func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
      guard let rating = starRating?.doubleValue else {
        return nil
      }
      if rating >= 5 {
        return UIImage(named: "stars_5")
      } else if rating >= 4.5 {
        return UIImage(named: "stars_4_5")
      } else if rating >= 4 {
        return UIImage(named: "stars_4")
      } else if rating >= 3.5 {
        return UIImage(named: "stars_3_5")
      } else {
        return nil
      }
    }
    
    
 
 }
class AdmobNativeLargeAd: NSObject, GADNativeAdDelegate{
    var nativeAdView: GADNativeAdView!
   static let shared = AdmobNativeLargeAd()
    var heightConstraint : NSLayoutConstraint?
    var viewConstarint : NSLayoutConstraint?
   var controller = UIViewController()
    var adMobNativeView = UIView()
     var adLoader: GADAdLoader!
    func getAdMobNativeAdView(from viewController: UIViewController,nativeAdPlaceholder:UIView,adsid:String,_ heightConstarint:NSLayoutConstraint) {
       progressLoader(nativeAdPlaceholder)
        if adsid != ""{
            print("AdMobNativeId\(adsid)")
        
          adLoader = GADAdLoader(adUnitID: adsid, rootViewController: viewController,
                                     adTypes: [ .native ], options: nil)
              adLoader.delegate = self
              adLoader.load(AdsHelper.createRequest())
              controller = viewController
            viewConstarint = heightConstarint
            adMobNativeView = nativeAdPlaceholder
}
        else{
            viewConstarint!.constant = 0
            AdsListenerHelper.adsInstanceHelper.adsFailed(nativeAdPlaceholder, AdsEnum.ADS_ADMOB, "NativeAds Id null", viewController,viewConstarint!)
        }
    }
}
extension AdmobNativeMediumAd : GADVideoControllerDelegate {

  func videoControllerDidEndVideoPlayback(_ videoController: GADVideoController) {
   // videoStatusLabel.text = "Video playback has ended."
  }
}

extension AdmobNativeMediumAd : GADAdLoaderDelegate {

  func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
    print("\(adLoader) failed with error: \(error.localizedDescription)")
      viewConstarint.constant = 0
      if nativeAdView != nil{
          AdsListenerHelper.adsInstanceHelper.adsFailed(nativeAdView, AdsEnum.ADS_ADMOB,error.localizedDescription,controller,viewConstarint)
      }
      
  }
    
}

extension AdmobNativeMediumAd : GADNativeAdLoaderDelegate ,GADNativeAdDelegate{
   
    

  func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
    
     let nibObjects = Bundle.main.loadNibNamed("UnifiedNativeMediumAdView", owner: nil, options: nil)
    let adView = nibObjects?.first as? GADNativeAdView
        
           viewConstarint.constant = 55
           nativeAdView = adView
           admobMediumView.addSubview(nativeAdView)
           nativeAdView.translatesAutoresizingMaskIntoConstraints = false
         
    
           let viewDictionary = ["_nativeAdView": nativeAdView!]
        controller.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[_nativeAdView]|",
                                                                   options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
       controller.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[_nativeAdView]|",
                                                                   options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
    nativeAdView.nativeAd = nativeAd

      nativeAd.delegate = self

   
    heightConstraint?.isActive = false

   
//    (nativeAdView.contentad_headline)?.text = nativeAd.headline
    nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
    let mediaContent = nativeAd.mediaContent
    if mediaContent.hasVideoContent {
       mediaContent.videoController.delegate = self
    }
    else {
    
    }
      
    if let mediaView = nativeAdView, nativeAd.mediaContent.aspectRatio > 0 {
      heightConstraint = NSLayoutConstraint(item: mediaView,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: mediaView,
                                            attribute: .width,
                                            multiplier: CGFloat(1 / nativeAd.mediaContent.aspectRatio),
                                            constant: 0)
      heightConstraint?.isActive = true
    }

      (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
      nativeAdView.bodyView?.isHidden = nativeAd.body == nil

      (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
      nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil

      (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
      nativeAdView.iconView?.isHidden = nativeAd.icon == nil
      
      (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
      nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil

      nativeAdView.callToActionView?.isUserInteractionEnabled = false

    
    AdsListenerHelper.adsInstanceHelper.adsLoad(adsView: nativeAdView, viewcontroller: controller,viewConstarint)
  }
    

    
    
    func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        print("Check Native Ad Click")
    }
    
 
 }

class AdmobNativeMediumAd: NSObject{
    var nativeAdView: GADNativeAdView!
   static let shared = AdmobNativeMediumAd()
    var heightConstraint : NSLayoutConstraint?
    var viewConstarint = NSLayoutConstraint()
var controller = UIViewController()
    var admobMediumView = UIView()
     var adLoader: GADAdLoader!
    func getAdMobNativeMediumAdView(from viewController: UIViewController,nativeAdPlaceholder:UIView,adsid:String,_ heightConstarint:NSLayoutConstraint) {
         progressLoader(nativeAdPlaceholder)
        if adsid != ""{
        print("adsid\(adsid)")
              adLoader = GADAdLoader(adUnitID: adsid, rootViewController: viewController,
                                     adTypes: [ .native ], options: nil)
              adLoader.delegate = self
              adLoader.load(AdsHelper.createRequest())
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

protocol sampleDataPass : class {
   
}


 weak var delegate : AdmobBannerAdDelegate? = nil
/// SwiftyAdsDelegate
protocol AdmobBannerAdDelegate: class {
    /// SwiftyAd did open
    func swiftyAdDidOpen(_ swiftyAd: ADMobBannerAd)
    /// SwiftyAd did close
    func swiftyAdDidClose(_ swiftyAd: ADMobBannerAd)
    /// SwiftyAd did reward user
    func swiftyAd(_ swiftyAd: ADMobBannerAd, didRewardUserWithAmount rewardAmount: Int)
    

}
/**
 SwiftyAd

 A helper class to manage adverts from AdMob.
 */
final class ADMobBannerAd: NSObject {

   

    // MARK: - Static Properties

    /// Shared instance
    static let shared = ADMobBannerAd()

    // MARK: - Properties

    /// Delegates
    weak var delegate: AdmobBannerAdDelegate?
    
    /// Remove ads
    var isRemoved = false {
        didSet {
            guard isRemoved else { return }
            removeBanner()
        }
    }


    /// Ads
    fileprivate var bannerViewAd: GADBannerView?
   

    /// Test Ad Unit IDs. Will get set to real ID in setup method
    fileprivate var bannerViewAdUnitID = ADMOB_BANNERHEADER_ID
 
    
    /// Interval counter
    private var intervalCounter = 0

    /// Reward amount backup
    fileprivate var rewardAmountBackup = 1

    /// Banner position
   
 
    /// Banner size
//    fileprivate var bannerSize: GADAdSize {
//        let isLandscape = UIApplication.shared.statusBarOrientation.isLandscape
//        return isLandscape ? kGADAdSizeSmartBannerLandscape : kGADAdSizeSmartBannerPortrait
//    }

    
   

    // MARK: - Init

    /// Init
    private override init() { }


    func showAdMobBanner(from viewController: UIViewController, at position: BannerPosition = .bottom,banner_id:String,_ view:UIView,_ heightConstarint:NSLayoutConstraint) {
        guard !isRemoved else { return }
        bannerPosition = position
        ADMOB_BANNERHEADER_ID = banner_id
        loadAdmobBannerAd(from: viewController,view,heightConstarint)
    }


   
    // MARK: - Remove Banner

    /// Remove banner ads
    func removeBanner() {
        print("Removed banner ad")

        bannerViewAd?.delegate = nil
        bannerViewAd?.removeFromSuperview()
        bannerViewAd = nil
    }

    func updateOrientation() {
        guard let bannerViewAd = bannerViewAd else { return }
       // bannerViewAd.adSize = bannerSize
        setBannerToOnScreenPosition(bannerViewAd, from: bannerViewAd.rootViewController)
    }
}
var admobBannerview = UIView()
var viewConstarint = NSLayoutConstraint()
// MARK: - Requesting Ad

extension ADMobBannerAd {
    
    func loadAdmobBannerAd(from viewController: UIViewController,_ view:UIView,_ heightConstarint:NSLayoutConstraint) {
               bannerViewAd?.removeFromSuperview()
               bannerViewAd = GADBannerView(adSize: GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width))
               guard let bannerViewAd = bannerViewAd else { return }
               bannerViewAd.adUnitID = ADMOB_BANNERHEADER_ID
               bannerViewAd.delegate = self
               AdsListenerHelper.adsInstanceHelper.delegates = self
               bannerViewAd.rootViewController = viewController
               admobBannerview = view
               viewConstarint = heightConstarint
              // setBannerToOffScreenPosition(bannerViewAd, from: viewController)
               view.addSubview(bannerViewAd)
               bannerViewAd.load(AdsHelper.createRequest())
               
          }
   
    

    /// Load banner ad

}


// MARK: - GADBannerViewDelegate
extension ADMobBannerAd: GADBannerViewDelegate {

    // Did receive
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
       
         bannerView.isHidden = false
        viewConstarint.constant = bannerView.frame.height
       AdsListenerHelper.adsInstanceHelper.adsLoad(adsView: bannerView,viewcontroller:bannerView.rootViewController!,viewConstarint)
        
    }

    // Will present
    func adViewWillPresentScreen(_ bannerView: GADBannerView) { // gets called only in release mode
        print("AdMob banner clicked")
        delegate?.swiftyAdDidOpen(self)
    }

    // Will dismiss
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("AdMob banner about to be closed")
    }

    // Did dismiss
    func adViewDidDismissScreen(_ bannerView: GADBannerView) { // gets called in only release mode
        print("AdMob banner closed")
        delegate?.swiftyAdDidClose(self)
    }

    // Will leave application
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("AdMob banner will leave application")
        delegate?.swiftyAdDidOpen(self)
    }

    // Did fail to receive
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print(error.localizedDescription)
        AdsListenerHelper.adsInstanceHelper.adsFailed(bannerView,AdsEnum.ADS_ADMOB, error.localizedDescription,bannerView.rootViewController!,viewConstarint)
  
    }
}


extension ADMobBannerAd : AdsListenerProtocol{
    func onAdsLoad(view: UIView, viewController: UIViewController, _ heightConstaint: NSLayoutConstraint) {
        admobBannerview.isHidden = false
                 admobBannerview.center.x = view.center.x
//                 admobBannerview.center.y = view.center.y/2
       
                view.center = CGPoint(x: admobBannerview.frame.size.width  / 2,
                                      y: view.frame.height/2)
//                 admobBannerview.addSubview(view)
       
        if view.frame.height > 0{
            
            OnBannerAdsIdLoaded.adsInstanceHelper.bannerAdsLoaded()
        }
        
    }
    
    func onAdsFailed(view: UIView, provider: AdsEnum, error: String, viewController: UIViewController, _ heightConstaint: NSLayoutConstraint) {
        admobBannerview.isHidden = true
               viewConstarint.constant = 0
        OnBannerAdsIdLoaded.adsInstanceHelper.bannerAdsFailed()
    }
    
}


 class ADMobAdaptiveBannerAd: NSObject {
    static let shared = ADMobAdaptiveBannerAd()

    var isRemoved = false {
        didSet {
            guard isRemoved else { return }
            removeBanner()
        }
    }

    fileprivate var adaptiveBannerViewAd: GADBannerView?
    fileprivate var bannerViewAdUnitID = ADMOB_ADAPTIVE_BANNERHEADER_ID
    private var intervalCounter = 0
    fileprivate var rewardAmountBackup = 1


    private override init() { }


    func showAdMobAdaptiveBanner(from viewController: UIViewController, at position: BannerPosition = .bottom,banner_id:String,_ view:UIView,_ heightConstarint:NSLayoutConstraint) {
        guard !isRemoved else { return }
        bannerPosition = position
        ADMOB_ADAPTIVE_BANNERHEADER_ID = banner_id
        loadAdmobAdaptiveBannerAd(from: viewController,view,heightConstarint)
    }


   
    // MARK: - Remove Banner

    /// Remove banner ads
    func removeBanner() {
        print("Removed banner ad")

        adaptiveBannerViewAd?.delegate = nil
        adaptiveBannerViewAd?.removeFromSuperview()
        adaptiveBannerViewAd = nil
    }

    func updateOrientation() {
        print("AdMob banner orientation updated")
        guard let bannerViewAd = adaptiveBannerViewAd else { return }
       // bannerViewAd.adSize = bannerSize
        setBannerToOnScreenPosition(bannerViewAd, from: bannerViewAd.rootViewController)
    }
}
var adaptivedelegateadmobBannerview = UIView()
var adaptivedelegateviewConstarint = NSLayoutConstraint()
// MARK: - Requesting Ad
extension ADMobAdaptiveBannerAd {
    
    func loadAdmobAdaptiveBannerAd(from viewController: UIViewController,_ view:UIView,_ heightConstarint:NSLayoutConstraint) {
        print("AdMob Adaptive banner ad loading...\(ADMOB_ADAPTIVE_BANNERHEADER_ID) \(heightConstarint)")
        
       
        DispatchQueue.main.async {
            self.adaptiveBannerViewAd?.removeFromSuperview()
            self.adaptiveBannerViewAd = GADBannerView(adSize: GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width))
            guard let bannerViewAd = self.adaptiveBannerViewAd else { return }
            bannerViewAd.adUnitID = ADMOB_ADAPTIVE_BANNERHEADER_ID
            bannerViewAd.delegate = self
            bannerViewAd.rootViewController = viewController
            adaptivedelegateadmobBannerview = view
            adaptivedelegateviewConstarint = heightConstarint
            view.addSubview(bannerViewAd)
     
            bannerViewAd.load(AdsHelper.createRequest())
        }
    
          }
   }

// MARK: - GADBannerViewDelegate
extension ADMobAdaptiveBannerAd: GADBannerViewDelegate {

    // Did receive
//    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
//
//         bannerView.isHidden = false
//
//        print("AdmobBannerAds\(bannerView) adaptivedelegateadmobBannerview  \(adaptivedelegateadmobBannerview)  \(bannerView.rootViewController)")
//        print("Banner adapter class name: \(bannerView.responseInfo?.adNetworkClassName!)")
//        if bannerView.rootViewController != nil{
//            AdsListenerHelper.adsInstanceHelper.adsLoad(adsView: bannerView,viewcontroller:bannerView.rootViewController!,adaptivedelegateviewConstarint)
//        }
//
//
//        adaptivedelegateadmobBannerview.isHidden = false
//        adaptivedelegateviewConstarint.constant = bannerView.frame.height
//        adaptivedelegateadmobBannerview.addSubview(bannerView)
//
//
//                if bannerView.frame.height > 0{
//
//                    OnBannerAdsIdLoaded.adsInstanceHelper.bannerAdsLoaded()
//                }
////            }
////
////        }
////
//    }
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.isHidden = false
       if bannerView.rootViewController != nil{
           AdsListenerHelper.adsInstanceHelper.adsLoad(adsView: bannerView,viewcontroller:bannerView.rootViewController!,adaptivedelegateviewConstarint)
       }
       print("Admob Banner Ad Load_ \(bannerView)")
       
       adaptivedelegateadmobBannerview.isHidden = false
       adaptivedelegateviewConstarint.constant = bannerView.frame.height
        
       
//       adaptivedelegateadmobBannerview.addSubview(bannerView)

      
               if bannerView.frame.height > 0{

                   OnBannerAdsIdLoaded.adsInstanceHelper.bannerAdsLoaded()
               }
    }

    // Will present
    func adViewWillPresentScreen(_ bannerView: GADBannerView) { // gets called only in release mode
    }

    // Will dismiss
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        
       
    }

  

    // Did fail to receive
  
    
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("Banner Adsfailed")
         //  admobBannerview.isHidden = true
          if bannerView.rootViewController != nil{
              AdsListenerHelper.adsInstanceHelper.adsFailed(adaptivedelegateadmobBannerview,AdsEnum.ADS_ADMOB, error.localizedDescription,bannerView.rootViewController!,adaptivedelegateviewConstarint)
          }

          adaptivedelegateadmobBannerview.isHidden = true
          adaptivedelegateviewConstarint.constant = 0

          OnBannerAdsIdLoaded.adsInstanceHelper.bannerAdsFailed()
    }
}





class AdMobBannerRectangleAd: NSObject {
   static let shared = AdMobBannerRectangleAd()

   var isRemoved = false {
       didSet {
           guard isRemoved else { return }
           removeBanner()
       }
   }

   fileprivate var bannerViewAd: GADBannerView?
   fileprivate var bannerViewAdUnitID = ADMOB_BANNERRECTANGLE_ID
   private var intervalCounter = 0
   fileprivate var rewardAmountBackup = 1


   private override init() { }


   func showAdMobBannerRectangle(from viewController: UIViewController, at position: BannerPosition = .bottom,banner_id:String,_ view:UIView,_ heightConstarint:NSLayoutConstraint) {
       
       guard !isRemoved else { return }
       bannerPosition = position
       ADMOB_BANNERRECTANGLE_ID = banner_id
       loadAdmobBannerRectangleAd(from: viewController,view,heightConstarint)
   }


  
   // MARK: - Remove Banner

   /// Remove banner ads
   func removeBanner() {
       bannerViewAd?.delegate = nil
       bannerViewAd?.removeFromSuperview()
       bannerViewAd = nil
   }

   func updateOrientation() {
       guard let bannerViewAd = bannerViewAd else { return }
      // bannerViewAd.adSize = bannerSize
       setBannerToOnScreenPosition(bannerViewAd, from: bannerViewAd.rootViewController)
   }
}
var rectangledelegateadmobBannerview = UIView()
var rectangledelegateviewConstarint = NSLayoutConstraint()
// MARK: - Requesting Ad
extension AdMobBannerRectangleAd {
   
   func loadAdmobBannerRectangleAd(from viewController: UIViewController,_ view:UIView,_ heightConstarint:NSLayoutConstraint) {
              print("AdMob banner ad loading...\(bannerViewAdUnitID) \(heightConstarint)")
             
              bannerViewAd?.removeFromSuperview()
              bannerViewAd = GADBannerView(adSize: GADAdSizeMediumRectangle)
              guard let bannerViewAd = bannerViewAd else { return }
              bannerViewAd.adUnitID = ADMOB_BANNERRECTANGLE_ID
              bannerViewAd.delegate = self
              bannerViewAd.rootViewController = viewController
              rectangledelegateadmobBannerview = view
              rectangledelegateviewConstarint = heightConstarint
              view.addSubview(bannerViewAd)
       
              bannerViewAd.load(AdsHelper.createRequest())
              
         }

}


// MARK: - GADBannerViewDelegate
extension AdMobBannerRectangleAd: GADBannerViewDelegate {

   func adViewDidReceiveAd(_ bannerView: GADBannerView) {
       
        bannerView.isHidden = false
print("AdmobBannerView\(bannerView)")
       AdsListenerHelper.adsInstanceHelper.adsLoad(adsView: bannerView,viewcontroller:bannerView.rootViewController!,rectangledelegateviewConstarint)
       rectangledelegateadmobBannerview.isHidden = false
       bannerView.center = CGPoint(x: rectangledelegateadmobBannerview.frame.size.width  / 2,
                             y: bannerView.frame.height/2)
       rectangledelegateviewConstarint.constant = bannerView.frame.height
//       rectangledelegateadmobBannerview.addSubview(bannerView)
    
   }

   // Will present
   func adViewWillPresentScreen(_ bannerView: GADBannerView) { // gets called only in release mode
   }

   // Will dismiss
   func adViewWillDismissScreen(_ bannerView: GADBannerView) {
       
      
   }

   // Did dismiss
   func adViewDidDismissScreen(_ bannerView: GADBannerView) { // gets called in only release mode
       print("AdMob banner closed")
   }

   // Will leave application
   func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
       print("AdMob banner will leave application")
   }

   // Did fail to receive
   func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
       print(error.localizedDescription)
     print("Banner Adsfailed")
      //  admobBannerview.isHidden = true
       AdsListenerHelper.adsInstanceHelper.adsFailed(rectangledelegateadmobBannerview,AdsEnum.ADS_ADMOB, error.localizedDescription,bannerView.rootViewController!,rectangledelegateviewConstarint)
       rectangledelegateadmobBannerview.isHidden = true
       rectangledelegateviewConstarint.constant = 0
      
//       OnBannerAdsIdLoaded.adsInstanceHelper.bannerAdsFailed()
   
   }
}



public class CallOnSplash  : onParseDefaultValueListenerProtocol{
   
    var timer : Timer?
   public  static let shared = CallOnSplash()
    var requestController = UIViewController()
    var inAppBillingHandler = InAppBillingHandler()
   public func v2CallOnSplash(for  viewController:UIViewController){
    DispatchQueue.global(qos: .background).async {
        DispatchQueue.main.async { [self] in
            let launchcount = UserDefaults.standard.integer(forKey: LAUNCH_COUNT)
            let device_token = UserDefaults.standard.string(forKey: DEVICE_TOKEN)
          
            APP_LAUNCH_COUNT = launchcount
            self.requestController = viewController
        
            initService(false, launchCount: launchcount, deviceToken: device_token ?? "")
            initService(true, launchCount: launchcount, deviceToken: device_token ?? "")
            onParseDefaultValueListener.adsInstanceHelper.onParseDefaultDelegates = self
            adMobOpenAdsSplashCache = true
            
            EngineOpenAds.openAdsInstance.createInitOpenAds(from: viewController, adsid: OPEN_ADS_ID, isFromCache: false)
            EngineOpenAdsListener.adsInstanceHelper.openAdsdelegates = self
             inAppBillingHandler.InAppBillingHandler(target: viewController)
             inAppBillingHandler.initializeBilling()
           
          }
        }
    }
    
    func onParsingCompleted() {
        print("ParseComplete") 
        self.handleLaunchCache(viewContoller: self.requestController)
    }
    
       
 }

extension CallOnSplash : EngineOpenAdsListenerProtocol{
    func onOpenAdsFailed(provider: AdsEnum, error: String, viewController: UIViewController) {
        EngineOpenAds.openAdsInstance.createInitOpenAds(from: requestController,adsid: OPEN_ADS_ID,isFromCache: false)
    }
    
    func onOpenAdsLoad() {
        
    }
    func onOpenAdClosed(_ viewController: UIViewController) {
        
    }
}


extension CallOnSplash {
  
    
    func handleLaunchCache(viewContoller:UIViewController) {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async { [self] in
        print("LAUNCHREPAET\(LAUNCH_NON_REPEAT_COUNT.count)")
       
        if  LAUNCH_NON_REPEAT_COUNT.count > 0{
            var full_nonRepeat = 0
            
            for i in 0..<LAUNCH_NON_REPEAT_COUNT.count {
               
                let value = LAUNCH_NON_REPEAT_COUNT[i].launch_rate
                print("NONREPEATVALUE\(value)")
                full_nonRepeat = getStringtoInt(data: value)
                
                print("FULLNONREPEAT:\(full_nonRepeat)")
                if (APP_LAUNCH_COUNT  == full_nonRepeat) {
                    print("cacheHandle >>3\(full_nonRepeat)")
                    cacheLaunchFullAd(viewContoller: viewContoller)
                    return
                }
            }
            
        }
        
        
        
        if (LAUNCH_REPEAT_FULL_ADS != "" && LAUNCH_REPEAT_FULL_ADS != "" && APP_LAUNCH_COUNT % getStringtoInt(data: LAUNCH_REPEAT_FULL_ADS) == 0 ) {
             print("RepeatFullAds")
             print("LAUNCH_FULL_ADS_providers[position].provider_id\(LAUNCH_FULL_ADS_providers[0].provider_id)")
             cacheLaunchFullAd(viewContoller: viewContoller)
        }
            }
        }
        
    }
    
    func cacheLaunchFullAd(viewContoller:UIViewController){
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async { [self] in
        UserDefaults.standard.set(0, forKey: FULLAD_LOAD_DATA_POSITION)
        loadLaunchCacheFullAds(viewContoller: viewContoller,position: UserDefaults.standard.integer(forKey:FULLAD_LOAD_DATA_POSITION))
         
    }
        }
    }
    
    func loadLaunchCacheFullAds(viewContoller:UIViewController,position:Int){
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async { [self] in
        FullAdsListener.adsInstanceHelper.fulladsdelegates = self
        getNewLaunchCacheFullPageAd(position,viewContoller)
            }
        }
    }
}

extension CallOnSplash:FullAdsListenerProtocol{
    public func onFullAdClosed(_ viewController: UIViewController) {
        print("Full Ads Closed")
        FullAdsCloseListener.adsInstanceHelper.FullAdsClose(viewController)
        UIApplication.shared.isStatusBarHidden = false
    }
    
    
    public func onFullAdsLoad() {
       
        UIApplication.shared.isStatusBarHidden = true
        print("full adsload")
        OnCacheFullAddListener.adsInstanceHelper.onCacheFullAdListener()
    }
    
    public func onFullAdsFailed(provider: AdsEnum, error: String, viewController: UIViewController) {
       
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
               
                let currentpos = UserDefaults.standard.integer(forKey: FULLAD_LOAD_DATA_POSITION)
                let pos = currentpos + 1
                UserDefaults.standard.set(pos, forKey: FULLAD_LOAD_DATA_POSITION)
                self.loadLaunchCacheFullAds(viewContoller: viewController, position: UserDefaults.standard.integer(forKey: FULLAD_LOAD_DATA_POSITION))
            }
        }
  
    }

}





public class CallonInApprequest {

   public  static let shared = CallonInApprequest()
    public func v2CallonInAppRequest(productID:String){
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async { [self] in
                let launchcount = UserDefaults.standard.integer(forKey: LAUNCH_COUNT)
                let device_token = UserDefaults.standard.string(forKey: DEVICE_TOKEN)
              
                doinAppRequest(launchcount,device_token!,productID )
            
        }
        }
       
        
    }
}







