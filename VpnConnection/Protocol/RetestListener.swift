//
//  RetestListener.swift
//  VpnConnection
//
//  Created by gautam  on 05/06/23.
//

import Foundation


protocol RetestProtocol{
    func isSpeedTestComplete(complete: Bool)
  
}

class RetestListener:NSObject,RetestProtocol{
    var retestDelegate : RetestProtocol?
    
    class var instanceHelper: RetestListener {
        struct Static {
            static let instance = RetestListener()
        }
        return Static.instance
    }
    
    func isSpeedTestComplete(complete: Bool) {
        retestDelegate?.isSpeedTestComplete(complete: complete)
    }
    
    
}
