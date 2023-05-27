//
//  AdsListenerHelper.swift
//  App Engine
//
//  Created by Quantum_MAC_7 on 23/03/20.
//  Copyright © 2020 Pulkit Babbar. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds


// weak var delegates : AdsListenerProtocol? = nil
/// SwiftyAdsDelegate
protocol AdsListenerProtocol: class {
    /// SwiftyAd did open
 
    func onAdsLoad(view :UIView,viewController:UIViewController,_ heightConstaint:NSLayoutConstraint)
    func onAdsFailed(view: UIView,provider:AdsEnum,error: String,viewController:UIViewController,_ heightConstaint:NSLayoutConstraint)
    
}
 class AdsListenerHelper{
var delegates: AdsListenerProtocol?
    var rootView = UIView()
    class var adsInstanceHelper: AdsListenerHelper {
        struct Static {
            static let instance = AdsListenerHelper()
        }
        return Static.instance
    }
    
    
    func adsLoad(adsView:UIView,viewcontroller:UIViewController,_ heightConstaint:NSLayoutConstraint){
      
   
         delegates?.onAdsLoad(view: adsView,viewController: viewcontroller,heightConstaint)
    }
    
    func adsFailed(_ view:UIView,_ adsenum:AdsEnum,_ error:String,_ viewController:UIViewController,_ heightConstaint:NSLayoutConstraint) {
        
        delegates?.onAdsFailed(view:view, provider: adsenum, error: error, viewController: viewController,heightConstaint)
    }
    
  
}




