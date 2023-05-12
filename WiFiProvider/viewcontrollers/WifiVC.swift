//
//  DashboardVC.swift
//  WiFiProvider
//
//  Created by gautam  on 27/04/23.
//

import UIKit
import FingKit
import NetworkExtension
import SystemConfiguration
 

class WifiVC: UIViewController {
    @IBOutlet weak var adView:UIView!
    @IBOutlet weak var heightConstraint:NSLayoutConstraint!
    @IBOutlet weak var transView:UIView!
    @IBOutlet weak var bottomSheet:UIView!
    @IBOutlet weak var noWifi:UIView!
    var decryptvalue = String()
    var dictnry = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideView))
                transView.addGestureRecognizer(tapGesture)
      
       
        if #available(iOS 14.0, *) { NEHotspotNetwork.fetchCurrent { network in if network != nil { print("is secured ((network.isSecure))") } } }
      
    }
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        checkWifi()
    }
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
       checkWifi()
    }
    
    
    
    
    private func checkWifi(){
        if isWiFiConnected(){
            showWifiView(status:true)
            networkCall()
           
        }else{
            showWifiView(status:false)
        }
    }
    
    private func  showWifiView(status:Bool){
        noWifi.isHidden = status
    }
    
    private func networkCall(){
        NetworkHelper.sharedInstanceHelper.getWifiKey(networkListner: { [self] wifiKey,error  in
            if wifiKey != nil {
                if wifiKey != nil{
                    let decryptString = decryptvalue.decrypt(hexString:wifiKey as! String)
                    let dict1 = dictnry.convertToDictionary(text: decryptString!)
                    let code = dict1!["status"] as! String
                    print("code111 \(code)")
                }
             }
            })
        getConnectedDevicesList()
    }
    

    @IBAction func openMenu(_ sender:UIButton){
        hideUnhideMenuView(showTrans: false, showMenu: false)
       
    }
    
    @IBAction func connectToWifi(_ sender:UIButton){
        if let url = URL(string:"App-Prefs:root=WIFI") {
          if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
              UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
              UIApplication.shared.openURL(url)
            }
          }
        }
    }
    
    private func hideUnhideMenuView(showTrans:Bool,showMenu:Bool){
        transView.isHidden = showTrans
        bottomSheet.isHidden = showMenu
    }
    @objc func hideView() {
        hideUnhideMenuView(showTrans: true, showMenu: true)
       }
    
    
    private func getConnectedDevicesList(){
        FingScanner.sharedInstance().validateLicenseKey("licenseField.text", withToken: nil) { result, error in
                    let header = "--- validateLicenseKey ---"
                    let formatted = FGKUtils.formatResult(result, orError: error)
                    let content = "\(header)\n\(formatted)"
                    print("---VERIFY LICENSE KEY---\n\(formatted)")
                    DispatchQueue.main.async {
                       print("content\(content)")
                       
                    }
                }
    }

}

func isWiFiConnected() -> Bool {
    var flags = SCNetworkReachabilityFlags()
    let reachability = SCNetworkReachabilityCreateWithName(nil, "www.google.com")
    if SCNetworkReachabilityGetFlags(reachability!, &flags) {
        if flags.contains(.reachable) && !flags.contains(.isWWAN) {
            return true
        }
    }
    return false
}
//extension String {
//    
//    func encrypt(text: String) -> String?  {
//        if let aes = try? AES(key:"2288445566deadcd",iv:"deadcd2288445566",padding: .zeroPadding),
//            let encrypted = try? aes.encrypt(Array(text.utf8)) {
//            return encrypted.toHexString()
//        }
//        return nil
//    }
//
//    func decrypt(hexString: String) -> String? {
//        if let aes = try? AES(key: "2288445566deadcd", iv: "deadcd2288445566",padding: .zeroPadding),
//            let decrypted = try? aes.decrypt(Array<UInt8>(hex: hexString)) {
//            return String(data: Data(_: decrypted), encoding: .utf8)
//        }
//        return nil
//    }
//    
//
//   func convertToDictionary(text: String) -> [String: Any]? {
//       if let data = text.data(using: .utf8) {
//           do {
//               return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//           } catch {
//               print(error.localizedDescription)
//           }
//       }
//       return nil
//   }
//
//}
