//
//  LaunchFullCallBackListener.swift
//  iOS-SendAnyWhere
//
//  Created by Deepti Chawla on 14/10/20.
//  Copyright © 2020 Pulkit Babbar. All rights reserved.
//

import Foundation


public protocol LaunchFullCallBackListenerProtocol: class {
    /// SwiftyAd did open
 
    func onFullAdsReturn(status:Bool)
    
}
public class LaunchFullCallBackListener: NSObject{
    public var fulladsdelegates: LaunchFullCallBackListenerProtocol?
 
    public  class var adsInstanceHelper: LaunchFullCallBackListener {
        struct Static {
            static let instance = LaunchFullCallBackListener()
        }
        return Static.instance
    }

    public  func onFullAdsReturn(status:Bool){
    
        fulladsdelegates?.onFullAdsReturn(status:status)
    }
    
   
  
}




