//
//  PurchaseReceiptResponse.swift
//  AppEngine
//
//  Created by Deepti Chawla on 20/05/21.
//

import Foundation

import UIKit

public class PurchaseReceiptResponse: NSObject {

    var expires_date = String()
    var expires_date_ms = String()
    var expires_date_pst = String()
    var original_purchase_date_ms = String()
    var original_purchase_date = String()
    var original_transaction_id = String()
    var product_id = String()
    var purchase_date = String()
    var purchase_date_ms = String()
    var purchase_date_pst = String()
    var subscription_group_identifier = String()
    var transaction_id = String()
    var web_order_line_item_id = String()

   public  func getPurchaseRecieptResponseData(dataArray : [[String:Any]]) -> [PurchaseReceiptResponse] {
        var tempArray = [PurchaseReceiptResponse]()

        for i in 0..<dataArray.count {
            let info = PurchaseReceiptResponse()
            info.expires_date = notnull("expires_date",dataArray[i])
            info.expires_date_ms = notnull("expires_date_ms",dataArray[i])
            info.expires_date_pst  = notnull("expires_date_pst",dataArray[i])
            info.original_purchase_date_ms =
                notnull("original_purchase_date_ms",dataArray[i])
            info.original_purchase_date =     notnull("original_purchase_date",dataArray[i])
            info.product_id =    notnull("product_id",dataArray[i])
            info.purchase_date =  notnull("purchase_date",dataArray[i])
            info.purchase_date_ms  =  notnull("purchase_date_ms",dataArray[i])
            info.purchase_date_pst =   notnull("purchase_date_pst",dataArray[i])
            info.subscription_group_identifier =  notnull("subscription_group_identifier",dataArray[i])
            info.transaction_id  =    notnull("transaction_id",dataArray[i])
            info.web_order_line_item_id  =      notnull("web_order_line_item_id",dataArray[i])
            tempArray.append(info)
        }
        return tempArray
    }

}






