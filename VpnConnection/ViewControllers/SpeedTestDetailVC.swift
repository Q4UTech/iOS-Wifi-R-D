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
    @IBOutlet weak var retestButton:UIButton!
    @IBOutlet weak var retestMsg:UILabel!
    private var locationManager = CLLocationManager()
    var ping = String()
    var uploadSpeed = Double()
    var downloadSpeed = Double()
    var provider = String()
    var ipAddressData = String()
    var isFrom = String()
    var providername = String()
    var connectiontype = String()
    var speedTestList  = [String:[SpeedTestData]]()
    var speedTestData  = [SpeedTestData]()
    var historyKey:String?
    var historyValue:SpeedTestData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        askEnableLocationService()
        if isFrom == "SpeedHistory"{
            deleteBtn.isHidden = false
            pingLabel.text = ping
            uploadLabel.text = String(uploadSpeed).maxLength(length: 4)
            downloadLabel.text = String(downloadSpeed).maxLength(length: 4)
            ipAddress.text = ipAddressData
            connectedType.text = connectiontype
            providerLabel.text = providername
            retestButton.isHidden = true
            retestMsg.isHidden = true
            print("historyData \(historyKey) \(historyValue)")
            print("complete data \(historyValue?.ipAddress) \(historyValue?.time) ")
            
        }else{
            deleteBtn.isHidden = true
            pingLabel.text = ping + ".00"
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
    
    @IBAction func deleteButtonDialog(_ sender:UIButton){
        showHideDeleteDialog(isShow:false)
    }
    
    private func showHideDeleteDialog(isShow:Bool){
        deleteView.isHidden = isShow
    }
    
    func askEnableLocationService() {
        var showAlertSetting = false
        var showInitLocation = false
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .denied:
                showAlertSetting = true
                print("ssid_Val \(getWiFiSsid())")
                print("HH: kCLAuthorizationStatusDenied")
            case .restricted:
                showAlertSetting = true
                print("HH: kCLAuthorizationStatusRestricted")
            case .authorizedAlways:
                print("ssid_Val \(getWiFiSsid())")
                showInitLocation = true
                print("HH: kCLAuthorizationStatusAuthorizedAlways")
            case .authorizedWhenInUse:
                print("ssid_Val \(getWiFiSsid())")
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
        RetestListener.instanceHelper.isSpeedTestComplete(complete: true)
        navigationController?.popViewController(animated: true)
    }
    @IBAction func deleteData(_ sender:UIButton){
        hideUnhideView(true, true)
        if UserDefaults.standard.data(forKey: MyConstant.SPEED_LIST) != nil{
            if let savedData = UserDefaults.standard.data(forKey: MyConstant.SPEED_LIST) {
                do {
                         
                    speedTestList = try JSONDecoder().decode([String:[SpeedTestData]].self, from: savedData)
                 //   print("speedDataList777\(speedDataList)")
                    for (_ ,data) in speedTestList{
                        print("dataCount \(data.count)")
                        for i in data{
                            speedTestData.append( SpeedTestData(time: i.time, ping:i.ping, downloadSpeed: i.downloadSpeed, uploadSpeed: i.uploadSpeed,connectionType: getConnectionType(),ipAddress: getIFAddresses(),providerName: getWiFiSsid() ?? "No Data Available"))
                        }

                    }
                    if  speedTestList.keys.contains(historyKey!){
                      
                        if let index = speedTestData.firstIndex(where: { $0 == historyValue }) {
                            // Remove the object from the array
                            speedTestData.remove(at: index)
                        }
                        print("complete data1 \(speedTestData.count)")
                        speedTestList[historyKey!] = speedTestData
                        if let encode = try?  JSONEncoder().encode(speedTestList) {
                            UserDefaults.standard.set(encode, forKey:MyConstant.SPEED_LIST)
                        }
                        HistoryListener.instanceHelper.isDeleteComplete(complete: true)
                        navigationController?.popViewController(animated: true)
                    }
                 
                }catch{

                }
            }

        }
    }
    @IBAction func cancel(_ sender:UIButton){
        hideUnhideView(true, true)
    }
    @IBAction func openDeleteDialog(_ sender:UIButton){
      hideUnhideView(false, false)
    }
    @IBAction func retest(_ sender:UIButton){
        RetestListener.instanceHelper.isSpeedTestComplete(complete: true)
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
