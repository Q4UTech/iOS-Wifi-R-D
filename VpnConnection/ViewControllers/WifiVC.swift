//
//  DashboardVC.swift
//  WiFiProvider
//
//  Created by gautam  on 27/04/23.
//

import UIKit
import FingKit
import NetworkExtension
import SystemConfiguration.CaptiveNetwork
import CoreLocation
import Foundation
import HGRippleRadarView
import Network
import AVFoundation


enum Network: String {
    case wifi = "en0"
    case cellular = "pdp_ip0"
    //... case ipv4 = "ipv4"
    //... case ipv6 = "ipv6"
}


class WifiVC: UIViewController ,LanguageSelectionDelegate,LANScannerDelegate,CLLocationManagerDelegate{
    func showList(list: [OfflineData]) {
        
        let items = list.map{Item(uniqueKey: $0.ipName, value: $0) }
        DispatchQueue.main.async { [self] in
            coonectedView.isHidden = false
            topView.isHidden = true
            connectedDeviceCount.text = "(\(list.count))"
            waitingLbl.isHidden = true
            wifiTableView.reloadData()
        }
        DispatchQueue.main.async { [self] in
            
            if items.count > 0 {
                radarView.add(items: items)
                
                radarView.stopAnimation()
                return
            }
        }
        
    }
    
    
    func languageSelection(name: String, code: String) {
        UserDefaults.standard.set(code, forKey: MyConstant.constant.APPLE_LANGUAGE)
        LanguageTimer.shared.startTimer(target: self)
    }
    var locationManager:CLLocationManager? = nil
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
    @IBOutlet weak var langLabel:UILabel!
    @IBOutlet weak var moreAppLbl:UILabel!
    @IBOutlet weak var mapViewLbl:UILabel!
    @IBOutlet weak var listViewLbl:UILabel!
    @IBOutlet weak var abtUsLbl:UILabel!
    @IBOutlet weak var mapWidthConstraint:NSLayoutConstraint!
    @IBOutlet weak var listWidthConstraint:NSLayoutConstraint!
    @IBOutlet weak var waitingLbl:UILabel!
    
    //  var wifiHelper:WifiHelper?
    private  var decryptvalue = String()
    private  var dictnry = String()
    private  var hexadecimal = String()
    private var locationPermissionGranted:Bool = false
    private var fingData = [FingNodes]()
    private var offlineData = [OfflineData]()
    private  var offline:Bool = false
    private  var isFetched:Bool = false
    var initial_count = 0
    var task : UIBackgroundTaskIdentifier?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wifiTableView.delegate = self
        wifiTableView.dataSource = self
        // MainListHelper.instanceHelper.wifiDelegate = self
        LanguageSelectionListener.instanceHelper.itemdelegates = self
        //        locationManager = CLLocationManager()
        //        locationManager?.delegate = self
        //        locationManager?.requestAlwaysAuthorization()
        
        if UserDefaults.standard.bool(forKey: MyConstant.PERMISSION_GRANTED){
            topView.isHidden = true
            coonectedView.isHidden = false
            WifiName.isHidden = false
            if getWiFiSsid() == nil{
                WifiName.text = "Not Found"
            }else{
                WifiName.text = getWiFiSsid()
            }
            
            print("getWifiname \(getWiFiSsid()) \(getWiFiName())")
        }else{
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.requestAlwaysAuthorization()
        }
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
        locationPermissionGranted = UserDefaults.standard.bool(forKey: MyConstant.PERMISSION_GRANTED)
        
        optionBtn.isHidden = false
        //  askEnableLocationService()
        
        if mapViewLbl.text!.count >= 10{
            mapWidthConstraint.constant = 130
            listWidthConstraint.constant = 150
        }else{
            mapWidthConstraint.constant = 94
            listWidthConstraint.constant = 94
        }
        
        checkWifi()
        
        
        if #available(iOS 14.0, *) { NEHotspotNetwork.fetchCurrent { network in if network != nil { print("is secured ((network.isSecure))") } } }
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(appEnteredForeground), name: NSNotification.Name("AppEnteredForegroundNotification"), object: nil)
        
        
        
    }
    
    @objc func appEnteredForeground() {
        
        print("App entered foreground")
        if ReachabilityUtil.isConnectedToNetwork(){
            noWifi.isHidden = true
            topViewLabel.text = "Wi-Fi Manager".localiz()
            topView.isHidden = true
            coonectedView.isHidden = false
            WifiName.isHidden = false
            WifiName.text = getWiFiSsid()
            networkCall()
        }else{
            print("Internet Connection not Available!")
            topViewLabel.text = "No Wi-Fi Connection"
                .localiz()
            noWifi.isHidden = false
        }
    }
    
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    func getWiFiName() -> String? {
        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    break
                }
            }
        }
        return ssid
    }
    
    
    
    
    func askEnableLocationService() {
        var showAlertSetting = false
        var showInitLocation = false
        
        DispatchQueue.global(qos: .background).async {
            if CLLocationManager.locationServicesEnabled() {
                switch CLLocationManager.authorizationStatus() {
                case .denied:
                    DispatchQueue.main.async{
                        showAlertSetting = true
                        print("HH: kCLAuthorizationStatusDenied")
                    }
                case .restricted:
                    DispatchQueue.main.async{
                        showAlertSetting = true
                        print("HH: kCLAuthorizationStatusRestricted")
                    }
                    
                case .authorizedAlways:
                    DispatchQueue.main.async{
                        showInitLocation = true
                        print("HH: kCLAuthorizationStatusAuthorizedAlways")
                    }
                case .authorizedWhenInUse:
                    DispatchQueue.main.async{ [self] in
                        topView.isHidden = true
                        coonectedView.isHidden = false
                        
                        showInitLocation = true
                        print("HH: kCLAuthorizationStatusAuthorizedWhenInUse")
                    }
                case .notDetermined:
                    DispatchQueue.main.async{
                        showInitLocation = true
                        print("HH: kCLAuthorizationStatusNotDetermined")
                    }
                default:
                    break
                }
            } else {
                showAlertSetting = true
                print("HH: locationServicesDisabled")
            }
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
        if self.locationManager!.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization)) {
            self.locationManager!.requestAlwaysAuthorization()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        getBannerAd(self, adView, heightConstraint)
        hideUnhideMenuView(showTrans: true, showMenu: true)
        
        
        // checkWifi()
    }
    
    @objc func switchToMapView(){
        waitingLbl.isHidden = true
        switchView(isMap: false, isList: true)
        
    }
    @objc func switchToListView(){
        if isFetched{
            waitingLbl.isHidden = true
        }else{
            waitingLbl.isHidden = false
        }
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
            topViewLabel.text = "Wi-Fi Manager".localiz()
            showWifiView(status:true)
            networkCall()
        }else{
            topViewLabel.text = "No Wi-Fi Connection"
                .localiz()
            showWifiView(status:false)
        }
        
    }
    
    private func  showWifiView(status:Bool){
        noWifi.isHidden = status
    }
    
    private func networkCall(){
        //        DispatchQueue.global(qos: .background).async { [self] in
        
        var params = [String:Any]()
        
        params = ["app_id": APP_ID,
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
        
//        getConnectedDevicesList(key:"")
        NetworkHelper.sharedInstanceHelper.createPostRequest(method: .post, showHud: true, params: parametr, apiName: "/wifiauthservice/authkey") { [self] (result, error) in
            do{
                if result != nil{


                    let decryptString = decryptvalue.decrypt(hexString:result! as! String)
                    let dict1 = dictnry.convertToDictionary(text: decryptString!)
                    let code = dict1!["key"] as! String
                    print("granted \(locationPermissionGranted)")
                    if locationPermissionGranted{
                        getConnectedDevicesList(key:code)
                    }

                }
                else{

                }

            }catch{
                // doAuthKeyRequest()
            }

        }
        
        //}
        
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
    
    class FingScannerThread:Thread{
        var vc:WifiVC?=nil
        
        func setWifiVC(_ vc:WifiVC){
            self.vc=vc;
        }
        
        override func main() {
            vc?.scanDevice1()
//            vc?.scanDevice()

        }
    }
    
    private func getConnectedDevicesList(key:String){
        print(" FingSDK:  getConnectedDevicesList key : \(key)")
      
//        let fingObj = FingScannerThread()
//        fingObj.setWifiVC(self)
//        fingObj.start()
        
        FingScanner.sharedInstance().validateLicenseKey(key, withToken: nil) { [self] result, error in
            print(" FingSDK:  getConnectedDevicesList result : \(result)")
            if result != nil{
                
                DispatchQueue.main.async {
                    //                task = UIApplication.shared.beginBackgroundTask(withName: "MyTask") { [self] in
                    
                    let fingObj = FingScannerThread()
                    fingObj.setWifiVC(self)
                    fingObj.start()
                    //                scanDevice()
                }
                
                //                DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [self] in
                //                    callApi()
                //                }
                
                
                //                }
                
                
            }
            
            
        }
        
    }
    public static func getConnectedDevicesList1(key:String){
        print("keyname1 \(key)")
//        FingScanner.sharedInstance().validateLicenseKey(key, withToken: nil) { [self] result, error in
//            print(" FingSDK:  getConnectedDevicesList result : \(result)")
//            if result != nil{
//
//
//                //                task = UIApplication.shared.beginBackgroundTask(withName: "MyTask") { [self] in
//
////                let fingObj = FingScannerThread()
////                fingObj.setWifiVC(self)
////                fingObj.start()
//                //                scanDevice()
//
//
//                //                DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [self] in
//                //                    callApi()
//                //                }
//
//
//                //                }
//
//
//            }
//
//
//        }
        
        
        
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        // UIApplication.shared.endBackgroundTask(task!)
    }
    func callApi(){
        
        DispatchQueue.global(qos: .background).async {
            
            
            CountryDataVM.shared.getExcercise(completion: {categoryList,error  in
                
                if error == "No Internet Connection"{
                    
                }else{
                    if categoryList.count == 0{
                        // KRProgressHUD.dismiss()
                        //
                        
                    }else{
                        //   KRProgressHUD.dismiss()
                        
                        print("cot\(categoryList.count)")
                        
                    }
                }
            })
            
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
            UserDefaults.standard.set(true, forKey: MyConstant.PERMISSION_GRANTED)
            locationPermissionGranted = true
            topView.isHidden = true
            coonectedView.isHidden = false
            WifiName.isHidden = false
            WifiName.text = getWiFiSsid()
            return
        }else {
            
            
            let controller = UIAlertController(title: "Location permissions required", message: "\nStarting from iOS 13, in order to request Wi-Fi network SSID and BSSID apps must:\n\n• Request location permissions\n• Declare \"Access WiFi information in \"Signing & Capabilities\"", preferredStyle: .alert)
            
            controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            if status == .notDetermined {
                controller.addAction(UIAlertAction(title: "Request permissions", style: .default, handler: { _ in
                    
                    self.locationManager!.requestWhenInUseAuthorization()
                }))
            }
            else if status == .authorizedWhenInUse || status == .authorizedAlways{
                print("granted")
            }
            else {
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
    }
    
    // ------------------------------------
    // LOCATION MANAGER DELEGATE
    // ------------------------------------
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async { [self] in
            if status == .authorizedAlways || status == .authorizedWhenInUse {
                let controller = UIAlertController(title: "Permissions granted!", message: "You can now request network information to obtain Wi-Fi network SSID and BSSID!", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(controller, animated: true, completion: nil)
                topView.isHidden = true
                coonectedView.isHidden = false
                WifiName.isHidden = false
                WifiName.text = getWiFiSsid()
                print("getWifiname \(getWiFiSsid()) \(getWiFiName())")
            }
            self.locationManager!.delegate = nil
        }
    }
    
    
    
    func scanDevice1(){
        
        let scanner = FingScanner.sharedInstance()
        let options = FingScanOptions.systemDefault()
    
//        options?.maxNetworkSize=100
        
        
        
        scanner.networkInfo(){  [self] result, error in
            print("---NETWORK SCAN22---00 \(result)")
            DispatchQueue.main.async {
                DispatchQueue.global(qos: .background).async {
                    
                    print("---NETWORK SCAN22---11 \(result)")
                    scanDevice()
                }
                
            }
        }
        
    }
    
    
    func scanDevice(){
      
        
        let scanner = FingScanner.sharedInstance()
        let options = FingScanOptions.systemDefault()
    
//        options?.maxNetworkSize=100
        
        
        
        scanner.networkScan(options) { [self] result, error in
            DispatchQueue.main.async {
            
            DispatchQueue.global(qos: .background).async {
                let completed = FGKUtils.extractFromJSON(result, forKey: "progress")
                let formatted = FGKUtils.formatResult(result, orError: error)
                print("---NETWORK SCAN22---\n\(formatted)")
                
                
                
                if formatted as! String == "License has expired"{
                    print("do action")
                    offline = true
                    
                    let scanner = LANScanner(delegate: self, continuous: false)
                    scanner.startScan()
                }else{
                    offline = false
                    if completed == nil || completed as! Int == 100 {
                        scanner.networkScanStop()
                        FingScanner.sharedInstance().willSuspend()
                        
                        //                        scanner.networkScan(options)
                        print("called again")
                        
                        //                   Thread.current.cancel()
                        //    Thread.exit()
                        //                    DispatchQueue.global().suspend()
                        
                        
                        if result != nil{
                            if let jsonData = result!.data(using: .utf8) {
                                print("jsonData11 \(result)")
                                do {
                                    
                                    
                                    let decoder = JSONDecoder()
                                    
                                    let scanResponse = try decoder.decode(FingScanResponse.self, from: jsonData)
                                    
                                    
                                    // print("content \(content)")
                                    
                                    
                                    if let isp = scanResponse.gatewayIpAddress {
                                        
                                        UserDefaults.standard.set(isp, forKey: MyConstant.ROUTER_IP)
                                        
                                        
                                        //                                         if let ispName = scanResponse.fingIsp {
                                        //
                                        //                                             DispatchQueue.main.async { [self] in
                                        //                                                 WifiName.text = ispName.ispName?.shorted(to: 30)
                                        //                                             }
                                        //
                                        //                                         }
                                        if let fingNodes = scanResponse.nodes, !fingNodes.isEmpty {
                                            
                                            DispatchQueue.main.async { [self] in
                                                
                                                
                                                fingData = fingNodes
                                                if initial_count==0{
                                                    initial_count = 1
                                                    let items = fingData.map{Item(uniqueKey: $0.firstSeenTimestamp!, value: $0) }
                                                    radarView.add(items: items)
                                                    print("scan done22 \(items.count)")
                                                    radarView.stopAnimation()
                                                    waitingLbl.isHidden = true
                                                    
                                                }
                                                
                                                
                                                isFetched = true
                                                coonectedView.isHidden = false
                                                waitingLbl.isHidden = true
                                                topView.isHidden = true
                                                connectedDeviceCount.text = "(\(fingNodes.count))"
                                                wifiTableView.reloadData()
                                                
                                                
                                            }
                                            
                                        }
                                        
                                        
                                    }
                                    
                                    
                                    print("scan done88")
                                    
                                }catch{
                                    print("error_msg\(error)")
                                }
                                
                            }
                        }
                        
                        //                         }
                    }else{
                        //                    Thread.current.cancel()
                        //                    Thread.exit()
                    }
                    //                                    }
                }
                // DispatchQueue.main.async {
                //    self.printToUI(formatted as! String )
                
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
    
    func LANScannerFinished() {
        print("scan finished")
        waitingLbl.isHidden = true
        showList(list: offlineData)
        isFetched = true
    }
    
    func LANScannerDiscovery(_ device: LANDevice) {
        print("Hellooo \(device.ipAddress)  \(device.hostName)")
        offlineData.append(OfflineData(ipName: device.ipAddress, ipDetail: device.ipAddress))
    }
    func LANScannerRestarted() {
        print("hhhhhhhh")
    }
    
    func LANScannerFailed(_ error: NSError) {
        print("scan failed \(error)")
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
        showFullAds(viewController: self, isForce: true)
    }
    
    
    @IBAction func openInApp(_ sender:UIButton){
        hideBottomSheet()
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PurchaseVC") as! PurchaseVC
        navigationController?.pushViewController(vc, animated: true)
        showFullAds(viewController: self, isForce: false)
        
    }
    @IBAction func openLanguageOption(_ sender:UIButton){
        hideBottomSheet()
        let vc = storyboard!.instantiateViewController(withIdentifier: "LanguageVC") as! LanguageVC
        navigationController?.pushViewController(vc, animated: true)
        showFullAds(viewController: self, isForce: false)
        
    }
    @IBAction func rateApp(_ sender:UIButton){
        hideBottomSheet()
        VpnConnection.rateApp(showCustom: true, self: self)
        
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
        if offline{
            return offlineData.count
        }else{
            return fingData.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WifiDataCell", for: indexPath) as! WifiDataCell
        
        if offline{
            let data = offlineData[indexPath.row]
            cell.bestName.text = "Not Found"
            cell.ipAddress.text = data.ipName
            cell.bestTypes.image = UIImage(named: "default_icon")
        }else{
            let data = fingData[indexPath.row]
            cell.bestName.text = data.bestName
            
            switch(data.bestType){
            case "ROUTER":
                cell.bestTypes.image = UIImage(named: "router")
                break
            case "LAPTOP":
                cell.bestTypes.image = UIImage(named: "desktop")
                break
            case "MOBILE":
                cell.bestTypes.image = UIImage(named: "iphone")
                break
            case "COMPUTER":
                cell.bestTypes.image = UIImage(named: "desktop")
                break
            case "DESKTOP":
                cell.bestTypes.image = UIImage(named: "desktop")
                break
            case "PRINTER":
                cell.bestTypes.image = UIImage(named: "printer")
                break
            default :
                cell.bestTypes.image = UIImage(named: "default_icon")
            }
            
            cell.ipAddress.text = data.ipAddresses?.first
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DeviceDetailVC") as! DeviceDetailVC
        if offline{
            vc.isFrom = "offline"
            navigationController?.pushViewController(vc, animated: true)
            showFullAds(viewController: self, isForce: false)
        }else{
            vc.data  = fingData[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            showFullAds(viewController: self, isForce: false)
        }
    }
    
    
    
}

extension WifiVC:RadarViewDelegate,RadarViewDataSource{
    func radarView(radarView: HGRippleRadarView.RadarView, didSelect item: HGRippleRadarView.Item) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DeviceDetailVC") as! DeviceDetailVC
        let view = radarView.view(for: item)
        if offline{
            vc.isFrom = "offline"
            navigationController?.pushViewController(vc, animated: true)
            showFullAds(viewController: self, isForce: false)
        }else{
            guard let animal = item.value as? FingNodes else { return }
            
            vc.data  = animal
            navigationController?.pushViewController(vc, animated: true)
            showFullAds(viewController: self, isForce: false)
            print("item0000000\(item)")
        }
        
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
        let nibObjects = Bundle.main.loadNibNamed("AnimationView", owner: nil, options: nil)
        let loadView = nibObjects?.first as? AnimationCell
        // Customize the appearance of the view as per your requirements
        if offline{
            let data = item.value as? OfflineData
            let nibObjects = Bundle.main.loadNibNamed("AnimationView", owner: nil, options: nil)
            
            let loadView = nibObjects?.first as? AnimationCell
            //  loadView.backgroundColor = UIColor.clear
            
            loadView?.deviceName.text = data!.ipName
            loadView?.deviceName.textColor = .white
            loadView?.animatedImage.image = UIImage(named: "default_icon")
            
            
            loadView?.animationView.frame.size.width = customView.frame.size.width
            loadView?.animationView.backgroundColor = UIColor.clear
            loadView?.animationView.frame.size.height = customView.frame.size.height
            customView.addSubview(loadView!)
        }else{
            let data = item.value as? FingNodes
            
            
            
            //  loadView.backgroundColor = UIColor.clear
            
            loadView?.deviceName.text = data!.bestName
            loadView?.deviceName.textColor = .white
            
            
            switch(data!.bestType){
            case "ROUTER":
                loadView?.animatedImage.image = UIImage(named: "router")
                break
            case "LAPTOP":
                loadView?.animatedImage.image = UIImage(named: "desktop")
                break
            case "DESKTOP":
                loadView?.animatedImage.image = UIImage(named: "desktop")
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
        }
        
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


public extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter{ seen.insert($0).inserted }
    }
}

extension String {
    func shorted(to symbols: Int) -> String {
        guard self.count > symbols else {
            return self
        }
        return self.prefix(symbols) + " ..."
    }
}
