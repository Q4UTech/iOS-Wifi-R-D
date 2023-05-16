//
//  FreeTrafficRemaining.swift
//  Q4U_VPNAPP
//
//  Created by Deepti Chawla on 10/05/21.
//

import Foundation


protocol FreeTrafficRemainingDelegate: class {
    /// SwiftyAd did open
    
    func trafficRemaining(trafficRemaining: UInt64,trafficUsed:UInt64)
    
}


class FreeTrafficRemaining : NSObject {
    
    var itemdelegates: FreeTrafficRemainingDelegate?
    class var instanceHelper: FreeTrafficRemaining {
        struct Static {
            static let instance = FreeTrafficRemaining()
        }
        return Static.instance
    }
    
    func trafficRemaining(trafficRemaining:UInt64,trafficUsed:UInt64){

        itemdelegates?.trafficRemaining(trafficRemaining: trafficRemaining,trafficUsed: trafficUsed)
    }

}

