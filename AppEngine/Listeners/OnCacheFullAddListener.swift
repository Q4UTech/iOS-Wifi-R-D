//
//  OnCacheFullAddListener.swift
//  CustomGallery
//
//  Created by Deepti Chawla on 20/07/20.
//  Copyright © 2020 Pavle Pesic. All rights reserved.
//

import Foundation
import UIKit


public protocol OnCacheFullAddListenerProtocol: class {
    /// SwiftyAd did open
 
    func onCacheFullAdListener()
   
}
public class OnCacheFullAddListener: NSObject{
    public var  onCacheFullAdsdelegates: OnCacheFullAddListenerProtocol?
    var rootView = UIView()
    public class var adsInstanceHelper: OnCacheFullAddListener {
        struct Static {
            static let instance = OnCacheFullAddListener()
        }
        return Static.instance
    }
    
    
    public func onCacheFullAdListener(){
    
        onCacheFullAdsdelegates?.onCacheFullAdListener()
   
    }
    
   
  
}
