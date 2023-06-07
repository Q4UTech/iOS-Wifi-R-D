//
//  OpenAds.swift
//  OpenAdsDummyProject
//
//  Created by Deepti Chawla on 16/02/21.
//

import Foundation
import GoogleMobileAds
import UIKit

var appOpenAd: GADAppOpenAd?
var  adMobOpenAdsSplashCache = false
var OPEN_ADS_ID  = ""
let KEY_CONTROLLER_STATE_CHECK  = "KEY_CONTROLLER_STATE_CHECK"
var loadTime: Date?

class EngineOpenAds :NSObject{
    var status = Bool()
    var requestController = UIViewController()
    var cache = Bool()
    var currentController = UIViewController()
    static let openAdsInstance = EngineOpenAds()
    

}
extension EngineOpenAds{
    func checkCurrentState(controller: UIViewController,status:Bool){
        self.currentController = controller
        self.status = status
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        let notificationCenter1 = NotificationCenter.default
        notificationCenter1.addObserver(self, selector: #selector(appMovedTobackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
      //  UserDefaults.standard.set(false, forKey: RATE_APP_VALUE)
    }
  
  
    @objc func appMovedToForeground() {
        print("App is in Foreground\(UserDefaults.standard.bool(forKey:KEY_CONTROLLER_STATE_CHECK))")
            //ratePrompt(self:currentController)
    
        
    }

    @objc func appMovedTobackground() {
        UserDefaults.standard.setValue(false, forKey: KEY_CONTROLLER_STATE_CHECK)
        status = false
    }
 
    
    func createInitOpenAds(from viewController: UIViewController,adsid:String,isFromCache:Bool) {
       
        let  mainValue = ETC_4
        do {
            print("ETC_4\(ETC_4)")
            if mainValue != ""{
                if (mainValue.contains("#")) {
                    let reqValueArr = mainValue.components(separatedBy: "#")
                    let mainCount = reqValueArr[0]
                    let mainID = reqValueArr[1]
                    if Int(mainCount)! <= 10{
                        OPEN_ADS_ID = mainID
                        if  OPEN_ADS_ID != "" {
                            cache = isFromCache
                            appOpenAd = nil
                            requestController = viewController
                            do{
                                GADAppOpenAd.load(
                                    withAdUnitID: mainID,
                                    request: GADRequest(),
                                    orientation: UIInterfaceOrientation.portrait,
                                    completionHandler: { [self] appOpenAds, error in
                                        if let error = error {
                                            print("Failed to load app open ad: \(error)")
                                            return
                                        }
                                        appOpenAd = appOpenAds
                                        loadTime = Date()
                                        appOpenAd!.fullScreenContentDelegate = self
                                    })
                            }
                        }
                        else {
                         EngineOpenAdsListener.adsInstanceHelper.OpenAdsFailed(AdsEnum.OPEN_ADS_ADMOB,"OpenAds Id null",viewController)
                        }
                    }
                }
                    
            }
        }
    }
}


extension EngineOpenAds : GADFullScreenContentDelegate{
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("didFailToPresentFullScreenContentWithError \(error)")
        
        if cache{
            EngineOpenAdsListener.adsInstanceHelper.OpenAdsFailed(AdsEnum.OPEN_ADS_ADMOB,error.localizedDescription,requestController)
        }
        self.createInitOpenAds(from: requestController,adsid: OPEN_ADS_ID,isFromCache: false)
      
    }
    
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("adDidPresentFullScreenContent")
        if(cache){
            EngineOpenAdsListener.adsInstanceHelper.openAdsLoaded()
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("adDidDismissFullScreenContent")
        
        EngineOpenAdsListener.adsInstanceHelper.OpenAdsClosed(requestController)
        
        self.createInitOpenAds(from: requestController,adsid: OPEN_ADS_ID,isFromCache: false)
        
    }
}



    
class ShowEngineOpenAds : NSObject{
    static let showEngineOpenAdsInstance = ShowEngineOpenAds()
    
    var contoller = UIViewController()
    
    func showAdmobOpenAds(from viewController: UIViewController,adsid:String,exculdeStringArray:[String]) {
        OPEN_ADS_ID = adsid
        
        if adsid != ""{
            contoller = viewController
            print("exculdeStringArray\(exculdeStringArray) \(contoller.classForCoder.class().description()) \(contoller.description)")
      
                    if appOpenAd != nil {
                        if wasLoadTimeLessThanNHoursAgo(4) {
                            
                            if canShowAppOpenAds(className: exculdeStringArray, currentController: viewController) == false{
                             
                                appOpenAd?.present(fromRootViewController: contoller)
                                                                  print("Ad ready")
                                                                  EngineOpenAdsListener.adsInstanceHelper.openAdsLoaded()
                            }
                        }else {
                           
                            EngineOpenAds.openAdsInstance.createInitOpenAds(from: contoller,adsid: OPEN_ADS_ID,isFromCache: false)
                            
                            EngineOpenAdsListener.adsInstanceHelper.OpenAdsFailed(AdsEnum.OPEN_ADS_ADMOB,"Ad not Ready",contoller)
                        }
                    }else{
                        EngineOpenAdsListener.adsInstanceHelper.OpenAdsFailed(AdsEnum.OPEN_ADS_ADMOB,"Admob Open Ads null",viewController)
                    }
    
        }
        else{
            EngineOpenAdsListener.adsInstanceHelper.OpenAdsFailed(AdsEnum.OPEN_ADS_ADMOB,"OpenAds Id null",viewController)
            
        }
        
    }
    
    
    
    func wasLoadTimeLessThanNHoursAgo(_ n: Int) -> Bool {
        let now = Date()
        let timeIntervalBetweenNowAndLoadTime = now.timeIntervalSince(loadTime!)
        let secondsPerHour = 3600.0
        let intervalInHours = timeIntervalBetweenNowAndLoadTime / secondsPerHour
        return intervalInHours < Double(n)
    }

}



func getCurrentViewController() -> UIViewController? {
    if let navigationController = getNavigationController() {
        
        return navigationController.visibleViewController
    }

    if let rootController = UIApplication.shared.keyWindow?.rootViewController {
        
        var currentController: UIViewController! = rootController
        while( currentController.presentedViewController != nil ) {
            
            currentController = currentController.presentedViewController
        }
        return currentController
    }
    return nil
}

func getNavigationController() -> UINavigationController? {
    
    if let navigationController = UIApplication.shared.keyWindow?.rootViewController  {
        
        return navigationController as? UINavigationController
    }
    return nil
}


func canShowAppOpenAds(className:[String] ,currentController :UIViewController) -> Bool{
    
    for item in className{
        
        print("controlleritemCheck\(item) \(String(describing:currentController.classForCoder.class().self))")
        if item.contains(String(describing:currentController.classForCoder.class().self)) || UserDefaults.standard.bool(forKey: "LOGIN_STATUS"){
            return true
        }
    }
   return false
}

