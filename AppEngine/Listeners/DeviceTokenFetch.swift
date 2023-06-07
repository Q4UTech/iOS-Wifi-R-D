//
//  DeviceTokenFetch.swift
//  CustomGallery
//
//  Created by Deepti Chawla on 21/07/20.
//  Copyright © 2020 Pavle Pesic. All rights reserved.
//

import Foundation

protocol DeviceTokenFetchProtocol: class {
    /// SwiftyAd did open
 
    func onDeviceToken(deviceToken:String)
   
}
class DeviceTokenFetch: NSObject{
var  deviceTokenFetch: DeviceTokenFetchProtocol?
  
    class var adsInstanceHelper: DeviceTokenFetch {
        struct Static {
            static let instance = DeviceTokenFetch()
        }
        return Static.instance
    }
    
    
    func deviceTokenGet(deviceToken:String){
     
        deviceTokenFetch?.onDeviceToken(deviceToken:deviceToken)
   
    }
    
   
  
}
