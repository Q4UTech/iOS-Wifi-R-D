//
//  FullAdsListener.swift
//  App Engine
//
//  Created by Quantum_MAC_7 on 31/03/20.
//  Copyright © 2020 Pulkit Babbar. All rights reserved.
//

import Foundation

import UIKit



// weak var delegates : AdsListenerProtocol? = nil
/// SwiftyAdsDelegate
public protocol FullAdsListenerProtocol: class {
    /// SwiftyAd did open
    
    func onFullAdsLoad()
    func onFullAdsFailed(provider:AdsEnum,error: String,viewController:UIViewController)
    func onFullAdClosed(_ viewController:UIViewController)
}
public class FullAdsListener: NSObject{
    public var fulladsdelegates: FullAdsListenerProtocol?
    public class var adsInstanceHelper: FullAdsListener {
        struct Static {
            static let instance = FullAdsListener()
        }
        return Static.instance
    }
    
    
    func fullAdsLoaded(){
        
        fulladsdelegates?.onFullAdsLoad()
        UIApplication.shared.isStatusBarHidden = true
    }
    
    func FullAdsFailed(_ adsenum:AdsEnum,_ error:String,_ viewController:UIViewController) {
        
        fulladsdelegates?.onFullAdsFailed(provider: adsenum, error: error, viewController: viewController)
    }
    func FullAdsClosed(_ viewController:UIViewController) {
        UIApplication.shared.isStatusBarHidden = false
        fulladsdelegates?.onFullAdClosed(viewController)
        
    }
    
}




