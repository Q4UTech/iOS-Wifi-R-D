//
//  AppDelegate.swift
//  WiFiProvider
//
//  Created by gautam  on 27/04/23.
//

import UIKit

@main
class AppDelegate: EngineDelegate {

 

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) {(accepted, error) in
            if !accepted {
               
            }
        }
        lightTheme()
        adsIdCalling(application:application)

        RazeFaceProducts.store.restorePurchases(fromStart: true)
      
        return true
    }

//    func applicationWillTerminate(_ application: UIApplication) {
//      
//            TimerManager.shared.stopTimer()
//      
//
//    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
     
        
        if !userInfo.isEmpty{
            let aps = userInfo["aps"] as? [String: Any]
            let alert = aps!["alert"] as? [String: Any]
            _ = alert!["title"] as? String ?? ""
            _ = alert!["body"] as? String ?? ""
            var type = String()
            var value = String()
            
            if userInfo["gcm.notification.value"] != nil{
                value = userInfo["gcm.notification.value"] as! String
            }else{
                value = ""
            }
            
            if userInfo["gcm.notification.type"] != nil{
                type = userInfo["gcm.notification.type"] as! String
            }
            else{
                type = ""
            }
            
          
            
            let sb = UIStoryboard(name: "Engine", bundle: nil)
            let otherVC = sb.instantiateViewController(withIdentifier: "MapperVC") as! MapperVC

            otherVC.type = type
            otherVC.value = value

            let navigationController = window?.rootViewController as! UINavigationController

            navigationController.pushViewController(otherVC, animated: false)
            
            completionHandler()
        }else {
            
            let sb = UIStoryboard(name: "Engine", bundle: nil)
            let otherVC = sb.instantiateViewController(withIdentifier: "MapperVC") as! MapperVC
            let navigationController = window?.rootViewController as! UINavigationController
            navigationController.pushViewController(otherVC, animated: false)
            completionHandler()
        }
       
    }


}

