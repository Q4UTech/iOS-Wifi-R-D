//
//  PingDetailVC.swift
//  WiFiProvider
//
//  Created by gautam  on 11/05/23.
//

import UIKit
import Network
import SystemConfiguration
import CoreTelephony

class SpeedTestDetailVC: UIViewController {
    @IBOutlet weak var adView:UIView!
    @IBOutlet weak var heightConstraint:NSLayoutConstraint!
    @IBOutlet weak var pingLabel:UILabel!
    @IBOutlet weak var downloadLabel:UILabel!
    @IBOutlet weak var uploadLabel:UILabel!
    @IBOutlet weak var connectedType:UILabel!
    @IBOutlet weak var ipAddress:UILabel!
    @IBOutlet weak var providerLabel:UILabel!
    @IBOutlet weak var deleteView:UIView!
    @IBOutlet weak var transView:UIView!
    
    var ping = String()
    var uploadSpeed = Double()
    var downloadSpeed = Double()
    var provider = String()
    var ipAddressData = String()
  
    override func viewDidLoad() {
        super.viewDidLoad()

        pingLabel.text = ping
        uploadLabel.text = String(uploadSpeed)
        downloadLabel.text = String(downloadSpeed)
        ipAddress.text = ipAddressData
        connectedType.text = getConnectionType()
    }
    
    @IBAction func back(_ sender:UIButton){
        navigationController?.popViewController(animated: true)
    }
    @IBAction func deleteData(_ sender:UIButton){
        hideUnhideView(true, true)
    }
    @IBAction func cancel(_ sender:UIButton){
        hideUnhideView(true, true)
    }
    @IBAction func openDeleteDialog(_ sender:UIButton){
      hideUnhideView(false, false)
    }
    
    private func hideUnhideView(_ forDelete:Bool,_ forTrans:Bool){
        deleteView.isHidden = forDelete
        transView.isHidden = forTrans
    }
    
    func getConnectionType() -> String {
            guard let reachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, "www.google.com") else {
                return "NO INTERNET"
            }

            var flags = SCNetworkReachabilityFlags()
            SCNetworkReachabilityGetFlags(reachability, &flags)

            let isReachable = flags.contains(.reachable)
            let isWWAN = flags.contains(.isWWAN)

            if isReachable {
                if isWWAN {
                    let networkInfo = CTTelephonyNetworkInfo()
                    let carrierType = networkInfo.serviceCurrentRadioAccessTechnology

                    guard let carrierTypeName = carrierType?.first?.value else {
                        return "UNKNOWN"
                    }

                    switch carrierTypeName {
                    case CTRadioAccessTechnologyGPRS, CTRadioAccessTechnologyEdge, CTRadioAccessTechnologyCDMA1x:
                        return "2G"
                    case CTRadioAccessTechnologyLTE:
                        return "4G"
                    default:
                        return "3G"
                    }
                } else {
                    return "WIFI"
                }
            } else {
                return "NO INTERNET"
            }
        }
   

}
