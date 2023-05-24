//
//  NetworkHelper.swift
//  WiFiProvider
//
//  Created by gautam  on 12/05/23.
//

import Foundation
import Alamofire
import SystemConfiguration
import CryptoSwift

let HOST_URL = "https://quantum4you.com/engine"
let api = "/wifiauthservice/authkey"

let PASSWORD_URL = "https://quantum4you.com/engine/wifiauthservice"


class NetworkHelper{
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
    public class var sharedInstanceHelper: NetworkHelper {
        struct Static {
            static let instance = NetworkHelper()
        }
        return Static.instance
    }
    
    
    func getPasswordApiData(networkListner:@escaping(_ response: PasswordData?,
                                                    _ error: String?) -> Void)
    {
        let url = PASSWORD_URL + "/routerlist/v5wifitrackernew"
        callPasswordApi( apiName: url, commonNetworkListner:networkListner)
    }
    
     func callPasswordApi<T>(
       apiName: String,
        commonNetworkListner:@escaping (
            _ response: T?,
            _ error: String?) -> Void) where T: Decodable {
                
             
                if isConnectedToNetwork() {
                
                    let url = apiName
                    
                 print("url00 \(url)")
                    
                    Alamofire.request(url, method: .get ,encoding: JSONEncoding.default).responseData { response in
                        print("respnse \(response)")
                        switch response.result {
                          
                        case .success(let value):
                            print("respnse1 \(value)")
                            
                             do {
                                let jObject : Dictionary? = try JSONSerialization.jsonObject(with: value) as? Dictionary<String, Any>
                                let status = jObject!["status"] as? String
                                let array = jObject!["routerlist"] as? NSArray
                                print("status \(String(describing: status)) \(jObject)")

                                let data:Dictionary? = array![0] as? Dictionary<String, Any>
                                let brand = data!["brand"] as? String
                                let type = data!["type"] as? String
                                let username = data!["username"] as? String
                                let password = data!["passwrod"] as? String
                                print("type \(type)")

                            }catch{

                            }

                            do{
                             
                                               
                                let tObject = try JSONDecoder().decode(PasswordData.self,from: value)


                                if(tObject != nil)  {
                                    print("tObject\(String(describing: tObject))")
                                    //commonNetworkListner(tObject, nil)
                                }else{
                                    commonNetworkListner(nil, "T Object is null")
                                }
                                
                            }catch let error{
                                print("errorrrr1199\(error.localizedDescription)")
                            }
                            
                            break
                        case .failure(_):
                            print("filure11\(response.error)")
                            commonNetworkListner(nil, response.error?.localizedDescription)
                            break
                            
                            
                        }
                    }
                }
            }
   
    public func createPostRequest(method: HTTPMethod,showHud :Bool, params: [String: String]!, apiName: String, completionHandler:@escaping (_ response: AnyObject?, _ error: NSError?) -> Void) {
        
            if isConnectedToNetwork() {
              
                if showHud {
                   // self.showHud()
                }
             var url = String()
             
             
                            url = HOST_URL + apiName
                      
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
                             print("Check Almofire Failure \(response.error)")
                             completionHandler(nil, response.error as NSError?)
                             break


                         }
                     }
                
            } else {
                
                completionHandler(nil,NSError.init())
                

            }
            
            
        }
     
    
    private func createSubCategoryPostRequest<T>(
        params:[String:Any],apiName: String,
        commonNetworkListner:@escaping (
            _ response: T?,
            _ error: String?) -> Void) where T: Decodable {
                
                if isConnectedToNetwork() {
                    let url = HOST_URL + apiName
                    //                    let url = subCategoryApi1
                    
                    print("CheckURL\(url)  \(params)")
                    
                    Alamofire.request(url, method: .post, parameters : params, encoding: JSONEncoding.default).responseData { response in
                        print("respnse \(response)")
                        switch response.result {
                            
                        case .success(let value):
                            
                            do{
                                let tObject: T? = try JSONDecoder().decode(T.self,from: value)
                                
                                
                                if(tObject != nil)  {
                                    print("tObject\(tObject)")
                                    commonNetworkListner(tObject, nil)
                                }else{
                                    commonNetworkListner(nil, "T Object is null")
                                }
                                
                                
                                
                                
                            }catch let error{
                                print("errorrrr\(error.localizedDescription)")
                            }
                            
                            break
                        case .failure(_):
                            print("filure\(response.error)")
                            
                            commonNetworkListner(nil, response.error?.localizedDescription)
                            break
                            
                            
                        }
                    }
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
    func getOSInfo()->String {
           let os = ProcessInfo().operatingSystemVersion
           return String(os.majorVersion) + "." + String(os.minorVersion) + "." + String(os.patchVersion)
       }

    func getAppVersionInfo()->String {
           let dictionary = Bundle.main.infoDictionary!
           let version = dictionary["CFBundleShortVersionString"] as! String
        _ = dictionary["CFBundleVersion"] as! String
           return version
       }

    func  getCountryNameInfo()->String{
         let locale = Locale.current
         return String(locale.regionCode!)
    }

    func getDeviceName()->String{
        let devicename = UIDevice.current.name
        return devicename
    }

    func getDeviceModel()->String{
     
        let model  = UIDevice.current.userDevicemodelName
         
        return model
    }

    func getSystemVersion()->String{
        let systemVersion = UIDevice.current.systemVersion
          return systemVersion
    }


}
extension CGFloat{
    func getScreenHeightResolution()->CGFloat{
       let screenSize: CGRect = UIScreen.main.bounds
        return screenSize.height
    }
    
    func getScreenWidthResolution()->CGFloat{
          let screenSize: CGRect = UIScreen.main.bounds
           return screenSize.width
       }
}
extension String {
    
    func encrypt(text: String) -> String?  {
        if let aes = try? AES(key:"2288445566deadcd",iv:"deadcd2288445566",padding: .zeroPadding),
            let encrypted = try? aes.encrypt(Array(text.utf8)) {
            return encrypted.toHexString()
        }
        return nil
    }

    func decrypt(hexString: String) -> String? {
        if let aes = try? AES(key: "2288445566deadcd", iv: "deadcd2288445566",padding: .zeroPadding),
            let decrypted = try? aes.decrypt(Array<UInt8>(hex: hexString)) {
            return String(data: Data(_: decrypted), encoding: .utf8)
        }
        return nil
    }
    

   func convertToDictionary(text: String) -> [String: Any]? {
       if let data = text.data(using: .utf8) {
           do {
               return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
           } catch {
               print(error.localizedDescription)
           }
       }
       return nil
   }

}
