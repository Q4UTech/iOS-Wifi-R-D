//
//  InHouseHelper.swift
//  App Engine
//
//  Created by Quantum_MAC_7 on 27/03/20.
//  Copyright © 2020 Pulkit Babbar. All rights reserved.
//

import Foundation
import UIKit


protocol InhouseListenerProtocol: class {
 
    func onInhouseDownload(inHouse:Inhouse,viewController:UIViewController)
    
}


class InHouseHelper{
    var inhousedelegate: InhouseListenerProtocol?
    
    class var inHouseInstanceHelper: InHouseHelper {
        struct Static {
            static let instance = InHouseHelper()
        }
        return Static.instance
    }
    
    func onInhouseDownload(inHouse:Inhouse,viewController:UIViewController){
      
        inhousedelegate?.onInhouseDownload(inHouse: inHouse,viewController: viewController)

    }
    
}
