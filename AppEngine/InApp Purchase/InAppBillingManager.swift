//
//  InAppBillingManager.swift
//  AppEngine
//
//  Created by Deepti Chawla on 20/05/21.
//

import Foundation
import UIKit
import FirebaseAnalytics
public class InAppBillingManager : NSObject {
    
    public static var shared: InAppBillingManager = {
        return InAppBillingManager()
    }()
    var TAG = "InAppBillingManager"
    
    var PRODUCT_ID = "";
    var PRODUCT_TYPE = "";
    var recieptArray = [PurchaseReceiptResponse]()
    
    public func initBilling(type:String,productID:String,fromStart:Bool){
        
        self.PRODUCT_TYPE = type
        self.PRODUCT_ID = productID
        receiptValidation(fromStart: fromStart)
    }
    
    // Need to change the  it is generate by App store connect to get the response "SECRET_KEY"
    
    public func receiptValidation(fromStart:Bool) {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                let verifyReceiptURL = kSandboxRecieptURL
                let receiptFileURL = Bundle.main.appStoreReceiptURL
                if receiptFileURL != nil{
                    let receiptData = try? Data(contentsOf: receiptFileURL!)
                    if receiptData != nil{
                        let recieptString : String? = (receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))) ?? ""
                        if recieptString != nil{
                            
                            let jsonDict: [String: AnyObject] = ["receipt-data" : recieptString as AnyObject, "password" : SECRET_KEY as AnyObject]
                            do {
                                let requestData = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
                                let storeURL = URL(string: verifyReceiptURL)!
                                var storeRequest = URLRequest(url: storeURL)
                                storeRequest.httpMethod = "POST"
                                storeRequest.httpBody = requestData
                                let session = URLSession(configuration: URLSessionConfiguration.default)
                                let task = session.dataTask(with: storeRequest, completionHandler: { [weak self] (data, response, error) in
                                    
                                    do{
                                        if data != nil{
                                            let json = try JSONSerialization.jsonObject(with: data!, options: .fragmentsAllowed) as? [String : Any]
                                            
                                            if json != nil{
                                                let status = json!["status"] as! Int
                                                
                                                if status == 0{
                                                    
                                                    if json!["receipt"] != nil{
                                                        let latest_receipt_info = json!["receipt"] as? [String : Any]
                                                        
                                                        if latest_receipt_info!["in_app"] != nil{
                                                            
                                                            let inApp = latest_receipt_info!["in_app"] as? [[String : Any]]
                                                            let obj = PurchaseReceiptResponse()
                                                            self!.recieptArray = obj.getPurchaseRecieptResponseData(dataArray: inApp!)
                                                            
                                                            if self!.recieptArray.count > 0{
                                                                self!.recieptArray.sort(by: { (p0, p1) -> Bool in
                                                                    return p0.expires_date_ms < p1.expires_date_ms
                                                                })
                                                            }
                                                            
                                                            if json!["latest_receipt"] != nil{
                                                                let latest_receipt = json!["latest_receipt"] as? String
                                                                self!.recieptParsing(latest_receipt:latest_receipt!,fromStart:fromStart)
                                                            }
                                                        }
                                                        
                                                        
                                                        
                                                    }
                                                    
                                                    if data != nil{
                                                        
                                                        let jsonString = String(data: data!,
                                                                                encoding: .utf8)
                                                        
                                                        if jsonString != nil{
                                                            createTextFile(filename:"AN_INAPP_PURCHASE.txt",fileData:jsonString!)
                                                            let parameter = ["inAppStatusCode": status,"result":jsonString as Any] as [String : Any]
                                                            Analytics.logEvent("AN_INAPP_PURCHASE", parameters: parameter)
                                                        }
                                                        
                                                    }
                                                    
                                                }else{
                                                    InAppBillingListeners.adsInstanceHelper.purchaseFailed()
                                                    
                                                    
                                                    
                                                    if data != nil{
                                                        
                                                        let jsonString = String(data: data!,
                                                                                encoding: .utf8)
                                                        if jsonString != nil{
                                                            createTextFile(filename:"AN_INAPP_PURCHASE.txt",fileData:jsonString!)
                                                            let parameter = ["inAppStatusCode": status,"result":jsonString as Any] as [String : Any]
                                                            Analytics.logEvent("AN_INAPP_PURCHASE", parameters: parameter)
                                                        }
                                                        
                                                    }
                                                    
                                                    
                                                }
                                            }
                                            
                                        }
                                    }catch{
                                        
                                    }
                                    
                                })
                                task.resume()
                            } catch let parseError {
                                print(parseError)
                            }
                        }
                    }
                }
            }
        }
    }
    
    public func recieptParsing(latest_receipt:String,fromStart:Bool){
        DispatchQueue.global(qos: .background).async { [self] in
            DispatchQueue.main.async {
                
                let purchaseResponse = recieptArray.last
                let currentTime = getCurrentTime()
                if purchaseResponse != nil{
                    
                    let expireTime = purchaseResponse!.expires_date_ms
                    if expireTime != "" {
                        
                        let mBillingList = BILLING_DETAILS
                        if  mBillingList.count > 0 {
                            for billingitems in mBillingList{
                                if purchaseResponse?.product_id == "" &&  billingitems.product_id == "" {
                                    
                                }else{
                                    if billingitems.product_id == purchaseResponse!.product_id {
                                        UserDefaults.standard.setValue(expireTime, forKey: "SUBSCIPTION_EXPIRE_TIME")
                                        
                                        if Int(currentTime) > Int(expireTime)!{
                                            
                                            UserDefaults.standard.setValue(false, forKey: IN_APP_PURCHASED)
                                            InAppBillingListeners.adsInstanceHelper.purchaseFailed()
                                        }else{
                                            
                                            
                                            
                                            if !UserDefaults.standard.bool(forKey: "InAPP_FIRSTTIME"){
                                                print("FirstTime")
                                                CallonInApprequest.shared.v2CallonInAppRequest(productID: purchaseResponse!.product_id)
                                                UserDefaults.standard.set(true, forKey: "InAPP_FIRSTTIME")
                                                UserDefaults.standard.set(Int(expireTime), forKey: "INAPP_EXPIRE_TIME")
                                            }else{
                                                
                                                if UserDefaults.standard.integer(forKey:"INAPP_EXPIRE_TIME" ) != Int(expireTime)!{
                                                    CallonInApprequest.shared.v2CallonInAppRequest(productID: purchaseResponse!.product_id)
                                                    UserDefaults.standard.set(Int(expireTime), forKey: "INAPP_EXPIRE_TIME")
                                                    //                                                                                                UserDefaults.standard.set(false, forKey: "InAPP_FIRSTTIME")
                                                    
                                                }
                                            }
                                            UserDefaults.standard.setValue(true, forKey: IN_APP_PURCHASED)
                                            InAppBillingListeners.adsInstanceHelper.purchaseSuccess(productID:purchaseResponse!.product_id,expiryDate:purchaseResponse!.expires_date_ms ,latest_receipt: latest_receipt,fromStart:fromStart)
                                        }
                                    }
                                }
                                
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
}






