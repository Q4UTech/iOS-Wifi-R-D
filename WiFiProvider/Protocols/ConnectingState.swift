//
//  ConnectingState.swift
//  Q4U_VPNAPP
//
//  Created by Deepti Chawla on 28/04/21.
//

import Foundation


protocol ConnectingStateDelegate: class {
    /// SwiftyAd did open
    
    func connectingStatus(status:Bool)
    
}


class ConnectingState : NSObject {
    
    var itemdelegates: ConnectingStateDelegate?
    class var instanceHelper: ConnectingState {
        struct Static {
            static let instance = ConnectingState()
        }
        return Static.instance
    }
    
    func checkConnectionState(status:Bool){

        itemdelegates?.connectingStatus(status: status)
    }
    
    
}
