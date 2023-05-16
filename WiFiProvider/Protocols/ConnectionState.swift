//
//  ConnectionState.swift
//  Q4U_VPNAPP
//
//  Created by Deepti Chawla on 13/04/21.
//  Copyright © 2021 Anchorfree Inc. All rights reserved.
//

import Foundation

protocol ConnectionStateDelegate: class {
    /// SwiftyAd did open
    
    func connectionState(uploadSpeed: String,downloadSpeed:String)
    
}


class ConnectionState : NSObject {
    
    var itemdelegates: ConnectionStateDelegate?
    class var instanceHelper: ConnectionState {
        struct Static {
            static let instance = ConnectionState()
        }
        return Static.instance
    }
    
    func checkConnectionState(uploadSpeed:String,downloadSpeed:String){

        itemdelegates?.connectionState(uploadSpeed: uploadSpeed,downloadSpeed: downloadSpeed)
    }
    
    
}
