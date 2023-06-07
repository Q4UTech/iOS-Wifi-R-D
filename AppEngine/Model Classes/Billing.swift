//
//  Billing.swift
//  CustomGallery
//
//  Created by Pulkit Babbar on 29/07/20.
//  Copyright © 2020 Pavle Pesic. All rights reserved.
//

import Foundation

public class Billing: NSObject {
    
    public var billing_type = String()
    public var priority = String()
    public var product_id  = String()
    public var product_price = String()
    public var product_description = String()
    public var product_offer_status = String()
    public var product_offer_text  = String()
    public var product_offer_sub_text = String()
    public var button_text = String()
    public var product_offer_src = String()
    public var button_sub_text  = String()
    public var feature_src = String()
    public var details_page_type = String()
    public var details_src  = String()
    public var details_description = String()
   public func getBillingData(dataArray : [[String:Any]]) -> [Billing] {
        
        var tempArray = [Billing]()
        for i in 0..<dataArray.count {
            let info = Billing()
            info.billing_type =  notnull("billing_type",dataArray[i])
            info.priority  = notnull("priority",dataArray[i])
            info.product_id =  notnull("product_id",dataArray[i])
            info.product_price =  notnull("product_price",dataArray[i])
            info.product_description =  notnull("product_description",dataArray[i])
            info.product_offer_status  = notnull("product_offer_status",dataArray[i])
            info.product_offer_text =  notnull("product_offer_text",dataArray[i])
            info.product_offer_sub_text =  notnull("product_offer_sub_text",dataArray[i])
            info.product_offer_src =  notnull("product_offer_src",dataArray[i])
            info.button_text  = notnull("button_text",dataArray[i])
            info.button_sub_text =  notnull("button_sub_text",dataArray[i])
            info.feature_src =  notnull("feature_src",dataArray[i])
            info.details_page_type  = notnull("details_page_type",dataArray[i])
            info.details_src =  notnull("details_src",dataArray[i])
            info.details_description =  notnull("details_description",dataArray[i])
          
            tempArray.append(info)
        }
        return tempArray
        
    }
    
}

