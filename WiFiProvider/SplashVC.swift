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

import Network



class SplashVC: UIViewController ,OnCacheFullAddListenerProtocol,LaunchFullCallBackListenerProtocol ,SplashBannerListenerProtocol,OnBannerAdsIdLoadedProtocol{
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
//        Bundle.swizzleLocalization()
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
        
        LaunchFullCallBackListener.adsInstanceHelper.fulladsdelegates = self
        OnCacheFullAddListener.adsInstanceHelper.onCacheFullAdsdelegates = self
        SplashBannerListener.adsInstanceHelper.splashBannerdelegates = self
//        callDelegates()
        getBannerAds()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        getBannerAds()
        getFirebaseTrackScreen(SPLASH_SCREEN)
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
                                    let vc = UIStoryboard.init(name: "Engine", bundle: Bundle.main).instantiateViewController(withIdentifier: "PurchaseVC") as? PurchaseVC
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
    
    
    
//   func getIPAddress() -> String {
//    var address: String?
//    var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
//    if getifaddrs(&ifaddr) == 0 {
//        var ptr = ifaddr
//        while ptr != nil {
//            defer { ptr = ptr?.pointee.ifa_next }
//
//            guard let interface = ptr?.pointee else { return "" }
//            let addrFamily = interface.ifa_addr.pointee.sa_family
//            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
//
//                // wifi = ["en0"]
//                // wired = ["en2", "en3", "en4"]
//                // cellular = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]
//
//                let name: String = String(cString: (interface.ifa_name))
//                if  name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
//                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
//                    getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
//                    address = String(cString: hostname)
//                }
//            }
//        }
//        freeifaddrs(ifaddr)
//    }
//    return address ?? ""
//}
//
//    func getConnectedWifiList() {
//        PlainPing.ping("www.google.com", withTimeout: 1.0, completionBlock: { (timeElapsed:Double?, error:Error?) in
//            if let latency = timeElapsed {
////                self.pingResultLabel.text = "latency (ms): \(latency)"
//                print("latency (ms): \(latency)")
//            }
//
//
//            if let error = error {
//                print("error: \(error.localizedDescription)")
//            }
//        })
////
////           let task = Process()
////            task.launchPath = "/sbin/ping"
////            task.arguments = ["-c", "1", ipAddress]
////            let pipe = Pipe()
////            task.standardOutput = pipe
////            task.launch()
////            task.waitUntilExit()
////            let data = pipe.fileHandleForReading.readDataToEndOfFile()
////            let output = String(data: data, encoding: .utf8)
////            print(output ?? "No output")
//
//    }
//
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

