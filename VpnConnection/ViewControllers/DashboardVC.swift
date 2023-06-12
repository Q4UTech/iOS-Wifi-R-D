//
//  DashboardVC.swift
//  WiFiProvider
//
//  Created by gautam  on 11/05/23.
//

import UIKit
import CoreLocation

class DashboardVC: UITabBarController,UITabBarControllerDelegate{
    var value = String()
    var type = String()
    
    @IBInspectable var initailIndex:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
       
        print("values3434 \(type) \(value)")
        selectedIndex = initailIndex
        CallAppLaunch.shared.v2CallonAppLaunch(from: self,value:value,type: type)
        // Do any additional setup after loading the view.
    }
    
    
  
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
       showFullAds(viewController: self, isForce: false)
        
    }
    
    
    

}
