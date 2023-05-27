//
//  AppFullAdsCloseListner.swift
//  App Engine
//
//  Created by Quantum_MAC_7 on 03/04/20.
//  Copyright © 2020 Pulkit Babbar. All rights reserved.
//

import Foundation
import UIKit
public protocol AppFullAdsCloseProtocol: class {
    /// SwiftyAd did open
 
    func onFullAdClosed(viewController:UIViewController)
}
public class AppFullAdsCloseListner: NSObject{
public var fulladsclosedelegates: AppFullAdsCloseProtocol?
    
  public  class var adsInstanceHelper: AppFullAdsCloseListner {
        struct Static {
            static let instance = AppFullAdsCloseListner()
        }
        return Static.instance
    }
  
   public func FullAdsClos(viewController:UIViewController) {
      
        fulladsclosedelegates?.onFullAdClosed(viewController: viewController)
       }
  
}




