//
//  VPNPurchasedStatus.swift
//  Q4U_VPNAPP
//
//  Created by Deepti Chawla on 11/06/21.
//

import Foundation


protocol VPNPurchasedStatusDelegate: class {
    /// SwiftyAd did open
    
    func vpnPurchasedStatus(status:Bool,result:String)
    
}


class VPNPurchasedStatus : NSObject {
    
    var itemdelegates: VPNPurchasedStatusDelegate?
    class var instanceHelper: VPNPurchasedStatus {
        struct Static {
            static let instance = VPNPurchasedStatus()
        }
        return Static.instance
    }
    
    func vpnPurchasedStatus(status:Bool,result:String){
        itemdelegates?.vpnPurchasedStatus(status: status,result:result)
    }

}

