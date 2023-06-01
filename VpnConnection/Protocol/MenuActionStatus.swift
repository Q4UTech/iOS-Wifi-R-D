//
//  MenuActionStatus.swift
//  Q4U_VPNAPP
//
//  Created by Deepti Chawla on 14/04/21.
//

import Foundation

import UIKit
protocol MenuActionStatusDelegate: class {
    /// SwiftyAd did open
    
    func menuSelection(sender:UIButton)
    
}

class MenuActionStatus: NSObject{
    var itemdelegates: MenuActionStatusDelegate?
    
    class var instanceHelper: MenuActionStatus {
        struct Static {
            static let instance = MenuActionStatus()
        }
        return Static.instance
    }
    
    func menuSelection(sender:UIButton){

        itemdelegates?.menuSelection(sender: sender)
    }
    
    
}
