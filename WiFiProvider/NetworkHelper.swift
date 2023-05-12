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
    
    
    func getWifiKey(networkListner:@escaping (_ response: String?,
                                                    _ error: String?) -> Void){
        
        var params = [String:Any]()
        
        
        
      //  params = ["app_id": "m24screenrecios"]
        params = ["app_id": "v5wifitrackernew",
                  "country": getCountryNameInfo(),
                  "screen": "XHDPI",
                  "launchcount": "1",
                  "version": getAppVersionInfo(),
                  "osversion": getOSInfo(),
                  "dversion": getDeviceModel(),
                  "os": "2"]
        print(params)
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        let jsonString1 = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        let encodedString = hexadecimal.encrypt(text:jsonString1)
      //  var parametr = [String:String]()
        //print("Params\(params)")
        print("param \(params)")
        createPostRequest(params:params, apiName:api, commonNetworkListner:networkListner)
    }
    
    
    private func createPostRequest<T>(
        params:[String:Any],apiName: String,
        commonNetworkListner:@escaping (
            _ response: T?,
            _ error: String?) -> Void) where T: Decodable {
                
                if isConnectedToNetwork() {
                    let url = HOST_URL + apiName
                    
                    print("CheckURL\(url)  \(params)")
                    
                    Alamofire.request(url, method: .post, parameters : params, encoding: JSONEncoding.default).responseData { [self] response in
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
                                
//                                let dict = value as! [String:String]
//
//                                     let dictValues = [WifiKey](dict.values)
//                                     let value  = dictValues[0]
//
//
//                                commonNetworkListner(value as AnyObject? as! T, nil)
                                
                                
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
    
    
    func getMucicSubCategory(cat_id:String,networkListner:@escaping (_ response: WifiKey?,
                                                                     _ error: String?) -> Void){
        
        var params = [String:Any]()
        
        // print("cat_id1\(cat_id)")
        
        params = ["app_id": "v5iosmeditationm24","cat_id":cat_id]
        
        //print("Params\(params)")
        createSubCategoryPostRequest(params:params, apiName: HOST_URL,commonNetworkListner:networkListner)
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
    //func getAllData(networkListner:@escaping (_ response: MusicList?,
    //                                           _ error: String?) -> Void){
    //
    //    var params = [String:Any]()
    //
    //
    //
    //    params = ["app_id": "v5iosmeditationm24","cat_id":"all"]
    //
    //    //print("Params\(params)")
    //    createSubCategoryPostRequest(params:params, apiName: subCategoryApi,commonNetworkListner:networkListner)
    //}
    
    
    
    
    
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
