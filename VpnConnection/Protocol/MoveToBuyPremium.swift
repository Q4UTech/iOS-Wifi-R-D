//
//  MoveToBuyPremium.swift
//  Q4U_VPNAPP
//
//  Created by Deepti Chawla on 10/05/21.
//

import Foundation



protocol MoveToBuyPremiumDelegate: class {
    /// SwiftyAd did open
    
    func moveToBuyPremium(status:Bool)
    
}


class MoveToBuyPremium : NSObject {
    
    var itemdelegates: MoveToBuyPremiumDelegate?
    class var instanceHelper: MoveToBuyPremium {
        struct Static {
            static let instance = MoveToBuyPremium()
        }
        return Static.instance
    }
    
    func moveToBuyPremium(status:Bool){

        itemdelegates?.moveToBuyPremium(status: status)
    }
    
    
}

