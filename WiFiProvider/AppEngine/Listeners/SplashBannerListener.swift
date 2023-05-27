//
//  SplashBannerListener.swift
//  Q4U_ScreenRecording
//
//  Created by Deepti Chawla on 25/03/22.
//


import Foundation

import UIKit

public protocol SplashBannerListenerProtocol: class {

 
   
    func splashBannerStatus(_ status:Bool)
}
public class SplashBannerListener: NSObject{
    public var splashBannerdelegates: SplashBannerListenerProtocol?
//    var rootView = UIView()
    public class var adsInstanceHelper: SplashBannerListener{
        struct Static {
            static let instance = SplashBannerListener()
        }
        return Static.instance
    }
    
    
    
     func SplashBannerStatus(_ status:Bool) {
     
         splashBannerdelegates?.splashBannerStatus(status)
       }
  
}





