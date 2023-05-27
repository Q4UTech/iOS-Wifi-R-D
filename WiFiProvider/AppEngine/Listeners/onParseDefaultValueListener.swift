//
//  onParseDefaultValueListener.swift
//  Q4U-PhoneSwtich
//
//  Created by Deepti Chawla on 28/04/22.
//

import Foundation
protocol onParseDefaultValueListenerProtocol: class {
   
    func  onParsingCompleted()
  
}

class onParseDefaultValueListener: NSObject{
    var onParseDefaultDelegates: onParseDefaultValueListenerProtocol?
    
    class var adsInstanceHelper: onParseDefaultValueListener {
        struct Static {
            static let instance = onParseDefaultValueListener()
        }
        return Static.instance
    }
    
    func parseCompleted(){
        onParseDefaultDelegates?.onParsingCompleted()
    }
    
    
}
