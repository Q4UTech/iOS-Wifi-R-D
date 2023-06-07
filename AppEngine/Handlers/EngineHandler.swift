//
//  EngineHandler.swift
//  App Engine
//
//  Created by Quantum_MAC_7 on 16/03/20.
//  Copyright © 2020 Pulkit Babbar. All rights reserved.
//

import Foundation
import UIKit

import CommonCrypto
import CryptoSwift



var osVersion = String()
var appVersionInfo = String()
var countryname = String()
var screenWidth = CGFloat()
var screenHeight = CGFloat()
var deviceName = String()
var deviceModel = String()
var systemversion = String()
var appID = String()
var jSonString = String()
var hexadecimal = String()
var encod = Data()
var decryptvalue = String()
var dictnry = String()

let versionapi = "adservicevfour/checkappstatus?engv=4"
let masterapi = "adservicevfour/adsresponse?engv=4"
let fcmApi = "gcm/requestgcm?engv=4"
let topicApi = "gcm/requestgcmv4?engv=3"
let inAppApi = "inappreporting/successInapp?engv=4"

func initService( _ fetchFromServer:Bool, launchCount:Int, deviceToken:String){
 
    DispatchQueue.global(qos: .background).async {
        DispatchQueue.main.async {
            if fetchFromServer {
                doVersionRequest(launchCount,deviceToken,fetchFromServer)
            }else{

                if UserDefaults.standard.string(forKey: MASTER_RESPONSE_VALUE) != nil{
                    let  masterresponse = UserDefaults.standard.string(forKey: MASTER_RESPONSE_VALUE) ?? ""
                    if defaultvalue != masterresponse {
                        UserDefaults.standard.set(masterresponse, forKey: SERVER_DEFAULT_VALUE)
                    }
                }
                else{
                    UserDefaults.standard.set(defaultvalue, forKey: SERVER_DEFAULT_VALUE)
                }
                let defaultResponse = getDefaultAdsResponse(UserDefaults.standard.string(forKey: SERVER_DEFAULT_VALUE) ?? "")
                let code = defaultResponse["status"] as! String
                if(code == "0"){
                    parseDecryptMasterData(defaultResponse,fetchFromServer)
                }
            }
        }
    }
}


func  doVersionRequest(_ launchCount:Int,_ deviceToken:String,_ fetchFromServer:Bool){
    DispatchQueue.global(qos: .background).async {
        DispatchQueue.main.async {
            var params = [String:Any]()
            
            params = ["app_id": APP_ID, "country": countryname.getCountryNameInfo(), "screen": screenHeight.getScreenHeightResolution(),"launchcount": launchCount, "version": appVersionInfo.getAppVersionInfo(), "osversion": osVersion.getOSInfo(), "dversion": systemversion.getDeviceModel(), "os": "2","identity": deviceToken]
            print(params)
            let jsonData = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            let jsonString1 = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            let encodedString = hexadecimal.encrypt(text:jsonString1)
            var parametr = [String:String]()
            parametr = ["data":encodedString!]
            ServiceHelper.sharedInstanceHelper.createPostRequest(method: .post, showHud: true, params: parametr, apiName: versionapi) { (result, error) in
                
                if result != nil{
                    let decryptString = decryptvalue.decrypt(hexString:result! as! String)
                    let dict1 = dictnry.convertToDictionary(text: decryptString!)
                    let code = dict1!["status"] as! String
                    if(code == "0"){
                        
                        let appstatus = dict1!["app_status"] as! String
                        UserDefaults.standard.set(appstatus, forKey: VERSION_STATUS)
                        
                        if  UserDefaults.standard.integer(forKey: VERSION_DEFAULT) != UserDefaults.standard.integer(forKey: VERSION_STATUS){
                            doMasterRequest(launchCount,fetchFromServer)
                            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: VERSION_STATUS), forKey: VERSION_DEFAULT)
                        }
                        else{
                            //   print("DefaultValuesfsffsfs:\(defaultvalue)")
                            
                            let defaultResponse =  getDefaultAdsResponse(UserDefaults.standard.string(forKey: SERVER_DEFAULT_VALUE) ?? "")
                            _  = UserDefaults.standard.string(forKey: SERVER_DEFAULT_VALUE)
                            let code = defaultResponse["status"] as! String
                            if(code == "0"){
                                parseDecryptMasterData(defaultResponse, fetchFromServer)
                            }
                            
                            
                        }
                        
                    }
                }
                else{
                    UserDefaults.standard.set(defaultvalue, forKey: SERVER_DEFAULT_VALUE)
                    let defaultResponse = getDefaultAdsResponse(UserDefaults.standard.string(forKey: SERVER_DEFAULT_VALUE) ?? "")
                    let code = defaultResponse["status"] as! String
                    if(code == "0"){
                        parseDecryptMasterData(defaultResponse, fetchFromServer)
                    }
                }
            }
            
        }}
}


func doMasterRequest(_ launchCount:Int,_ fetchFromServer:Bool){
    DispatchQueue.global(qos: .background).async {
        DispatchQueue.main.async {
            var params = [String:Any]()
            
            params = ["app_id": APP_ID, "country": countryname.getCountryNameInfo(), "screen": screenHeight.getScreenHeightResolution(), "launchcount": launchCount, "version": appVersionInfo.getAppVersionInfo(), "osversion": osVersion.getOSInfo(), "dversion": systemversion.getDeviceModel(), "os": "2"]
            print(params)
            let jsonData = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            let jsonString1 = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            let encodedString = hexadecimal.encrypt(text:jsonString1)
            var parametr = [String:String]()
            parametr = ["data":encodedString!]
            
            ServiceHelper.sharedInstanceHelper.createPostRequest(method: .post, showHud: true, params: parametr, apiName: masterapi) { (result, error) in
                
                if result != nil{
                    UserDefaults.standard.set(result!, forKey: MASTER_RESPONSE_VALUE)
                    let decryptString = decryptvalue.decrypt(hexString:result! as! String)
                    let dict1 = dictnry.convertToDictionary(text: decryptString!)
                    let code = dict1!["status"] as! String
                    if(code == "0"){
                        parseDecryptMasterData(dict1!, fetchFromServer)
                    }
                }
                else{
                    UserDefaults.standard.set(defaultvalue, forKey: SERVER_DEFAULT_VALUE)
                }
                
            }
        }
    }
}



func  doinAppRequest( _ launchCount:Int,_  deviceToken:String,_ productID:String){
    DispatchQueue.global(qos: .background).async {
        DispatchQueue.main.async {
            var params = [String:Any]()
            
            params = ["app_id": APP_ID, "country": countryname.getCountryNameInfo(), "screen": screenHeight.getScreenHeightResolution(),"launchcount": launchCount, "version": appVersionInfo.getAppVersionInfo(), "osversion": osVersion.getOSInfo(), "dversion": systemversion.getDeviceModel(), "os": "2","identity": deviceToken,"product_id" : productID]
            print("INAPpParams\(params)")
            let jsonData = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            let jsonString1 = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            let encodedString = hexadecimal.encrypt(text:jsonString1)
            var parametr = [String:String]()
            parametr = ["data":encodedString!]
            ServiceHelper.sharedInstanceHelper.createPostRequest(method: .post, showHud: true, params: parametr, apiName: inAppApi) { (result, error) in
                
                if result != nil{
                    let decryptString = decryptvalue.decrypt(hexString:result! as! String)
                    let dict1 = dictnry.convertToDictionary(text: decryptString!)
                    let code = dict1!["status"] as! String
                  
                    if(code == "0"){

                     print("InAppPurchase successfully")

                    }else{
                        print("InAppPurchase something went wrong...")
                    }
                }
                else{
                    print("InAppPurchase something went wrong...")
                }
            }
            
        }}
}



