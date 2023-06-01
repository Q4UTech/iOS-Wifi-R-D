//
//  VPNConnectedStatus.swift
//  Q4U_VPNAPP
//
//  Created by Deepti Chawla on 13/05/21.
//

import Foundation
protocol VPNConnectedStatusDelegate: class {
    /// SwiftyAd did open
    
    func vpnConnectedStatus(status:Bool)
    
}


class VPNConnectedStatus : NSObject {
    
    var itemdelegates: VPNConnectedStatusDelegate?
    class var instanceHelper: VPNConnectedStatus {
        struct Static {
            static let instance = VPNConnectedStatus()
        }
        return Static.instance
    }
    
    func vpnConnectedStatus(status:Bool){

        itemdelegates?.vpnConnectedStatus(status: status)
    }
    
    
}
