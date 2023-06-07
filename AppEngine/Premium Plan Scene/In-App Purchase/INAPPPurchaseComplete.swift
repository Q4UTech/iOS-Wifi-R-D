//
//  INAPPPurchaseComplete.swift
//  Q4U_VPNAPP
//
//  Created by Deepti Chawla on 11/06/21.
//

import Foundation




protocol INAPPPurchaseCompleteDelegate: class {
    /// SwiftyAd did open
    
    func inAppPurchasedStatus(status:Bool,productID:String)
    
}


class INAPPPurchaseComplete : NSObject {
    
    var itemdelegates: INAPPPurchaseCompleteDelegate?
    class var instanceHelper: INAPPPurchaseComplete {
        struct Static {
            static let instance = INAPPPurchaseComplete()
        }
        return Static.instance
    }
    
    func inAppPurchasedStatus(status:Bool,productID:String){
        itemdelegates?.inAppPurchasedStatus(status: status,productID:productID)
    }

}

