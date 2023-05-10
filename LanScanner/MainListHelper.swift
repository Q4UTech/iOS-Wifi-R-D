//
//  MainListHelper.swift
//  LanScanner
//
//  Created by gautam  on 09/05/23.
//

import Foundation
protocol WifiDelegate{
  func showList(list:[String])
}

class MainListHelper:NSObject,WifiDelegate{
    
    var wifiDelegate : WifiDelegate?
    
    class var instanceHelper: MainListHelper {
        struct Static {
            static let instance = MainListHelper()
        }
        return Static.instance
    }
    func showList(list: [String]) {
        wifiDelegate?.showList(list: list)
    }
    
    
}
