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
import SystemConfiguration.CaptiveNetwork
import CoreLocation

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
    @IBOutlet weak var deleteBtn:UIButton!
    private var locationManager = CLLocationManager()
    var ping = String()
    var uploadSpeed = Double()
    var downloadSpeed = Double()
    var provider = String()
    var ipAddressData = String()
    var isFrom = String()
    var providername = String()
    var connectiontype = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        askEnableLocationService()
        if isFrom == "SpeedHistory"{
            pingLabel.text = ping
            uploadLabel.text = String(uploadSpeed).maxLength(length: 4)
            downloadLabel.text = String(downloadSpeed).maxLength(length: 4)
            ipAddress.text = ipAddressData
            connectedType.text = connectiontype
            providerLabel.text = providername
        }else{
            pingLabel.text = ping
            uploadLabel.text = String(uploadSpeed).maxLength(length: 4)
            downloadLabel.text = String(downloadSpeed).maxLength(length: 4)
            ipAddress.text = ipAddressData
            connectedType.text = getConnectionType()
            ipAddress.text = getIFAddresses()
            
            providerLabel.text = getWiFiSsid()
        }
        print("add: \(getIFAddresses())")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getBannerAd(self, adView, heightConstraint)
    }
    func askEnableLocationService() {
        var showAlertSetting = false
        var showInitLocation = false
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .denied:
                showAlertSetting = true
                print("HH: kCLAuthorizationStatusDenied")
            case .restricted:
                showAlertSetting = true
                print("HH: kCLAuthorizationStatusRestricted")
            case .authorizedAlways:
                showInitLocation = true
                print("HH: kCLAuthorizationStatusAuthorizedAlways")
            case .authorizedWhenInUse:
                showInitLocation = true
                print("HH: kCLAuthorizationStatusAuthorizedWhenInUse")
            case .notDetermined:
                showInitLocation = true
                print("HH: kCLAuthorizationStatusNotDetermined")
            default:
                break
            }
        } else {
            showAlertSetting = true
            print("HH: locationServicesDisabled")
        }
        
        if showAlertSetting {
            let alertView = UIAlertController(title: nil, message: "Please enable location service for this app in ALLOW LOCATION ACCESS: Always, Go to Setting?", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            alertView.addAction(UIAlertAction(title: "Open Setting", style: .default) { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            })
           
            present(alertView, animated: true, completion: nil)
        }
        
        if showInitLocation {
            initLocationManager()
        }
    }

    func initLocationManager() {
        self.locationManager = CLLocationManager()
        if self.locationManager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization)) {
            self.locationManager.requestAlwaysAuthorization()
        }
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
    @IBAction func retest(_ sender:UIButton){
        navigationController?.popViewController(animated: true)
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
   
    func getIFAddresses()->String {
        let url = URL(string: "https://api.ipify.org")
        var myIp=""
        do {
            if let url = url {
                let ipAddress = try String(contentsOf: url)
                myIp = ipAddress
                print("My public IP address is: " + ipAddress)
            }
        } catch let error {
            print(error)
        }
        return myIp
    }
  
    func getWiFiSsid() -> String? {
        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                   
                    break
                }
            }
        }
        print("ssid \(String(describing: ssid))")
        return ssid
    }
}
