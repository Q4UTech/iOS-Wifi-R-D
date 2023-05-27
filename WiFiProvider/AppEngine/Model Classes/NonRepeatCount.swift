//
//  NonRepeatCount.swift
//  App Engine
//
//  Created by Quantum_MAC_7 on 18/03/20.
//  Copyright © 2020 Pulkit Babbar. All rights reserved.
//

import Foundation

class NonRepeatCount: NSObject {

       var rate = String()
       var exit = String()
       var full  = String()
       var removeads = String()
    
 
    func getNonRepeatData(dataArray : [[String:Any]]) -> [NonRepeatCount] {
         
        var tempArray = [NonRepeatCount]()
             for i in 0..<dataArray.count {
                    let info = NonRepeatCount()
                   
                    info.rate =  notnull("rate",dataArray[i])
                    info.exit  = notnull("exit",dataArray[i])
                    info.full =  notnull("full",dataArray[i])
                    info.removeads =  notnull("removeads",dataArray[i])
                     tempArray.append(info)
                    }
                return tempArray
                
            }

}
