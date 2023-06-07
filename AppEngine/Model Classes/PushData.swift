//
//  PushData.swift
//  CustomGallery
//
//  Created by Deepti Chawla on 15/07/20.
//  Copyright © 2020 Pavle Pesic. All rights reserved.
//

import Foundation

class PushData:NSObject{
    var reqvalue = String()
         
    
    
    func getPushData(dataArray : [String:Any]) -> PushData {
           let info = PushData()

                     info.reqvalue = dataArray.validatedValue("reqvalue", expected: String() as AnyObject) as! String
                    
                     return info
    }
               
}

