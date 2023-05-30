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
import HGRippleRadarView
import Network

class WifiVC: UIViewController ,CLLocationManagerDelegate{
    var locationManager = CLLocationManager()
//     var currentNetworkInfos: Array<NetworkInfo>? {
//         get {
//             return SSID.fetchNetworkInfo()
//         }
//     }
    
    @IBOutlet weak var adView:UIView!
    @IBOutlet weak var heightConstraint:NSLayoutConstraint!
    @IBOutlet weak var transView:UIView!
    @IBOutlet weak var bottomSheet:UIView!
    @IBOutlet weak var noWifi:UIView!
    @IBOutlet weak var mapView:UIView!
    @IBOutlet weak var listView:UIView!
    @IBOutlet weak var wifiTableView:UITableView!
    @IBOutlet weak var topViewLabel:UILabel!
    @IBOutlet weak var topView:UIView!
    @IBOutlet weak var coonectedView:UIView!
    @IBOutlet weak var WifiName:UILabel!
    @IBOutlet weak var connectedDeviceCount:UILabel!
    @IBOutlet weak var radarView:RadarView!
    @IBOutlet weak var mapImg:UIImageView!
    @IBOutlet weak var listImg:UIImageView!
    @IBOutlet weak var optionBtn:UIButton!
   
    var decryptvalue = String()
    var dictnry = String()
    var hexadecimal = String()
  
    var fingData = [FingNodes]()
    override func viewDidLoad() {
        super.viewDidLoad()
        wifiTableView.delegate = self
        wifiTableView.dataSource = self
       
        locationManager = CLLocationManager()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideView))
        transView.addGestureRecognizer(tapGesture)
        let mapViewGesture = UITapGestureRecognizer(target: self, action: #selector(switchToMapView))
        mapView.addGestureRecognizer(mapViewGesture)
        let listViewGesture = UITapGestureRecognizer(target: self, action: #selector(switchToListView))
        listView.addGestureRecognizer(listViewGesture)
        radarView.delegate = self
        radarView.dataSource = self
        radarView.paddingBetweenItems = 10
        radarView.paddingBetweenCircles = 30
        radarView.numberOfCircles = 4
        askEnableLocationService()
        optionBtn.isHidden = false
        if UserDefaults.standard.bool(forKey: MyConstant.PERMISSION_GRANTED){
            if isWiFiConnected(){
                topViewLabel.text = "Wifi Provider"
                networkCall()
            }
        }else{
            self.requestPermissionsToShowSsidAndBssid()
        }
        if isWiFiConnected(){
            topViewLabel.text = "Wifi Provider"
            networkCall()
        }else{
            topViewLabel.text = "No Wi-Fi Connection"
        }
       
        if #available(iOS 14.0, *) { NEHotspotNetwork.fetchCurrent { network in if network != nil { print("is secured ((network.isSecure))") } } }
        
      
        
    }
    func updateWiFi() {
//        print("SSID: \(currentNetworkInfos?.first?.ssid ?? "")")
//
//        if let ssid = currentNetworkInfos?.first?.ssid {
//            ssidLabel.text = "SSID: \(ssid)"
//        }
//
//        if let bssid = currentNetworkInfos?.first?.bssid {
//            bssidLabel.text = "BSSID: \(bssid)"
//        }
        
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
                topView.isHidden = true
                coonectedView.isHidden = false
                WifiName.isHidden = false
                WifiName.text = getWiFiSsid()
                showInitLocation = true
                print("HH: kCLAuthorizationStatusAuthorizedAlways")
            case .authorizedWhenInUse:
                topView.isHidden = true
                coonectedView.isHidden = false
                WifiName.isHidden = false
                WifiName.text = getWiFiSsid()
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

    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        getBannerAd(self, adView, heightConstraint)
        locationManager.delegate = nil
       
       // checkWifi()
    }
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
       checkWifi()
        
    }
    
    @objc func switchToMapView(){
        
        switchView(isMap: false, isList: true)
        
    }
    @objc func switchToListView(){
        switchView(isMap: true, isList: false)
    }
    
    private func switchView(isMap:Bool,isList:Bool){
        wifiTableView.isHidden = isList
        radarView.isHidden = isMap
        optionBtn.isHidden = false
        if isMap{
            mapImg.image = UIImage(named: "radar_unselected")
            listImg.image = UIImage(named: "list_selected")
        }else{
            mapImg.image = UIImage(named: "radar_selected")
            listImg.image = UIImage(named: "list_unselected")
        }
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
        var parametr = [String:String]()
        parametr = ["data":encodedString!]
        NetworkHelper.sharedInstanceHelper.createPostRequest(method: .post, showHud: true, params: parametr, apiName: "/wifiauthservice/authkey") { [self] (result, error) in
//            do{
                if result != nil{
//                    do{
                        UserDefaults.standard.set(result!, forKey: MASTER_RESPONSE_VALUE)
                        let decryptString = decryptvalue.decrypt(hexString:result! as! String)
                        let dict1 = dictnry.convertToDictionary(text: decryptString!)
                        let code = dict1!["key"] as! String
                        
                        getConnectedDevicesList(key:code)
//                    }catch {
//                        doAuthKeyRequest()
//                    }
                    
                    
               }
                else{

                }
                
//            }catch{
//                doAuthKeyRequest()
//            }
            
        }
       
    }
    
    private func doAuthKeyRequest(){
        var  params = ["app_id": APP_ID,
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
        var parametr = [String:String]()
        parametr = ["data":encodedString!]
        NetworkHelper.sharedInstanceHelper.createReportKeyRequest(method: .post, showHud: true, params: parametr, apiName: "/wifiauthservice/reportkey") { [self] (result, error) in
            
            if result != nil{
                do{
                    UserDefaults.standard.set(result!, forKey: MASTER_RESPONSE_VALUE)
                    let decryptString = decryptvalue.decrypt(hexString:result! as! String)
                    let dict1 = dictnry.convertToDictionary(text: decryptString!)
                    let code = dict1!["message"] as! String
                    if code == "success"{
                        
                    }
                    
                }catch {
                    
                }
                
                
            }
            else{
               
            }
            
        }
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
    func getScreenHeightResolution()->CGFloat{
       let screenSize: CGRect = UIScreen.main.bounds
        return screenSize.height
    }
    
    func getScreenWidthResolution()->CGFloat{
          let screenSize: CGRect = UIScreen.main.bounds
        return screenSize.width
            }



    
    
    @IBAction func openMenu(_ sender:UIButton){
        hideUnhideMenuView(showTrans: false, showMenu: false)
        
    }
    @IBAction func openMenuList(_ sender:UIButton){
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
    
    
    private func getConnectedDevicesList(key:String){
        FingScanner.sharedInstance().validateLicenseKey(key, withToken: nil) { result, error in
            let header = "--- validateLicenseKey ---"
          //  var json = dataToJSON(data: result)
            
           
            let formatted = FGKUtils.formatResult(result, orError: error)
            let content = "\(header)\n\(formatted)"
            print("---VERIFY LICENSE KEY---\n\(formatted)")
            DispatchQueue.main.async { [self] in
                print("content\(content)")
                scanDevice()
                
            }
        }
        
        
       
    }
    func dataToJSON(data: Data) -> Any? {
       do {
           return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
       } catch let myJSONError {
           print(myJSONError)
       }
       return nil
    }
    func requestPermissionsToShowSsidAndBssid() {
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            print("Location permissions have been already granted!")
            return
        }
        
        let controller = UIAlertController(title: "Location permissions required", message: "\nStarting from iOS 13, in order to request Wi-Fi network SSID and BSSID apps must:\n\n• Request location permissions\n• Declare \"Access WiFi information in \"Signing & Capabilities\"", preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if status == .authorizedAlways{
            UserDefaults.standard.set(true, forKey: MyConstant.PERMISSION_GRANTED)
        }
        else if status == .notDetermined {
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
            
            scanner.networkScan(options) { [self] result, error in
                let completed = FGKUtils.extractFromJSON(result, forKey: "completed")
                let formatted = FGKUtils.formatResult(result, orError: error)
                print("---NETWORK SCAN22---\n\(formatted)")
               // DispatchQueue.main.async {
                //    self.printToUI(formatted as! String )
                    if completed == nil || completed as! String == "true" {
                        //fingData = formatted as! [ScannedWifiList]
                        // self.activityIndicator.stopAnimating()
                        print("scan done11")
                        if result != nil{
                            if let jsonData = result!.data(using: .utf8) {
                                print("jsonData11 \(result)")
                                do {
                                    let decoder = JSONDecoder()
                                    let scanResponse = try decoder.decode(FingScanResponse.self, from: jsonData)
                                    if let isp = scanResponse.gatewayIpAddress {
                                      
                                        UserDefaults.standard.set(isp, forKey: MyConstant.ROUTER_IP)

                                    }
                                    
                                    if let fingNodes = scanResponse.nodes, !fingNodes.isEmpty {
                                       
                                        // FingNodesHandler.shared.setFingNodes(fingNodes)
                                        fingData = fingNodes
                                        DispatchQueue.main.async { [self] in
                                            let items = fingData.map{Item(uniqueKey: $0.bestName!, value: $0) }
                                            radarView.add(items: items)
                                        }
                                      
                                        DispatchQueue.main.async { [self] in
                                            connectedDeviceCount.text = "( \(fingNodes.count) )"
                                            wifiTableView.reloadData()
                                        }
                                    }
                                    
                                    print("scan done11")
                                }catch{
                                    print("sfsdf\(error)")
                                }
                                
                            }
                        }
                    }
               // }
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
        hideBottomSheet()
        let vc = storyboard?.instantiateViewController(withIdentifier: "SpeedHistoryVC") as! SpeedHistoryVC
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func openDeviceDetail(_ sender:UIButton){
        hideBottomSheet()
        if #available(iOS 13.0, *) {
            let vc = storyboard?.instantiateViewController(withIdentifier: "VpnVC") as! VpnVC
            navigationController?.pushViewController(vc, animated: true)
        } else {
            // Fallback on earlier versions
        }
      
    }
    @IBAction func openRouter(_ sender:UIButton){
        hideBottomSheet()
        let vc = storyboard?.instantiateViewController(withIdentifier: "RouterVC") as! RouterVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func openInApp(_ sender:UIButton){
        hideBottomSheet()
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PurchaseVC") as! PurchaseVC
        navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func rateApp(_ sender:UIButton){
        hideBottomSheet()
        WiFiProvider.rateApp(showCustom: true, self: self)
    
    }
    
    @IBAction func aboutUs(_ sender:UIButton){
        hideBottomSheet()
        let vc = UIStoryboard.init(name: "Engine", bundle: Bundle.main).instantiateViewController(withIdentifier:MyConstant.keyName.kAboutUs) as? AboutUsVC
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    @IBAction func moreApp(_ sender:UIButton){
        hideBottomSheet()
        moreAppurl()
        
    }
    @IBAction func shareApp(_ sender:UIButton){
        hideBottomSheet()
        shareAppsUrl(self,url:SHARE_URL,text:SHARE_TEXT)
        
    }
    @IBAction func feedback(_ sender:UIButton){
        hideBottomSheet()
        sendFeedback()
    }
    private func hideBottomSheet(){
        bottomSheet.isHidden = true
        transView.isHidden = true
     }
     
}

extension WifiVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("fingData\(fingData.count)")
         return fingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = fingData[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WifiDataCell", for: indexPath) as! WifiDataCell
        cell.bestName.text = data.bestName
        switch(data.bestType){
        case "ROUTER":
            cell.bestTypes.image = UIImage(named: "router")
            break
        case "LAPTOP":
            cell.bestTypes.image = UIImage(named: "router")
            break
        case "MOBILE":
            cell.bestTypes.image = UIImage(named: "iphone")
            break
        case "COMPUTER":
            cell.bestTypes.image = UIImage(named: "desktop")
            break
        case "PRINTER":
            cell.bestTypes.image = UIImage(named: "printer")
            break
        default :
            print("none")
        }
        
        cell.ipAddress.text = data.ipAddresses?.first
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DeviceDetailVC") as! DeviceDetailVC
        vc.data  = fingData[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
 
    
}

extension WifiVC:RadarViewDelegate,RadarViewDataSource{
    func radarView(radarView: HGRippleRadarView.RadarView, didSelect item: HGRippleRadarView.Item) {
        let view = radarView.view(for: item)
        guard let animal = item.value as? FingNodes else { return }
        let vc = storyboard?.instantiateViewController(withIdentifier: "DeviceDetailVC") as! DeviceDetailVC
        vc.data  = animal
        navigationController?.pushViewController(vc, animated: true)
        print("item0000000\(item)")
    }
    
    func radarView(radarView: HGRippleRadarView.RadarView, didDeselect item: HGRippleRadarView.Item) {
       print("item\(item)")
    }
    
    func radarView(radarView: HGRippleRadarView.RadarView, didDeselectAllItems lastSelectedItem: HGRippleRadarView.Item) {
        print("allItems \(lastSelectedItem)")
    }
    
    func radarView(radarView: HGRippleRadarView.RadarView, viewFor item: HGRippleRadarView.Item, preferredSize: CGSize) -> UIView {
        let customView = UIView(frame: CGRect(x:0, y:0, width:50, height:preferredSize.height))
               customView.backgroundColor = UIColor.clear // Set your desired background color
               
               // Customize the appearance of the view as per your requirements
         let data = item.value as? FingNodes
        let nibObjects = Bundle.main.loadNibNamed("AnimationView", owner: nil, options: nil)
        
        let loadView = nibObjects?.first as? AnimationCell
        //  loadView.backgroundColor = UIColor.clear
        
        loadView?.deviceName.text = data!.bestName
        loadView?.deviceName.textColor = .white
        
       
            switch(data!.bestType){
            case "ROUTER":
                loadView?.animatedImage.image = UIImage(named: "router")
                break
            case "LAPTOP":
                loadView?.animatedImage.image = UIImage(named: "router")
                break
            case "MOBILE":
                loadView?.animatedImage.image = UIImage(named: "iphone")
                break
            case "COMPUTER":
                loadView?.animatedImage.image = UIImage(named: "desktop")
                break
            case "PRINTER":
                loadView?.animatedImage.image = UIImage(named: "printer")
                break
            default :
                loadView?.animatedImage.image = UIImage(named: "default_icon")
            
        }
        loadView?.animationView.frame.size.width = customView.frame.size.width
        loadView?.animationView.backgroundColor = UIColor.clear
        loadView?.animationView.frame.size.height = customView.frame.size.height
        customView.addSubview(loadView!)
        customView.backgroundColor = UIColor.clear
        customView.contentMode = .scaleAspectFill
        return customView
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
        UserDefaults.standard.set(ssid, forKey: "ssid")
        return ssid
    }
}


