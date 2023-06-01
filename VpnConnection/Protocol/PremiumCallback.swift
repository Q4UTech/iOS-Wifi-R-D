//
//  PremiumCallback.swift
//  Q4U_VPNAPP
//
//  Created by Deepti Chawla on 19/05/21.
//

import Foundation
protocol PremiumCallbackDelegate: class {
    /// SwiftyAd did open
    
    func purchaseInfo(expiredDate: String,productId:String)
    
}


class PremiumCallback : NSObject {
    
    var itemdelegates: PremiumCallbackDelegate?
    class var instanceHelper: PremiumCallback {
        struct Static {
            static let instance = PremiumCallback()
        }
        return Static.instance
    }
    
    func purchasedInfo(expiredDate: String,productId:String){
        itemdelegates?.purchaseInfo(expiredDate: expiredDate,productId:productId)
    }

}

