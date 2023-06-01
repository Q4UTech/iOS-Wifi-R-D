//
//  ShowForceFullAdListener.swift
//  Q4U-PhoneSwtich
//
//  Created by Deepti Chawla on 24/06/22.
//

import Foundation


import UIKit

public protocol ShowForceFullAdsCloseListenerProtocol: class {

 
   
    func onForceFullAdClose(status:Bool)
}
public class ShowForceFullAdsCloseListener: NSObject{
    public var forcefulladsdelegates: ShowForceFullAdsCloseListenerProtocol?
//    var rootView = UIView()
    public class var adsInstanceHelper: ShowForceFullAdsCloseListener{
        struct Static {
            static let instance = ShowForceFullAdsCloseListener()
        }
        return Static.instance
    }
    
    
    
    func ForcefullAdsClose(status:Bool) {
     
        forcefulladsdelegates?.onForceFullAdClose(status:status)
       }
  
}

