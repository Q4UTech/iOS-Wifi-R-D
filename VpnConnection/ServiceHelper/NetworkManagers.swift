//
//  NetworkManagers.swift
//  WiFiProvider
//
//  Created by gautam  on 16/05/23.
//

import Foundation
import Alamofire
import SystemConfiguration

public final class NetworkManagers {
    let HOST_URL = "https://quantum4you.com/engine/"
    let FITNESS_BASE_URL = "https://quantum4you.com/engine/"
    private  var countryApi = "vpnserviceapi/response"
    public let DEVICE_TOKEN = "DEVICE_TOKEN"
    public  let LAUNCH_COUNT = "LAUNCH_COUNT"
    public class var sharedInstanceHelper: NetworkManagers {
        struct Static {
            static let instance = NetworkManagers()
        }
        return Static.instance
    }
    
    
    func getCategory(networkListner:@escaping (_ response: CountryList?,
                                               _ error: String?) -> Void){
        
        var params = [String:Any]()
        
        let launchcount = UserDefaults.standard.integer(forKey: LAUNCH_COUNT)
        let device_token = UserDefaults.standard.string(forKey: DEVICE_TOKEN)
        //"app_id":"v4vpnm24",
        params = ["app_id":APP_ID,
                  "country": getCountryNameInfo(),
                  "screen": getScreenWidthResolution(),
                  "launchcount": "1",
                  "version": getAppVersionInfo(),
                  "osversion": getOSInfo(),
                  "dversion": "iphone",
                  "os": "2"]
        
        //print("Params\(params)")
        
        createVpnRequest(params:params,apiName:countryApi, commonNetworkListner:networkListner)
    }
    
    
    private func createVpnRequest<T>(
        params:[String:Any],apiName: String,
        commonNetworkListner:@escaping (
            _ response: T?,
            _ error: String?) -> Void) where T: Decodable {
                
                //                if isConnectedToNetwork() {
                let url = FITNESS_BASE_URL + apiName
                
                print("CheckURL\(url)  \(params)")
                
                Alamofire.request(url, method: .post, parameters : params, encoding: JSONEncoding.default).responseData { response in
                    
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
    
    
    private func createPostRequest<T>(
        params:[String:Any],apiName: String,
        commonNetworkListner:@escaping (
            _ response: T?,
            _ error: String?) -> Void) where T: Decodable {
                
                //                if isConnectedToNetwork() {
                let url = FITNESS_BASE_URL + apiName
                
                print("CheckURL\(url)  \(params)")
                
                Alamofire.request(url, method: .post, parameters : params, encoding: JSONEncoding.default).responseData { response in
                    
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
    
    //    func getDeviceModel()->String{
    //        //let model = UIDevice.current.model
    //        let model  = UIDevice.current.userDevicemodelName
    //
    //        return model
    //    }
    
    func getSystemVersion()->String{
        let systemVersion = UIDevice.current.systemVersion
        return systemVersion
    }
    
    
    
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func getScreenHeightResolution()->CGFloat{
        let screenSize: CGRect = UIScreen.main.bounds
        return screenSize.height
    }
    
    func getScreenWidthResolution()->CGFloat{
        let screenSize: CGRect = UIScreen.main.bounds
        return screenSize.width
    }
    
}


