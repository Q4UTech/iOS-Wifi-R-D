//
//  DashboardVC.swift
//  WiFiProvider
//
//  Created by gautam  on 11/05/23.
//

import UIKit


class DashboardVC: UITabBarController,UITabBarControllerDelegate {
    var value = String()
    var type = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        CallAppLaunch.shared.v2CallonAppLaunch(from: self,value:value,type: type)
        // Do any additional setup after loading the view.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
       showFullAds(viewController: self, isForce: false)
        
    }
    

}
