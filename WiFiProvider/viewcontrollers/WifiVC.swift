//
//  DashboardVC.swift
//  WiFiProvider
//
//  Created by gautam  on 27/04/23.
//

import UIKit
import FingKit
import NetworkExtension
 

class WifiVC: UIViewController {
    @IBOutlet weak var adView:UIView!
    @IBOutlet weak var heightConstraint:NSLayoutConstraint!
    @IBOutlet weak var transView:UIView!
    @IBOutlet weak var bottomSheet:UIView!
    var decryptvalue = String()
    var dictnry = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideView))
                transView.addGestureRecognizer(tapGesture)
        networkCall()
        if #available(iOS 14.0, *) { NEHotspotNetwork.fetchCurrent { network in if network != nil { print("is secured ((network.isSecure))") } } }
      
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
