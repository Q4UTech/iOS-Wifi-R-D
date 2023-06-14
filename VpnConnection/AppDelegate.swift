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
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillBecomeActive),
                                               name: UIApplication.willEnterForegroundNotification, object: nil)
       
        
        return true
    }
    
    @objc func appWillEnterForeground() {
  
        NotificationCenter.default.post(name: NSNotification.Name("AppEnteredForegroundNotification"), object: nil)
    }

   
    @objc func appWillBecomeActive() {
        print("data_fetched")
        // Post a notification to let the view controller know that the app entered the foreground
        NotificationCenter.default.post(name: NSNotification.Name("AppWillBecomeActive"), object: nil)
    }


//    override func applicationDidEnterBackground(_ application: UIApplication) {
//        var bgTask: UIBackgroundTaskIdentifier = .invalid
//        
//        bgTask = application.beginBackgroundTask(withName: "MyTask") {
//            // Clean up any unfinished task business by marking where you
//            // stopped or ending the task outright.
//            application.endBackgroundTask(bgTask)
//            bgTask = .invalid
//        }
//        
//        // Start the long-running task and return immediately.
//        DispatchQueue.global(qos: .default).async {
//            // Do the work associated with the task, preferably in chunks.
//            
//            application.endBackgroundTask(bgTask)
//            bgTask = .invalid
//        }
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

