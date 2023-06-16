//
//  VpnVC.swift
//  WiFiProvider
//
//  Created by gautam  on 11/05/23.
//

import UIKit
import Network
import Toast_Swift
import KRProgressHUD

@available(iOS 13.0, *)
class VpnVC: UIViewController,ConnectionStateDelegate,CountrySelectionListDelegate,VPNConnectedStatusDelegate,ConnectionStatusDelegate,CountryControllerProtocol
,TimerManagerDelegate,LanguageSelectionDelegate{
    func exactStatus(status: String) {
        view.makeToast(status)
    }
    
    func languageSelection(name: String, code: String) {
        UserDefaults.standard.set(code, forKey: MyConstant.constant.APPLE_LANGUAGE)
        LanguageTimer.shared.startTimer(target: self)
    }
    
    func timerUpdated(time: TimeInterval) {
        // updateTimerLabel(time: time)
    }
    
    func connectedTimer(connectedTimer: String) {
        print("connectedTimer\(connectedTimer)")
    }
    
    func connectionState(uploadSpeed: String, downloadSpeed: String) {
        print("speed12 \(uploadSpeed) \(downloadSpeed)")
    }
    
    func countrySelection(countryFlag:String ,countrySelection: String, fileLocation: String) {
        flagImg.sd_setImage(with: URL.init(string: countryFlag))
        countrylabel.text = countrySelection
        profileVM.connection.setCustomConfigFile(url: fileLocation)
    }
    
    func vpnConnectedStatus(status: Bool) {
        print("status \(status)")
    }
    
    func countryChanged(newCountry: Bool) {
        
        
        connectButton.setTitle("Connect", for: .normal)
        statuslabel.text = "Not Connected"
        topImg.image = UIImage(named: "power_btn")
        statuslabel.textColor = hexStringColor(hex: "#EC2727")
        topViewUiLabel.text = "Start"
        stopBackgroundTiming()
        profileVM.connection.stopVPN()
        buttonSwitched = false
        
    }
    
    func connectionStatus(connectionStatus: String) {
        if connectionStatus == "connected" {
            statuslabel.text = "Connected"
            isConnected = true
            statuslabel.textColor = hexStringColor(hex: "#2EB92B")
            print("connected succesfully")
            setStatus(value: true)
            topViewUiLabel.text = "Stop"
            topImg.image = UIImage(named: "lock")
            //            TimerManager.shared.startTimer()
            startStopAction()
            //delegate.setStatus(value: true)
            
        }
        if connectionStatus == "connecting"{
            isConnected = false
            topViewUiLabel.text = "Wait"
            connectButton.setTitle("Connecting", for: .normal)
            statuslabel.text = "Connecting"
            connectButton.backgroundColor = hexStringColor(hex: "#202936")
            statuslabel.textColor = .white
            topImg.image = UIImage(named: "waiting")
            
        }
        
        if connectionStatus == "disconnected"{
            isConnected = false
            setStatus(value: false)
            topViewUiLabel.text = "Start"
            connectButton.setTitle("Connect", for: .normal)
            topImg.image = UIImage(named: "power_btn")
            statuslabel.text =  "Not Connected"
            
            // TimerManager.shared.stopTimer()
            stopBackgroundTiming()
            timerLabel.text = "00:00:00"
            statuslabel.textColor = hexStringColor(hex: "#EC2727")
        }
        
    }
    
    func setMsg(show:Bool){
        
        timer?.invalidate()
        view.makeToast("Server looks busy, please try with a different server.")
    }
    
    func setStatus(value: Bool) {
        if value{
            connectButton.backgroundColor = hexStringColor(hex: "#202936")
            connectButton.setTitle("Disconnect", for: .normal)
            statuslabel.text = "Connected"
        }
        else {
            connectButton.backgroundColor = hexStringColor(hex: "#2EB92B")
            connectButton.setTitle("Connect", for: .normal)
            statuslabel.text =  "Not Connected"
            statuslabel.textColor = hexStringColor(hex: "#EC2727")
        }
    }
    
    @IBOutlet weak var adView:UIView!
    @IBOutlet weak var heightConstraint:NSLayoutConstraint!
    @IBOutlet weak var transView:UIView!
    @IBOutlet weak var bottomSheet:UIView!
    @IBOutlet weak var countryView:UIView!
    @IBOutlet weak var countrylabel:UILabel!
    @IBOutlet weak var timerLabel:UILabel!
    @IBOutlet weak var innerImg:UIImageView!
    @IBOutlet weak var flagImg:UIImageView!
    @IBOutlet weak var connectButton:UIButton!
    @IBOutlet weak var statuslabel:UILabel!
    @IBOutlet weak var topView:UIView!
    @IBOutlet weak var disconnectView:UIView!
    @IBOutlet weak var topViewUiLabel:UILabel!
    @IBOutlet weak var topImg:UIImageView!
    var internetStatus = Bool()
    var countryStatus = Bool()
    var profileVM = ProfileViewModel()
    var countryData = [DataModel]()
    var buttonSwitched : Bool = false
    var speedTestVM = SpeedTestViewModel()
    var timer:Timer?
    var isConnected:Bool = false
    // let profileVM = ProfileViewModel()
    
    var timerCounting:Bool = false
    var startTime:Date?
    var stopTime:Date?
    
    let userDefaults = UserDefaults.standard
    let START_TIME_KEY = "startTime"
    let STOP_TIME_KEY = "stopTime"
    let COUNTING_KEY = "countingKey"
    
    var scheduledTimer: Timer!
    var connectionCounter:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LanguageSelectionListener.instanceHelper.itemdelegates = self
        statuslabel.textColor = hexStringColor(hex: "#EC2727")
        // ConnectedTimer.instanceHelper.itemdelegates = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideView))
        transView.addGestureRecognizer(tapGesture)
        let monitor = NetworkSpeedMonitor()
        monitor.startMonitoring()
        callDelegates()
        callCatApi()
        // Stop monitoring after a certain duration or when needed
        // monitor.stopMonitoring()
        TimerManager.shared.delegate = self
        
        //        let elapsedTime = TimerManager.shared.getElapsedTime()
        //        updateTimerLabel(time: elapsedTime)
        //            let elapsedTime = TimerManager.shared.getElapsedTime()
        //                updateTimerLabel(time: elapsedTime)
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: NSNotification.Name("AppWillBecomeActive"), object: nil)
        
        backgroundTimer()
    }
    func getScreenWidthResolution()->CGFloat{
        let screenSize: CGRect = UIScreen.main.bounds
        return screenSize.width
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
    
    
    func startStopAction()
    {
        if timerCounting
        {
            setStopTime(date: Date())
            stopTimer()
        }
        else
        {
            if let stop = stopTime
            {
                let restartTime = calcRestartTime(start: startTime!, stop: stop)
                setStopTime(date: nil)
                setStartTime(date: restartTime)
            }
            else
            {
                setStartTime(date: Date())
            }
            
            startTimer()
        }
    }
    
    private func backgroundTimer(){
        startTime = userDefaults.object(forKey: START_TIME_KEY) as? Date
        stopTime = userDefaults.object(forKey: STOP_TIME_KEY) as? Date
        timerCounting = userDefaults.bool(forKey: COUNTING_KEY)
        
        
        if timerCounting
        {
            startTimer()
        }
        else
        {
            stopTimer()
            if let start = startTime
            {
                if let stop = stopTime
                {
                    let time = calcRestartTime(start: start, stop: stop)
                    let diff = Date().timeIntervalSince(time)
                    setTimeLabel(Int(diff))
                }
            }
        }
    }
    func calcRestartTime(start: Date, stop: Date) -> Date
    {
        let diff = start.timeIntervalSince(stop)
        return Date().addingTimeInterval(diff)
    }
    func startTimer()
    {
        scheduledTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(refreshValue), userInfo: nil, repeats: true)
        setTimerCounting(true)
        
    }
    
    @objc func refreshValue()
    {
        if let start = startTime
        {
            let diff = Date().timeIntervalSince(start)
            setTimeLabel(Int(diff))
        }
        else
        {
            stopTimer()
            setTimeLabel(0)
        }
    }
    
    func setTimeLabel(_ val: Int)
    {
        let time = secondsToHoursMinutesSeconds(val)
        let timeString = makeTimeString(hour: time.0, min: time.1, sec: time.2)
        timerLabel.text = timeString
    }
    
    func secondsToHoursMinutesSeconds(_ ms: Int) -> (Int, Int, Int)
    {
        let hour = ms / 3600
        let min = (ms % 3600) / 60
        let sec = (ms % 3600) % 60
        return (hour, min, sec)
    }
    
    func makeTimeString(hour: Int, min: Int, sec: Int) -> String
    {
        var timeString = ""
        timeString += String(format: "%02d", hour)
        timeString += ":"
        timeString += String(format: "%02d", min)
        timeString += ":"
        timeString += String(format: "%02d", sec)
        return timeString
    }
    
    func stopTimer()
    {
        if scheduledTimer != nil
        {
            scheduledTimer.invalidate()
        }
        setTimerCounting(false)
        
    }
    
    private func stopBackgroundTiming(){
        setStopTime(date: nil)
        setStartTime(date: nil)
        timerLabel.text = makeTimeString(hour: 0, min: 0, sec: 0)
        stopTimer()
    }
    
    func setStartTime(date: Date?)
    {
        startTime = date
        userDefaults.set(startTime, forKey: START_TIME_KEY)
    }
    
    func setStopTime(date: Date?)
    {
        stopTime = date
        userDefaults.set(stopTime, forKey: STOP_TIME_KEY)
    }
    
    func setTimerCounting(_ val: Bool)
    {
        timerCounting = val
        userDefaults.set(timerCounting, forKey: COUNTING_KEY)
    }
    @objc func didEnterBackground() {
        print("didEnterBackground")
    }
    
    @objc func didBecomeActive() {
        print("didBecomeActive")
        //        TimerManager.shared.startTimer()
        // startStopAction()
        // backgroundTimer()
        
    }
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func updateTimerLabel(time: TimeInterval) {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        
        let formattedString = formatter.string(from: time)
        timerLabel.text = formattedString
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        callDelegates()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        callDelegates()
        //        callCatApi()
        hideUnhideMenuView(showTrans: true, showMenu: true)
        getBannerAd(self, adView, heightConstraint)
        if UserDefaults.standard.string(forKey: "VPN_NAME") != nil {
            countrylabel.text = UserDefaults.standard.string(forKey: "VPN_NAME")
            
        }
        if UserDefaults.standard.string(forKey: "VPN_FLAG") != nil {
            print("flag_data \( String(describing: UserDefaults.standard.string(forKey: "VPN_FLAG")))")
            flagImg.sd_setImage(with: URL.init(string: UserDefaults.standard.string(forKey: "VPN_FLAG")!))
        }
    }
    
    private func callDelegates(){
        ConnectionState.instanceHelper.itemdelegates = self
        ConnectionStatus.instanceHelper.itemdelegates = self
        CountrySelectionList.instanceHelper.itemdelegates = self
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
    @IBAction func openSpeedHistory(_ sender:UIButton){
        let vc = storyboard?.instantiateViewController(withIdentifier: "SpeedHistoryVC") as! SpeedHistoryVC
        navigationController?.pushViewController(vc, animated: true)
        showFullAds(viewController: self, isForce: false)
    }
    private func hideBottomSheet(){
        bottomSheet.isHidden = true
        transView.isHidden = true
    }
    @IBAction func connectButtonActions(_ sender: UIButton) {
        
        if NetworkHelper.sharedInstanceHelper.isConnectedToNetwork(){
            // ConnectionStatus.instanceHelper.itemdelegates = self
            self.buttonSwitched = !self.buttonSwitched
            //            if self.buttonSwitched{
            if !isConnected{
                
                
                
                Settings.saveProfile(profile: profileVM.profile)
                Settings.setSelectedProfile(profileId: profileVM.profile.profileId)
                
                profileVM.mainButtonAction()
                print("called for data")
                
                
                
                
            }else {
                
                hideUndideDialog(isShow: false)
                
                
                //ConnectionStatus.instanceHelper.itemdelegates = self
                
            }
        }
        
        
    }
    
    @IBAction func cancelDialog(_ sender: Any) {
        hideUndideDialog(isShow: true)
    }
    
    @IBAction func stopVpn(_ sender: Any) {
        profileVM.connection.stopVPN()
        hideUndideDialog(isShow: true)
    }
    
    private func hideUndideDialog(isShow:Bool){
        disconnectView.isHidden = isShow
    }
    
    
    @IBAction func locationListButtonAction(_ sender: Any) {
        if NetworkHelper.sharedInstanceHelper.isConnectedToNetwork(){
            
            goToCountryVC()
        }else{
            self.view.makeToast(MyConstant.constants.kCheckInternet, point: CGPoint(x:view.center.x, y: view.frame.maxY - 70), title: "", image: nil, completion: nil)
        }
    }
    @IBAction func openCountyVpnList(_ sender: Any) {
        if NetworkHelper.sharedInstanceHelper.isConnectedToNetwork(){
            
            goToCountryVC()
        }else{
            self.view.makeToast(MyConstant.constants.kCheckInternet, point: CGPoint(x:view.center.x, y: view.frame.maxY - 70), title: "", image: nil, completion: nil)
        }
    }
    
    @IBAction func openHistory(_ sender:UIButton){
        hideBottomSheet()
        let vc = storyboard?.instantiateViewController(withIdentifier: "SpeedHistoryVC") as! SpeedHistoryVC
        navigationController?.pushViewController(vc, animated: true)
        showFullAds(viewController: self, isForce: false)
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
        showFullAds(viewController: self, isForce: false)
        
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
    
    
    func goToCountryVC(){
        
        if #available(iOS 13.0, *) {
            let vc = UIStoryboard.init(name: MyConstant.constants.kMain, bundle: Bundle.main).instantiateViewController(withIdentifier:  MyConstant.keyName.kCountryVC) as? CountryVC
            
            if(countryData != nil){
                vc?.categoryData = countryData
                vc!.delegateSelectedCountry = self
                self.navigationController!.pushViewController(vc!, animated: true)
            }
        } else {
            // Fallback on earlier versions
        }
        //        showFullAds(viewController: self, isForce: false)
    }
    func setConnectionTimeVisibility(status:Bool){
        //  connectionTime.isHidden = status
    }
    
    
    func callCatApi(){
        //        if Thread.current.isCancelled {
        //            // do cleanup here
        //            Thread.exit()
        //        }
        //
        
        
        // KRProgressHUD.showOn(self).show()
        if NetworkHelper.sharedInstanceHelper.isConnectedToNetwork(){
            
            
            
            
            print("call 11")
            
            //            DispatchQueue.global(qos: .background).async {
            //                print("call 22")
            //            DispatchQueue(label: "com.knowstack.queue1").async {
            
            let obj = VPNScannerThread();
            obj.setWifiVC(self);
            obj.start();
            //            callVPNListFromServer()
            print("call 66")
            //           }
        }else{
            // fetchCategoryInDirectory(cell:cell)
            KRProgressHUD.dismiss()
        }
        
    }
    
    
    class VPNScannerThread:Thread{
        var vc:VpnVC?=nil
        
        func setWifiVC(_ vc:VpnVC){
            self.vc=vc;
        }
        
        override func main() {
            vc?.callVPNListFromServer()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // UserDefaults.standard.set(, forKey: <#T##String#>)
    }
    
    private func callVPNListFromServerUsingURLSession(){
        guard let url = URL(string: "https://quantum4you.com/engine/vpnserviceapi/response") else {
            print("Invalid URL")
            return
        }
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Set the request body with parameters
        let params = ["app_id":APP_ID,
                      "country": getCountryNameInfo(),
                      "screen": getScreenWidthResolution(),
                      "launchcount": "1",
                      "version": getAppVersionInfo(),
                      "osversion": getOSInfo(),
                      "dversion": "iphone",
                      "os": "2"] as [String : Any]
        
        do {
            
            //                    let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
            //                    request.httpBody = jsonData
            let task = session.dataTask(with: request) { [self] (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                print("response_data\(response)")
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid response")
                    return
                }
                
                if httpResponse.statusCode == 200 {
                    if let data = data {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                
                                let array = json["countries"] as? NSArray
                                print("arr_data \(array?.count)\(array)")
                                // print("status \(String(describing: status)) \(jObject)")
                                for i in array! {
                                    let data:Dictionary? = i as? Dictionary<String, Any>
                                    let vpnname = data!["vpnname"] as? String
                                    let vpncode = data!["vpncode"] as? String
                                    let username = data!["username"] as? String
                                    let password = data!["password"] as? String
                                    let vpn_flag = data!["vpn_flag"] as? String
                                    let file_location = data!["file_location"] as? String
                                    let purchsedType = data!["purchsedType"] as? String
                                    countryData.append(DataModel(vpnname: vpnname!,vpncode: vpncode!, username: username!, password: password!, vpn_flag: vpn_flag!, file_location: file_location!, purchsedType: purchsedType!))
                                    
                                }
                                DispatchQueue.main.async { [self] in
                                    KRProgressHUD.dismiss()
                                    
                                    
                                    print("co\(self.countryData[0].vpnname)")
                                    if UserDefaults.standard.string(forKey: "VPN_NAME") == nil {
                                        
                                        
                                        
                                        self.countrylabel.text = self.countryData[0].vpnname
                                        self.flagImg.sd_setImage(with: URL.init(string: self.countryData[0].vpn_flag))
                                        self.profileVM.connection.setCustomConfigFile(url: self.countryData[0].file_location)
                                        
                                    }
                                }}
                        } catch {
                            print("Error parsing JSON: \(error.localizedDescription)")
                        }
                    }
                } else {
                    print("HTTP response status code: \(httpResponse.statusCode)")
                }
            }
            task.resume()
        } catch {
            print("Error creating JSON data: \(error.localizedDescription)")
            return
        }
        
    }
    private func callVPNListFromServer(){
        CountryDataVM.shared.getExcercise(completion: {categoryList,error  in
            print("call 33")
            if error == "No Internet Connection"{
                print("call 44")
            }else{
                print("call 55")
                if categoryList.count == 0{
                    // KRProgressHUD.dismiss()
                    //
                    
                }else{
                    //   KRProgressHUD.dismiss()
                    self.countryData=categoryList
                    print("co\(self.countryData[0].vpnname)")
                    if UserDefaults.standard.string(forKey: "VPN_NAME") == nil {
                        DispatchQueue.main.async {
                            
                            
                            self.countrylabel.text = self.countryData[0].vpnname
                            self.flagImg.sd_setImage(with: URL.init(string: self.countryData[0].vpn_flag))
                            self.profileVM.connection.setCustomConfigFile(url: self.countryData[0].file_location)
                        }
                    }
                }
            }
        })
    }
    
    
    
}
