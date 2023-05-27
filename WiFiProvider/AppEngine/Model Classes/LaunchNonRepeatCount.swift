//
//  LaunchNonRepeatCount.swift
//  App Engine
//
//  Created by Quantum_MAC_7 on 18/03/20.
//  Copyright © 2020 Pulkit Babbar. All rights reserved.
//

import Foundation


class LaunchNonRepeatCount: NSObject {

       var launch_rate = String()
       var launch_exit = String()
       var launch_full  = String()
       var launch_removeads = String()
 
      func getLaunchNonRepeatData(dataArray : [[String:Any]]) -> [LaunchNonRepeatCount] {
         var tempArray = [LaunchNonRepeatCount]()
             for i in 0..<dataArray.count {
                    let info = LaunchNonRepeatCount()
                   
                    info.launch_rate =  notnull("launch_rate",dataArray[i])
                    info.launch_exit  = notnull("launch_exit",dataArray[i])
                    info.launch_removeads =  notnull("launch_removeads",dataArray[i])
                    info.launch_full =  notnull("launch_full",dataArray[i])
                   
                     tempArray.append(info)
                    }
                return tempArray
                
            }

}
