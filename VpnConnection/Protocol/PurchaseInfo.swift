//
//  PurchaseInfo.swift
//  Q4U_VPNAPP
//
//  Created by Deepti Chawla on 17/05/21.
//

import Foundation



protocol PurchaseInfoDelegate: class {
    /// SwiftyAd did open
    
    func purchaseInfo(expiredDate: String,productId:String,status:Bool)
    
}


class PurchaseInfo : NSObject {
    
    var itemdelegates: PurchaseInfoDelegate?
    class var instanceHelper: PurchaseInfo {
        struct Static {
            static let instance = PurchaseInfo()
        }
        return Static.instance
    }
    
    func purchasedInfo(expiredDate: String,productId:String,status:Bool){
        itemdelegates?.purchaseInfo(expiredDate: expiredDate,productId:productId,status: status)
    }

}

