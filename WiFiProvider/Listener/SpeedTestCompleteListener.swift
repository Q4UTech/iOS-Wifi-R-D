//
//  SpeedTestCompleteListener.swift
//  WiFiProvider
//
//  Created by gautam  on 12/05/23.
//

import Foundation

protocol SpeedCheckProtocol{
    func isSpeedCheckComplete(complete:Bool)
}

class SpeedTestCompleteListener:NSObject,SpeedCheckProtocol{
    var speedCheckDelegate : SpeedCheckProtocol?
    
    class var instanceHelper: SpeedTestCompleteListener {
        struct Static {
            static let instance = SpeedTestCompleteListener()
        }
        return Static.instance
    }
    
    func isSpeedCheckComplete(complete: Bool) {
        speedCheckDelegate?.isSpeedCheckComplete(complete: complete)
    }
    
    
}
