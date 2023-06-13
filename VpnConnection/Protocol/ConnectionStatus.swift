//
//  ConnectionStatus.swift
//  Q4U_VPNAPP
//
//  Created by Deepti Chawla on 21/04/21.
//

import Foundation
protocol ConnectionStatusDelegate: AnyObject {
    /// SwiftyAd did open
    
    func connectionStatus(connectionStatus: String)
    func exactStatus(status:String)
}


class ConnectionStatus : NSObject {
    
    var itemdelegates: ConnectionStatusDelegate?
    class var instanceHelper: ConnectionStatus {
        struct Static {
            static let instance = ConnectionStatus()
        }
        return Static.instance
    }
    
    func checkConnectionStatus(connectionStatus:String){
        itemdelegates?.connectionStatus(connectionStatus: connectionStatus)
    }
    func exactStatus(status:String){
        itemdelegates?.exactStatus(status:status)
    }

}
