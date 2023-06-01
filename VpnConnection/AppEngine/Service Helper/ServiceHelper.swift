//
//  ServiceHelper.swift
//  App Engine
//
//  Created by Quantum4U1 on 10/02/20.
//  Copyright © 2020 Pulkit Babbar. All rights reserved.
//

import Foundation
import Alamofire
import SystemConfiguration

//import AWSCore



public final class ServiceHelper {
    let HOST_URL = "https://quantum4you.com/engine/"
    //shared instance of Class
    let BASE_URL = "https://appservices.in/engine/"
   public class var sharedInstanceHelper: ServiceHelper {
        struct Static {
            static let instance = ServiceHelper()
        }
        return Static.instance
    }

    
   public func createPostRequest(method: HTTPMethod,showHud :Bool, params: [String: String]!, apiName: String, completionHandler:@escaping (_ response: AnyObject?, _ error: NSError?) -> Void) {
       
           if isConnectedToNetwork() {
             
               if showHud {
                  // self.showHud()
               }
            var url = String()
            
             if apiName.contains("requestnotification") || apiName.contains("requestgcmv4") || apiName.contains("requestgcm"){
                             url = BASE_URL + apiName
                      }else{
                           url = HOST_URL + apiName
                      }
               print("Internet Connected111 \(NetworkReachabilityManager.init()?.isReachable)")
             Alamofire.request(url, method: .post, parameters : params, encoding: JSONEncoding.default).responseJSON { response in
                 
                 print("Internet Connected")
                        switch response.result {
                            
                        case .success(let value):
                         //   self.hideHud()
                            let dict = value as! [String:String]
                              
                                 let dictValues = [String](dict.values)
                                 let value  = dictValues[0]
                                

                            completionHandler(value as AnyObject?, nil)
                            break


                        case .failure(_):
                         //   self.hideHud()
                            print("Check Almofire Failure")
                            completionHandler(nil, response.error as NSError?)
                            break


                        }
                    }
               
           } else {
               
               completionHandler(nil,NSError.init())
               

           }
           
           
       }
    
    
    public func isConnectedToNetwork() -> Bool {
           var zeroAddress = sockaddr_in()
           zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
           zeroAddress.sin_family = sa_family_t(AF_INET)
           
           guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
               $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                   SCNetworkReachabilityCreateWithAddress(nil, $0)
               }
           }) else {
               return false
           }
           
           var flags: SCNetworkReachabilityFlags = []
           if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
               return false
           }
           if flags.isEmpty {
               return false
           }
           
           let isReachable = flags.contains(.reachable)
           let needsConnection = flags.contains(.connectionRequired)
           
           return (isReachable && !needsConnection)
       }
    
    
    
    
}
