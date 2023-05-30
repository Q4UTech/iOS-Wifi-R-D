//
//  EngineDelegate.swift
//  AppEngine
//
//  Created by Deepti Chawla on 23/04/21.
//

import Foundation


import UIKit
import Firebase

import FirebaseMessaging
import AdSupport
import GoogleMobileAds
import FBAudienceNetwork
import AVKit
import AVFoundation


open class EngineDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate, MessagingDelegate,AVPictureInPictureControllerDelegate {
    public var window: UIWindow?
    var rootViewController = UIViewController()
    static var excludeControllersArr = [String]()
    let device_token = UserDefaults.standard.string(forKey: DEVICE_TOKEN)
    let launchcount = UserDefaults.standard.integer(forKey: LAUNCH_COUNT)
    let UDIDString = UIDevice.current.identifierForVendor
    let gcmMessageIDKey = "12345678"
   // let senderID = "426505366444"
    let senderID = "10773095903"
    let serverKey = "AAAAY02za6w:APA91bG2e9eyycMW_eDDKzyaTphrflIA-H1NeCsGjs1i0VSlbIle9bkCYvM3bMJ20RgNsK0-65x0IY3_k1zQB7IY-wmg1tVk2jZXVF8L0yi-Y9Bb1x2slJ7ZGJ_DD2_3wysSO-S4WXUh"
    var backgroundSessionCompletionHandler: (() -> Void)?
    
  public func adsIdCalling(application:UIApplication){
        FirebaseApp.configure()
        googleTestDeviceID()
        fbTestDeviceID()
        excludeControllersList()
        notification(application: application)
    }
    
    func excludeControllersList(){
        EngineDelegate.excludeControllersArr.insert("SplashVC", at: 0)
        EngineDelegate.excludeControllersArr.insert("FullPagePromoInhouseVC",at:1)
        EngineDelegate.excludeControllersArr.insert("GADFullScreenAdViewController",at:2)
        EngineDelegate.excludeControllersArr.insert("FBAudienceNetwork",at:3)
        EngineDelegate.excludeControllersArr.insert("FaceCamVC",at:4)
        EngineDelegate.excludeControllersArr.insert("CustomViewController",at:5)
    }
    
    public func applicationWillEnterForeground(_ application: UIApplication) {
       print("app is in foreground")
        UserDefaults.standard.setValue(true, forKey:KEY_CONTROLLER_STATE_CHECK)
        
        let  mainValue = ETC_4
       
        do {
            if mainValue != ""{
                if (mainValue.contains("#")) {
                    let reqValueArr = mainValue.components(separatedBy: "#")
                    let mainCount = reqValueArr[0]
                    let mainID = reqValueArr[1]
                    let currentController = getCurrentViewController()
                    setOpenadsCount(currentController!, -1)
                    OPEN_ADS_ID = mainID
                    if getOpenAdsCount(currentController!) == getStringtoInt(data: mainCount){
                        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: {  timer in
                            setOpenadsCount(currentController!, 0)
                            if EngineDelegate.excludeControllersArr.count > 6{
                                EngineDelegate.excludeControllersArr.remove(at: 6)
                            }
                            if !UserDefaults.standard.bool(forKey: IN_APP_PURCHASED){
                                ShowEngineOpenAds.showEngineOpenAdsInstance.showAdmobOpenAds(from: currentController!,adsid: mainID,exculdeStringArray: EngineDelegate.excludeControllersArr)
                            }
                         
                        })
                    }
                }
            }
        }
        
            
    }
    
    public func applicationDidEnterBackground(_ application: UIApplication) {
        print("App is in Background")
        UserDefaults.standard.setValue(false, forKey: KEY_CONTROLLER_STATE_CHECK)
       
        if getCurrentViewController() != nil{
            
          let  currentController1 = getCurrentViewController()!
            
            if !adMobOpenAdsSplashCache{
                adMobOpenAdsSplashCache = true
                EngineOpenAds.openAdsInstance.createInitOpenAds(from: currentController1,adsid: OPEN_ADS_ID,isFromCache: false)
            }
        }
    }
    
    
    
    func notification(application:UIApplication){
        let currentCount = UserDefaults.standard.integer(forKey: LAUNCH_COUNT)
        UserDefaults.standard.set(currentCount+1, forKey: LAUNCH_COUNT)
        application.beginReceivingRemoteControlEvents()
        UNUserNotificationCenter.current().delegate = self
//        UIApplication.shared.applicationIconBadgeNumber = 0
     
        let authOptions: UNAuthorizationOptions = [.alert, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (granted, error) in
            guard error == nil else{
                UIApplication.shared.registerForRemoteNotifications()
                return
            }
            if granted {
            }else{
                DispatchQueue.main.async {
                   // settingPrompt(self: (self.window?.rootViewController)!)
                }
            }
        }
        application.registerForRemoteNotifications()
    }
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if userInfo[gcmMessageIDKey] != nil {
            
        }
       
    }
    
    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("notification\(notification.request.identifier)")
        if !UserDefaults.standard.bool(forKey: "CHECK_FIRST_NOTIFICTION"){
            UserDefaults.standard.setValue(true, forKey: "CHECK_FIRST_NOTIFICTION")
            if notification.request.identifier == "com.quantum4u.vpnApp.neprovider.CategorizatioProcessor.notificationRequestIdentifier"{
                completionHandler([.alert,.sound])
                //checkSubscriptionExpire()
            }
        }else if notification.request.identifier == "com.quantum4u.vpnApp.neprovider.CategorizatioProcessor.notificationRequestIdentifier"{
            completionHandler([.sound])
            //checkSubscriptionExpire()
        }else{
            completionHandler([.alert,.sound])
        }
        
      
    }
    

    
    public func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        backgroundSessionCompletionHandler = completionHandler
    }
    
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        
        print("deviceToken\(deviceToken)")
        Messaging.messaging().token { (result, error) in
            
            if error != nil {
                print("errorrrr\(error?.localizedDescription)")
               
            } else if let result = result {
                 print("the gcmtoken is \(result)")
              
                
                let gcmToken = result
                if gcmToken != "" {
                    doGCMrequest(fcmtoken:gcmToken)
                }
            }
        }
        
        let  tokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        UserDefaults.standard.set(tokenString, forKey: DEVICE_TOKEN)
       
    }
    
    private func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("FCM Token\(fcmToken)")
    }
    
    
    
}
