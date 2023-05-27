//
//  TopicRequest.swift
//  CustomGallery
//
//  Created by Deepti Chawla on 14/07/20.
//  Copyright © 2020 Pavle Pesic. All rights reserved.
//

import Foundation




class TopicRequest : Codable {

    var parametr = [String:String]()
    var topicNam = String()
var tempArray = [TopicRequest]()
    init(topicName:String)  {
        parametr = ["topicName": topicName]
        let jsonData = try! JSONSerialization.data(withJSONObject: parametr, options: .prettyPrinted)
       self.topicNam = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
         
    }
    
   
  


}




