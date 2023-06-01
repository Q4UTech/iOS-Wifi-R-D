//
//  PurchaseJson.swift
//  Q4U_VPNAPP
//
//  Created by Deepti Chawla on 03/05/21.
//

import Foundation

import Foundation
class PurchaseJson: Codable {
    
    var orderId = String()
    var transactionId = String()
    var purchaseTime = CLong()
    var expireTime = CLong()
    var purchaseState = Int()
    var trialLength = Int()
    var usdAmount = Float()
    var originalPurchaseTime = CLong()
    var planName = String()
    var type  = String()
    
    init(orderId:String,transactionId : String ,purchaseTime : CLong, expireTime : CLong, purchaseState : Int, trialLength : Int, usdAmount: Float, originalPurchaseTime : CLong, planName : String, type  : String) {
        self.orderId = orderId
        self.transactionId = transactionId
        self.purchaseTime = purchaseTime
        self.expireTime = expireTime
        self.purchaseState = purchaseState
        self.trialLength = trialLength
        self.usdAmount = usdAmount
        self.originalPurchaseTime = originalPurchaseTime
        self.planName = planName
        self.type = type
    }
 
}



