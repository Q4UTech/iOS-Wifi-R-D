//
//  InAppBillingListeners.swift
//  AppEngine
//
//  Created by Deepti Chawla on 21/05/21.
//


import Foundation

import UIKit

public protocol InAppBillingListenersProtocol: class {

    func inAppPurchaseSuccess(productID: String, expiryDate:String,latest_receipt: String,fromStart:Bool)
   func inAppPurchaseFailed()
}
public class InAppBillingListeners: NSObject {
    public  weak var delegates: InAppBillingListenersProtocol?

    public class var adsInstanceHelper: InAppBillingListeners{
        struct Static {
            static let instance = InAppBillingListeners()
        }
        return Static.instance
    }
    
    func purchaseSuccess(productID: String, expiryDate:String,latest_receipt: String,fromStart:Bool) {
        
        delegates?.inAppPurchaseSuccess(productID: productID, expiryDate:expiryDate,latest_receipt: latest_receipt,fromStart:fromStart)
   }
    
     func purchaseFailed() {
       
        delegates?.inAppPurchaseFailed()
       }
  
}





