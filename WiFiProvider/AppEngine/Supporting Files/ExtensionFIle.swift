//
//  ExtensionFIle.swift
//  App Engine
//
//  Created by Quantum4U1 on 10/02/20.
//  Copyright © 2020 Pulkit Babbar. All rights reserved.
//

import Foundation
import UIKit

import CommonCrypto
import CryptoSwift
import StoreKit

extension String {

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
        //let model = UIDevice.current.model
        let model  = UIDevice.current.userDevicemodelName
         
        return model
    }
    
    func getSystemVersion()->String{
        let systemVersion = UIDevice.current.systemVersion
          return systemVersion
    }
    
    
    func aesEncrypt(key:String, iv:String, options:Int = kCCOptionPKCS7Padding) -> String? {
        if let keyData = key.data(using: String.Encoding.utf8),
            let data = self.data(using: String.Encoding.utf8),
            let cryptData    = NSMutableData(length: Int((data.count)) + kCCBlockSizeAES128) {


            let keyLength              = size_t(kCCKeySizeAES128)
            let operation: CCOperation = UInt32(kCCEncrypt)
            let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmAES128)
            let options:   CCOptions   = UInt32(options)



            var numBytesEncrypted :size_t = 0

            let cryptStatus = CCCrypt(operation,
                                      algoritm,
                                      options,
                                      (keyData as NSData).bytes, keyLength,
                                      iv,
                                      (data as NSData).bytes, data.count,
                                      cryptData.mutableBytes, cryptData.length,
                                      &numBytesEncrypted)

            if UInt32(cryptStatus) == UInt32(kCCSuccess) {
                cryptData.length = Int(numBytesEncrypted)
                let base64cryptString = cryptData.base64EncodedString(options: .lineLength64Characters)
                return base64cryptString
            }
            else {
                return nil
            }
        }
        return nil
    }
    
    

    func aesDecrypt(key:String, iv:String, options:Int = kCCOptionPKCS7Padding) -> String? {
        if let keyData = key.data(using: String.Encoding.utf8),
            let data = NSData(base64Encoded: self, options: .ignoreUnknownCharacters),
            let cryptData    = NSMutableData(length: Int((data.length)) + kCCBlockSizeAES128) {

            let keyLength = size_t(kCCKeySizeAES128)
            let operation: CCOperation = UInt32(kCCDecrypt)
            let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmAES128)
            let options:   CCOptions   = UInt32(options)

            var numBytesEncrypted :size_t = 0
            let cryptStatus = CCCrypt(operation,
                                      algoritm,
                                      options,
                                      (keyData as NSData).bytes, keyLength,
                                      iv,
                                      data.bytes, data.length,
                                      cryptData.mutableBytes, cryptData.length,
                                      &numBytesEncrypted)

            if UInt32(cryptStatus) == UInt32(kCCSuccess) {
                cryptData.length = Int(numBytesEncrypted)
                let unencryptedMessage = String(data: cryptData as Data, encoding:String.Encoding.utf8)
                return unencryptedMessage
            }
            else {
                return nil
            }
        }
        return nil
    }

  func json(from object:Any) -> String? {
      guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
          return nil
      }
      return String(data: data, encoding: String.Encoding.utf8)
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

extension Bundle {
    static func appName() -> String {
        guard let dictionary = Bundle.main.infoDictionary else {
            return ""
        }
        if let version : String = dictionary["CFBundleName"] as? String {
            return version
        } else {
            return ""
        }
    }
}




/// Banner position
   enum BannerPosition {
       case bottom
       case top
   }

 var bannerPosition = BannerPosition.bottom


    func setBannerToOnScreenPosition(_ bannerAd: UIView, from viewController: UIViewController?) {
      
        guard let viewController = viewController else { return }

        switch bannerPosition {
        case .bottom:
            bannerAd.center = CGPoint(x: viewController.view.frame.midX, y: viewController.view.frame.maxY - (bannerAd.frame.height / 2))
        case .top:
            bannerAd.center = CGPoint(x: viewController.view.frame.midX, y: viewController.view.frame.minY + (bannerAd.frame.height / 2))
        }
    }

    func setBannerToOffScreenPosition(_ bannerAd: UIView, from viewController: UIViewController?) {
        
     
        guard let viewController = viewController else { return }

        switch bannerPosition {
        case .bottom:
            bannerAd.center = CGPoint(x: viewController.view.frame.midX, y: viewController.view.frame.maxY + (bannerAd.frame.height / 2))
        case .top:
            bannerAd.center = CGPoint(x: viewController.view.frame.midX, y: viewController.view.frame.minY - (bannerAd.frame.height / 2))
        }
    }

   

    func  getStringtoInt(data:String) -> Int{

        if let myNumber = NumberFormatter().number(from: data) {
            let myInt = myNumber.intValue
          return myInt
        } else {
            return 0
        }
    }


func getInstallationTime() -> Int64 {
    let urlToDocumentsFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
      //installDate is NSDate of install
    let installDate = (try! FileManager.default.attributesOfItem(atPath: urlToDocumentsFolder.path)[FileAttributeKey.creationDate])
    let millisecnds = (installDate! as AnyObject).timeIntervalSince1970
     
    return Int64(millisecnds!)
   
}


func getDaysDiff() -> Int {
    do{
        let day = getCurrentMillis() - getInstallationTime()
       
        let days = day / 86400
       
        return Int(days)
    }catch {
        return 0
    }
    
 
}
       
func getCurrentMillis()->Int64 {
    return Int64(Date().timeIntervalSince1970)
}


func setFulladsCount(_ viewController:UIViewController,_ data:Int) {

    var count = UserDefaults.standard.integer(forKey: FULLSERVICECOUNT)
    count  = count + 1
   
   
       if (data >= 0) {
        count = data
     
       }
    print("dataCheck\(data)  \(count) \(UserDefaults.standard.integer(forKey: FULLSERVICECOUNT))")
    UserDefaults.standard.set(count, forKey: FULLSERVICECOUNT)
   }


func  getFullAdsCount(_ viewController:UIViewController) -> Int {
      let data = UserDefaults.standard.integer(forKey: FULLSERVICECOUNT)
      print("GetFullAdsCount\(data)")
     return data
  }

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return UIColor.gray
    }

    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}


func progressLoader(_ view : UIView){
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
               indicator.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
               indicator.center = view.center
               view.addSubview(indicator)
               view.bringSubviewToFront(indicator)
               UIApplication.shared.isNetworkActivityIndicatorVisible = true
               indicator.startAnimating()
}



func  getDateofLos_Angeles() -> String {
    
    let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "dd-MMM-yyyy"
       var timeZone = TimeZone.current
       timeZone = TimeZone(identifier: "America/Los_Angeles")!
       dateFormatter.timeZone = timeZone
      let dateInFormat = dateFormatter.string(from: Date())
     
       return dateInFormat
  }

func  getMonthofLos_Angeles() -> String {
  
  let dateFormatter = DateFormatter()
     dateFormatter.dateFormat = "MMM-yyyy"
     var timeZone = TimeZone.current
     timeZone = TimeZone(identifier: "America/Los_Angeles")!
     dateFormatter.timeZone = timeZone
    let dateInFormat = dateFormatter.string(from: Date())
     return dateInFormat
}


func  validateJavaDate(strDate : String) -> Bool {
    /* Check if date is 'null' */
    if strDate == "" {
        return true
    }
    /* Date is not 'null' */
    else {
        /*
         * Set preferred date format,
         * For example MM-dd-yyyy, MM.dd.yyyy,dd.MM.yyyy etc.*/
        let sdfrmt = DateFormatter()
        sdfrmt.isLenient = false
    
        return true
    }
}


func  getDate(_ time:CLong) -> String {
     let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        dateFormatter.locale = Locale(identifier: "en_US")
        let dateInFormat = dateFormatter.string(from: Date())
        return dateInFormat
}


func  generateUniqueId() -> String {
    
    let unique_id = Int(Date().timeIntervalSince1970)*1000000 + getRandomNo()
   
    return String(unique_id)
 }


 func  getRandomNo() -> Int {
     let randomInt = Int.random(in: 10000000..<99000000)
   
     return randomInt
 }

public func getBannerAd(_ self:UIViewController, _ adView:UIView, _ adViewHeightConstraint:NSLayoutConstraint){

        if ServiceHelper.sharedInstanceHelper.isConnectedToNetwork(){
            
           // if ETC_1 == "1" {
                    BannerFooter.bannerFooterInstance.getBannerFooter(self,adView,adViewHeightConstraint)
//            }else{
//
//                    BannerHeader.bannerHeaderInstance.getBannerHeader(self,adView,adViewHeightConstraint)
//            }
        }
        else{
            adViewHeightConstraint.constant = 0
        }
}

public extension UIDevice {

    /// pares the deveice name as the standard name
    var userDevicemodelName: String {

        #if targetEnvironment(simulator)
            let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]!
        #else
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8 , value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
        #endif

        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
        case "iPhone11,8":                              return "iPhone XR"
        case "iPhone12,1":                              return "iPhone 11"
        case "iPhone12,3":                              return "iPhone 11 Pro"
        case "iPhone12,5":                              return "iPhone 11 Pro Max"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad7,5", "iPad7,6":                      return "iPad 6"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
        default:                                        return identifier
        }
    }

}

func setOpenadsCount(_ viewController:UIViewController,_ data:Int) {
   
    var count = UserDefaults.standard.integer(forKey: OPEN_ADS_COUNT)
    count  = count + 1
   
       if (data >= 0) {
          count = data
       }
      UserDefaults.standard.set(count, forKey: OPEN_ADS_COUNT)
   }

func  getOpenAdsCount(_ viewController:UIViewController) -> Int {
      let data = UserDefaults.standard.integer(forKey: OPEN_ADS_COUNT)
     
     return data
  }



public func rateApp(showCustom:Bool,self:UIViewController) {
    if showCustom{
        if getStringtoInt(data: ETC_5) == 1{
            appStoreNativeRateApp()
        }else if getStringtoInt(data: ETC_5) == 2{
            rateUsDialog(self:self)
        }else if getStringtoInt(data: ETC_5) == 0{
            
        }
    }else{
    // EngineDelegate.excludeControllersArr.insert("NATIVE_RATE_APP", at: 4)
        appStoreNativeRateApp()
    }
}


func appStoreNativeRateApp(){
    if #available(iOS 10.3, *) {
        SKStoreReviewController.requestReview()
    }else if let url = URL(string: RATE_APP_rateurl) {
    if #available(iOS 10, *){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

func rateUsDialog(self:UIViewController){
    if #available(iOS 13.0, *) {
               let popOverVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(identifier: "RateAppViewController") as! RateAppViewController
               self.addChild(popOverVC)
               popOverVC.view.frame = self.view.frame
               self.view.addSubview(popOverVC.view)
               popOverVC.didMove(toParent: self)
           }
           else{
               let popOverVC =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "RateAppViewController")
               self.addChild(popOverVC)
               popOverVC.view.frame = self.view.frame
               self.view.addSubview(popOverVC.view)
               popOverVC.didMove(toParent: self)
           }
}


func createTextFile(filename:String,fileData:String){
   

    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

        let fileURL = dir.appendingPathComponent(filename)

        //writing
        do {
            try fileData.write(to: fileURL, atomically: false, encoding: .utf8)
        }
        catch {/* error handling here */}

       
       
    }
}


func showStatusbarStatus(status:Bool){
    UIApplication.shared.isStatusBarHidden = status
}


extension UIViewController {

func showToast(message : String, font: UIFont) {

    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-180, width: 200, height: 35))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
} }
