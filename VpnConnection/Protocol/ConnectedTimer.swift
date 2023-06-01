//
//  ConnectedTimer.swift
//  Q4U_VPNAPP
//
//  Created by Deepti Chawla on 20/04/21.
//

import Foundation


import UIKit
protocol ConnectedTimerDelegate: class {
    /// SwiftyAd did open
    
    func connectedTimer(connectedTimer:String)
    
}

class ConnectedTimer: NSObject{
    var itemdelegates: ConnectedTimerDelegate?
    
    class var instanceHelper: ConnectedTimer {
        struct Static {
            static let instance = ConnectedTimer()
        }
        return Static.instance
    }
    
    func connectedTimers(connectedTimer:String){

        itemdelegates?.connectedTimer(connectedTimer: connectedTimer)
    }
    
    
}
