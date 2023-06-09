//
//  DashboardVC.swift
//  WiFiProvider
//
//  Created by gautam  on 11/05/23.
//

import UIKit
import CoreLocation

class DashboardVC: UITabBarController,UITabBarControllerDelegate,CLLocationManagerDelegate{
    var value = String()
    var type = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        print("values3434 \(type) \(value)")
        CallAppLaunch.shared.v2CallonAppLaunch(from: self,value:value,type: type)
        // Do any additional setup after loading the view.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
       showFullAds(viewController: self, isForce: false)
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("status \(0)")
    }
    
    

}
