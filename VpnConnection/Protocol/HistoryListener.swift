//
//  HistoryListener.swift
//  VpnConnection
//
//  Created by gautam  on 09/06/23.
//

import Foundation


protocol HistoryProtocol{
    func isDeleteComplete(complete: Bool)
  
}

class HistoryListener:NSObject,HistoryProtocol{
    var historyDelegate : HistoryProtocol?
    
    class var instanceHelper: HistoryListener {
        struct Static {
            static let instance = HistoryListener()
        }
        return Static.instance
    }
    
    func isDeleteComplete(complete: Bool){
        historyDelegate?.isDeleteComplete(complete: complete)
    }
    
    
}
