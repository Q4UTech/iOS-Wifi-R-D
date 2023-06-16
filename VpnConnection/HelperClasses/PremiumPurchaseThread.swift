//
//  PremiumPurchaseThread.swift
//  VpnConnection
//
//  Created by gautam  on 16/06/23.
//

import Foundation

class PremiumPurchaseThread:Thread{
    
    var vc:PurchaseVC?=nil
    
    func setPurchaseVC(_ vc:PurchaseVC){
        self.vc=vc;
    }
    
    override func main() {
        vc?.callPremium()
    }
}
