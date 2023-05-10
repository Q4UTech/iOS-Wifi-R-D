//
//  WifiModel.swift
//  LanScanner
//
//  Created by gautam  on 10/05/23.
//

import Foundation
class WifiData{
    class var instanceHelper: WifiData {
        struct Static {
            static let instance = WifiData()
        }
        return Static.instance
    }
    var start:Int = 0
    var end :Int = 0
    var setOfIpsInThread: Int = 20
    var noOfThreads: Int = 0
   
    
}
