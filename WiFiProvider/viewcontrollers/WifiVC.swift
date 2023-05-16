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
import CoreLocation
import Foundation
 

class WifiVC: UIViewController ,CLLocationManagerDelegate{
    @IBOutlet weak var adView:UIView!
    @IBOutlet weak var heightConstraint:NSLayoutConstraint!
    @IBOutlet weak var transView:UIView!
    @IBOutlet weak var bottomSheet:UIView!
    @IBOutlet weak var noWifi:UIView!
    @IBOutlet weak var mapView:UIView!
    @IBOutlet weak var listView:UIView!
    var locationManager: CLLocationManager!
    var decryptvalue = String()
    var dictnry = String()
    var fingData = [ScannedWifiList]()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideView))
        transView.addGestureRecognizer(tapGesture)
        
        self.requestPermissionsToShowSsidAndBssid()
        if #available(iOS 14.0, *) { NEHotspotNetwork.fetchCurrent { network in if network != nil { print("is secured ((network.isSecure))") } } }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        locationManager.delegate = nil
       // checkWifi()
    }
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
//        checkWifi()
//        if isWiFiConnected(){
//            networkCall()
//        }
    }
    
    
    
    
    private func checkWifi(){
        if isWiFiConnected(){
            showWifiView(status:true)
            
           // scanDevice()
        }else{
            showWifiView(status:false)
        }
    }
    
    private func  showWifiView(status:Bool){
        noWifi.isHidden = status
    }
    
    private func networkCall(){
//        NetworkHelper.sharedInstanceHelper.getWifiKey(networkListner: { [self] wifiKey,error  in
//            if wifiKey != nil {
//
//                let decryptString = decryptvalue.decrypt(hexString:wifiKey as! String)
//                let dict1 = dictnry.convertToDictionary(text: decryptString!)
//                let code = dict1!["status"] as! String
//                print("code111 \(code)")
//
//            }
//        })
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
        FingScanner.sharedInstance().validateLicenseKey("F20yNC1hcHBzLWRldnJlY29nLXRyaWFsCE0yNCBBcHBzGVRyaWFsIGZyb20gcmVjb2cuZmluZy5jb20AAAGH66z5yZFhozM=", withToken: nil) { result, error in
            let header = "--- validateLicenseKey ---"
            let formatted = FGKUtils.formatResult(result, orError: error)
            let content = "\(header)\n\(formatted)"
            print("---VERIFY LICENSE KEY---\n\(formatted)")
            DispatchQueue.main.async {
                print("content\(content)")
                
                
            }
        }
        
        
        scanDevice()
    }
    func requestPermissionsToShowSsidAndBssid() {
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            print("Location permissions have been already granted!")
            return
        }
        
        let controller = UIAlertController(title: "Location permissions required", message: "\nStarting from iOS 13, in order to request Wi-Fi network SSID and BSSID apps must:\n\n• Request location permissions\n• Declare \"Access WiFi information in \"Signing & Capabilities\"", preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if status == .notDetermined {
            controller.addAction(UIAlertAction(title: "Request permissions", style: .default, handler: { _ in
                self.locationManager.delegate = self
                self.locationManager.requestWhenInUseAuthorization()
            }))
        } else {
            controller.addAction(UIAlertAction(title: "Go to iOS settings", style: .default, handler: { _ in
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                }
            }))
        }
        
        present(controller, animated: true, completion: nil)
    }
    
    // ------------------------------------
    // LOCATION MANAGER DELEGATE
    // ------------------------------------
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            if status == .authorizedAlways || status == .authorizedWhenInUse {
                let controller = UIAlertController(title: "Permissions granted!", message: "You can now request network information to obtain Wi-Fi network SSID and BSSID!", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(controller, animated: true, completion: nil)
            }
            self.locationManager.delegate = nil
        }
    }
    
    
    
    
    
    private func scanDevice(){
        FingScanner.sharedInstance().networkInfo { result, error in
            DispatchQueue.main.async {
                let header = "--- networkInfo ---"
                let formatted = FGKUtils.formatResult(result, orError: error)
                let content = "\(header)\n\(formatted)"
                print("---NETWORK INFO---\n\(formatted)")
                
                // Request location permissions if necessary
                let bssidIsMasked = FGKUtils.extractFromJSON(result, forKey: "bssidIsMasked")
                let ssidIsUnknown = FGKUtils.extractFromJSON(result, forKey: "ssidIsUnknown")
                print("bssid \(bssidIsMasked) \(ssidIsUnknown)")
                if bssidIsMasked != nil || ssidIsUnknown != nil {
                    self.requestPermissionsToShowSsidAndBssid()
                }
            }
        }
        let scanner = FingScanner.sharedInstance()
        let options = FingScanOptions.systemDefault()
        // Set this to true to simulate an externally-provided ARP table
        let useExternalInput = false
        if useExternalInput {
            let input = createMockInput(count: 30)
            //  printToUI("--- networkScan with EXTERNAL ARP TABLE ---")
            scanner.networkScan(options, with: input) { result, error in
                let completed = FGKUtils.extractFromJSON( result, forKey: "completed")
                let formatted = FGKUtils.formatResult(result, orError: error)
                print("---NETWORK SCAN11---\n\(formatted)")
                
                DispatchQueue.main.async {
                    self.printToUI(formatted as! String)
                    if completed == nil || completed as! String == "true" {
                        print("scan done")
                    }
                }
            }
        } else {
            //  printToUI("--- networkScan ---")
            scanner.networkScan(options) { result, error in
                let completed = FGKUtils.extractFromJSON(result, forKey: "completed")
                let formatted = FGKUtils.formatResult(result, orError: error)
                print("---NETWORK SCAN22---\n\(formatted)")
                DispatchQueue.main.async {
                    self.printToUI(formatted as! String )
                    if completed == nil || completed as! String == "true" {
                        //fingData = formatted as! [ScannedWifiList]
                        // self.activityIndicator.stopAnimating()
                        print("scan done11")
                    }
                }
            }
        }
    }
    
    func createMockInput(count: Int) -> FingScanInput {
        var table = [FingScanDeviceEntry]()
        for i in 0..<count {
            let entry = FingScanDeviceEntry()
            entry.ipAddress = "192.168.1.\(i)"
            entry.macAddress = String(format: "02:00:FF:00:00:%02X", i)
            table.append(entry)
        }
        let input = FingScanInput()
        input.deviceEntries = table
        return input
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
    
    func printToUI(_ content: String) {
        var toBePrinted = content
        print("contentdata \(toBePrinted)")
//        if self.textView.text.count > 0 {
//            let bottom = NSMakeRange(self.textView.text.count - 1, 1)
//            self.textView.scrollRangeToVisible(bottom)
//        }
    }
    
    @IBAction func openSpeedHistory(_ sender:UIButton){
        let vc = storyboard?.instantiateViewController(withIdentifier: "SpeedHistoryVC") as! SpeedHistoryVC
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func openDeviceDetail(_ sender:UIButton){
        let vc = storyboard?.instantiateViewController(withIdentifier: "DeviceDetailVC") as! DeviceDetailVC
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func openRouter(_ sender:UIButton){
        let vc = storyboard?.instantiateViewController(withIdentifier: "RouterVC") as! RouterVC
        navigationController?.pushViewController(vc, animated: true)
    }
}
