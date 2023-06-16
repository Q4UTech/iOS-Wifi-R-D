//
//  ViewController.swift
//  WiFiProvider
//
//  Created by gautam  on 27/04/23.
//

import UIKit
import Lottie
import NetworkExtension
import Foundation
import LanguageManager_iOS
import Network
import CoreLocation
import FingKit

class SplashVC: UIViewController,CLLocationManagerDelegate,OnCacheFullAddListenerProtocol,LaunchFullCallBackListenerProtocol ,SplashBannerListenerProtocol,OnBannerAdsIdLoadedProtocol,LanguageSelectionDelegate{
    func languageSelection(name: String, code: String) {
        UserDefaults.standard.set(code, forKey: MyConstant.constants.APPLE_LANGUAGE)
    }
    var locationManager:CLLocationManager?
    let SPLASH_SCREEN = "AN_SPLASH_SCREEN"
    func onBannerFailToLoad() {
        if !isSplash{
            isSplash = true
            openDashboardThroughBannerLoaded()
        }
    }
    
    func loadandshowBannerAds() {
        if !isSplash{
            isSplash = true
            openDashboardThroughBannerLoaded()
        }
    }
    
    func splashBannerStatus(_ status: Bool) {
        if status {
            
           
            DispatchQueue.main.async {
                if !self.firstTime{
                    let hasInAppPurchased = UserDefaults.standard.bool(forKey: IN_APP_PURCHASED)
                    self.getBannerAds()
                    //                    getBannerAd(self, self.bannerAdsView, self.bannerAdsheightConstraint)
                    self.firstTime = true
                }
            }
        }
    }
    @IBOutlet weak var animationView:UIView!
    @IBOutlet weak var adsView:UIView!
    @IBOutlet weak var heightConstraint:NSLayoutConstraint!
    @IBOutlet weak var policiesButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var letsGoButton: UIButton!
    @IBOutlet weak var andLabel: UILabel!
    @IBOutlet weak var agreeLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    var fullAdStatus = Bool()
    var checkStatus = Bool()
    var value = String()
    var type = String()
    var appLaunch = false
    var splashTimer : Timer?
    static var fromSplash = Bool()
    var splashCounter = 6
    var splashtimer1 : Timer?
    var splashcounter1 = 2
    var firstTime = false
    var isSplash = Bool()
    var isFirstadsnotLoaded = false
    var inAppPurchaseStatus = Bool()
    let currentLanguage = UserDefaults.standard.value(forKey: MyConstant.constants.APPLE_LANGUAGE) ?? "en"
    var firstTimeTimer = true
    private var isBannerLoaded = false
    private var isFulladsLoaded = false
    var splashAnimationView:LottieAnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
       Bundle.swizzleLocalization()
        CallOnSplash.shared.v2CallOnSplash(for: self)
        SplashVC.fromSplash = true
        OnBannerAdsIdLoaded.adsInstanceHelper.onBannerAdsLoadeddelegates = self
        
        lightTheme()
       
        letsGoButton.isHidden = true
        if !UserDefaults.standard.bool(forKey: ISFIRSTTIME) {
            setUpUI(status:false)
            checkLetStartButton()
        }
        else{
            setUpUI(status:true)
            checkApplaunch()
        }
       // startProgressAnimation()
//        getConnectedDevicesList(key: "IWFkamFzLWprYXNkaGphcy1kaC1kZXZyZWNvZy10cmlhbBJhZGphcyBqa2FzZGhqYXMgZGgZVHJpYWwgZnJvbSByZWNvZy5maW5nLmNvbQAAAYiKxBnZmhEtdg==")
    }
    
//    private func
//    getConnectedDevicesList(key:String){
//        print("keyData \(key)")
//        FingScanner.sharedInstance().validateLicenseKey(key, withToken: nil) { [self] result, error in
//
//            if result != nil{
//
//                scanDevice()
//            }
//        }}
//    func scanDevice(){
//    //   DispatchQueue.global(qos: .background).async { [self] in
//
//           let scanner = FingScanner.sharedInstance()
//           let options = FingScanOptions.systemDefault()
//           // Set this to true to simulate an externally-provided ARP table
//
//               // printToUI("--- networkScan ---")
//
//
//
//            scanner.networkScan(options) { [self] result, error in
//                let completed = FGKUtils.extractFromJSON(result, forKey: "progress")
//                let formatted = FGKUtils.formatResult(result, orError: error)
//                print("---NETWORK SCAN22---\n\(formatted)")
//                if formatted as! String == "License has expired"{
//                    print("do action")
//                   // offline = true
//
////                    let scanner = LANScanner(delegate: self, continuous: false)
////                    scanner.startScan()
//                }else{
//                    //offline = false
//                    if completed == nil || completed as! Int == 100 {
//
//
//                        if result != nil{
//                            if let jsonData = result!.data(using: .utf8) {
//                                print("jsonData11 \(result)")
//                                do {
//
//
//                                    let decoder = JSONDecoder()
//
//                                    let scanResponse = try decoder.decode(FingScanResponse.self, from: jsonData)
//
//
//                                    // print("content \(content)")
//
//
//                                    if let isp = scanResponse.gatewayIpAddress {
//
//                                        UserDefaults.standard.set(isp, forKey: MyConstant.ROUTER_IP)
//
//
//                                        if let ispName = scanResponse.fingIsp {
//
//                                            DispatchQueue.main.async { [self] in
//                                              //  WifiName.text = ispName.ispName?.shorted(to: 30)
//                                            }
//
//                                        }
//                                        if let fingNodes = scanResponse.nodes, !fingNodes.isEmpty {
//                                            print("findNodeCount \(fingNodes.count)")
//                                            //FingNodesHandler.shared.setFingNodes(fingNodes)
////                                            DispatchQueue.main.async { [self] in
////
////
////                                                fingData = fingNodes
////                                                if initial_count==0{
////                                                    initial_count = 1
////                                                    let items = fingData.map{Item(uniqueKey: $0.firstSeenTimestamp!, value: $0) }
////                                                    radarView.add(items: items)
////                                                    print("scan done22 \(items.count)")
////                                                    radarView.stopAnimation()
////                                                    waitingLbl.isHidden = true
////
////                                                }
////
////
////                                                isFetched = true
////                                                coonectedView.isHidden = false
////                                                waitingLbl.isHidden = true
////                                                topView.isHidden = true
////                                                connectedDeviceCount.text = "(\(fingNodes.count))"
////                                                wifiTableView.reloadData()
////                                            }
//
//                                        }
//
//
//                                    }
//
//
//                                    print("scan done88")
//                                }catch{
//                                    print("error_msg\(error)")
//                                }
//
//                            }
//                        }
//
//                        // }
//                    }
//                }
//
//                // DispatchQueue.main.async {
//                //    self.printToUI(formatted as! String )
//
//            }
//
//       //}
//   }
        
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            UserDefaults.standard.set(true, forKey: MyConstant.PERMISSION_GRANTED)
        }
    }
   
    func checkLetStartButton(){
        
        if ServiceHelper.sharedInstanceHelper.isConnectedToNetwork(){
            Timer.scheduledTimer(withTimeInterval: 10, repeats: false, block: { timer in
                
                self.runnable()
                timer.invalidate()
                
            })
        }else{
            letsGoButton.isHidden = false
            
        }
        
    }
    func getBannerAds(){
      getBannerAd(self, adsView, heightConstraint)
    }
    func callDelegates(){
        OnCacheFullAddListener.adsInstanceHelper.onCacheFullAdsdelegates = self
        SplashBannerListener.adsInstanceHelper.splashBannerdelegates = self
    }
    func checkApplaunch(){
        if UserDefaults.standard.bool(forKey: ISFIRSTTIME)  && !self.isFulladsLoaded && !self.isBannerLoaded {
            launchApp()
        }else if UserDefaults.standard.bool(forKey: ISFIRSTTIME)  && !self.isFulladsLoaded{
            launchApp()
        }else if UserDefaults.standard.bool(forKey: ISFIRSTTIME)  && !self.isBannerLoaded {
            launchApp()
        }
        
    }
    func launchApp(){
        if ServiceHelper.sharedInstanceHelper.isConnectedToNetwork(){
            Timer.scheduledTimer(withTimeInterval: 10, repeats: false, block: { timer in
                self.applaunch()
                timer.invalidate()
            })
            
        }
        else{
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { timer in
                self.applaunch()
                timer.invalidate()
            })
        }
    }
    
    func setUpUI(status:Bool){
        checkButton.isHidden = status
        agreeLabel.isHidden = status
        termsButton.isHidden = status
        andLabel.isHidden = status
        policiesButton.isHidden = status
        
    }
    
    private func openDashboardThroughBannerLoaded() {
        
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { timer in
            self.isBannerLoaded = true
            if (!UserDefaults.standard.bool(forKey: ISFIRSTTIME) && self.isFulladsLoaded) {
                self.letsGoButton.isHidden = false
                self.andLabel.isHidden = false
                self.agreeLabel.isHidden = false
                self.termsButton.isHidden = false
                self.policiesButton.isHidden = false
                self.runnable()
                
            }
            timer.invalidate()
            
        })
    }
    
    @IBAction func policiesButtonAction(_ sender: Any) {
       //
        BaseClass.init().privacyPolicy()
    }
    
    @IBAction func termsAction(_ sender: Any) {
        BaseClass.init().termsCondition()
    }
    
    @IBAction func checkTermsConditionAction(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            checkStatus = false
            checkButton.setImage(UIImage(named: "untick_icon"), for: .normal)
            //setCheckIcon(iconName: "untick_icon",button:sender)
            self.letsGoButton.isUserInteractionEnabled = true
        } else {
            sender.isSelected = true
            checkStatus = true
            checkButton.setImage(UIImage(named: "shape"), for: .normal)
            //setCheckIcon(iconName: "Shape", button: sender)
            self.letsGoButton.isUserInteractionEnabled = true
        }
    }
    
//    func setCheckIcon(iconName:String,button:UIButton){
//        if #available(iOS 13.0, *) {
//            button.setImage(UIImage(systemName: iconName), for: .normal)
//        } else {
//
//        }
//    }
    
    @IBAction func languageSelectionAction(_ sender: Any) {
//        let vc = UIStoryboard.init(name: kConstant.keyName.kMain, bundle: Bundle.main).instantiateViewController(withIdentifier: kConstant.keyName.kLanguageListVC) as? LanguageVC
//        vc!.fulladstatus = fullAdStatus
//        self.navigationController?.present(vc!, animated: true, completion: nil)
    }
    @IBAction func letgGOButtonAction(_ sender: Any) {
        if checkStatus {
            UserDefaults.standard.set(true, forKey: ISFIRSTTIME)
            applaunch()
        } else {
            self.view.makeToast("Please accept Privacy Policy & Terms of Service", duration: 3.0, position: .bottom)
        }
    }
    
    func onFullAdsReturn(status: Bool) {
        print("statuus\(status)")
        self.fullAdStatus = status
    }
    func onCacheFullAdListener() {
//                if !UserDefaults.standard.bool(forKey: ISFIRSTTIME){
//                    applaunch()
//                }
        openDashboardThroughFullAdsCaching()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        LanguageManager.shared.defaultLanguage = .deviceLanguage
        LaunchFullCallBackListener.adsInstanceHelper.fulladsdelegates = self
        OnCacheFullAddListener.adsInstanceHelper.onCacheFullAdsdelegates = self
        SplashBannerListener.adsInstanceHelper.splashBannerdelegates = self
        UserDefaults.standard.set(currentLanguage, forKey: MyConstant.constants.APPLE_LANGUAGE)
//        callDelegates()
        getBannerAds()
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        getBannerAds()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        if !UserDefaults.standard.bool(forKey: MyConstant.PERMISSION_GRANTED){
            locationManager?.requestAlwaysAuthorization()
        }
       
       // getFirebaseTrackScreen(SPLASH_SCREEN)
    }
    
   
    
    private func startTimer() {
        self.splashCounter = 6
        self.splashTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        print(self.splashCounter)
        if splashCounter != 0 {
            splashCounter -= 1
        } else {
            if let splashTimer = self.splashTimer {
                splashTimer.invalidate()
                self.splashTimer = nil
                applaunch()
            }
        }
    }
    
    func applaunch(){
//        startAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            do {
                print("type and valuebshshshs11111\(type) \(value)")
                if (type != "" && value != "") {
                    let vc = UIStoryboard.init(name: "Engine", bundle: Bundle.main).instantiateViewController(withIdentifier:"TransparentFullAdLaunchVC" ) as? TransparentFullAdLaunchVC
                    print("type and valuebshshshs222\(type) \(value)")
                    vc!.type = type
                    vc!.value = value
                    vc!.fulladstype = Launch_FullAds
                    self.navigationController?.pushViewController(vc!, animated: true)
                } else {
                    
                    if ServiceHelper.sharedInstanceHelper.isConnectedToNetwork(){
                        
                        if !hasPurchased(){
                            if ETC_3 == "1" {
                                if !UserDefaults.standard.bool(forKey: FIRST_TIME_ONPURCHASE){
                                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PurchaseVC") as? PurchaseVC
                                    vc?.fromMoreTool = false
                                    vc!.fulladstatus = fullAdStatus
                                    vc!.fulladstype = Launch_FullAds
                                    self.navigationController?.pushViewController(vc!, animated: true)
                                }else{
                                    goToNextVC()
                                }
                            }else{
                                goToNextVC()
                            }
                        }else{
                            goToDashBoard()
                        }
                    }else{
                        goToNextVC()
                    }
                    
                }
            }
            catch  {
            }
        }
    }
    
    
    func goToDashBoard() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC
        vc!.value = value
        vc!.type = type
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    
    func goToNextVC(){

            if fullAdStatus {
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "WifiVC") as? WifiVC
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            else{
                let vc = UIStoryboard.init(name: "Engine", bundle: Bundle.main).instantiateViewController(withIdentifier: "TransparentFullAdLaunchVC") as? TransparentFullAdLaunchVC
                vc!.fulladstype = Launch_FullAds
                self.navigationController?.pushViewController(vc!, animated: true)
            }

    }
    
    
   
    func runnable(){
        if (!UserDefaults.standard.bool(forKey: ISFIRSTTIME) || !self.isFulladsLoaded || !self.isBannerLoaded ) {
            self.isFirstadsnotLoaded = true
            self.letsGoButton.isHidden = false
            self.andLabel.isHidden = false
            self.agreeLabel.isHidden = false
            self.termsButton.isHidden = false
            self.policiesButton.isHidden = false
        }
    }
    private  func openDashboardThroughFullAdsCaching(){
        isFulladsLoaded = true
        if (!UserDefaults.standard.bool(forKey: ISFIRSTTIME) && isBannerLoaded) {
            letsGoButton.isHidden = false
            andLabel.isHidden = false
            agreeLabel.isHidden = false
            termsButton.isHidden = false
            policiesButton.isHidden = false
            runnable()
        }
    }
    
    
    



    private func playAnimation(){
        splashAnimationView=LottieAnimationView(name: "splash")
        splashAnimationView.contentMode = .scaleAspectFit
        splashAnimationView.center=animationView.center
        splashAnimationView.frame = animationView.bounds
        splashAnimationView.loopMode = .playOnce
        splashAnimationView.animationSpeed = 1
        splashAnimationView.play()
        animationView?.addSubview(splashAnimationView)


    }
    
}


