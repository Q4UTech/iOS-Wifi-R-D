//
//  FullAdsCloseListener.swift
//  AppEngine
//
//  Created by Deepti Chawla on 27/04/21.
//

import Foundation

import UIKit

public protocol FullAdsCloseListenerProtocol: class {

 
   
    func onFullAdClose(_ viewController:UIViewController)
}
public class FullAdsCloseListener: NSObject{
    public var fulladsdelegates: FullAdsCloseListenerProtocol?
//    var rootView = UIView()
    public class var adsInstanceHelper: FullAdsCloseListener{
        struct Static {
            static let instance = FullAdsCloseListener()
        }
        return Static.instance
    }
    
    
    
     func FullAdsClose(_ viewController:UIViewController) {
     
        fulladsdelegates?.onFullAdClose(viewController)
       }
  
}





