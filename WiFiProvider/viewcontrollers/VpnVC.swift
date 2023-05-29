//
//  VpnVC.swift
//  WiFiProvider
//
//  Created by gautam  on 11/05/23.
//

import UIKit
import Network
import Toast_Swift

@available(iOS 13.0, *)
class VpnVC: UIViewController,ConnectionStateDelegate,CountrySelectionListDelegate,VPNConnectedStatusDelegate,ConnectionStatusDelegate,CountryControllerProtocol,TimerManagerDelegate
{
    func timerUpdated(time: TimeInterval) {
        updateTimerLabel(time: time)
    }
    
    func connectedTimer(connectedTimer: String) {
       print("connectedTimer\(connectedTimer)")
    }
    
    func connectionState(uploadSpeed: String, downloadSpeed: String) {
        print("speed \(uploadSpeed) \(downloadSpeed)")
    }
    
    func countrySelection(countrySelection: String, fileLocation: String) {
        countrylabel.text = countrySelection
        profileVM.connection.setCustomConfigFile(url: fileLocation)
    }
    
    func vpnConnectedStatus(status: Bool) {
        print("status \(status)")
    }
    
    func countryChanged(newCountry: Bool) {
        
        
        connectButton.setTitle("Connect", for: .normal)
        statuslabel.text = "Not Connected"
        statuslabel.textColor = hexStringColor(hex: "#EC2727")
        TimerManager.shared.stopTimer()
        profileVM.connection.stopVPN()
        buttonSwitched = false
       
    }
    
    func connectionStatus(connectionStatus: String) {
        if connectionStatus == "connected" {
            statuslabel.text = "Connected"
            print("connected succesfully")
            setStatus(value: true)
            //delegate.setStatus(value: true)
            
        }
        
    }
    
    func setStatus(value: Bool) {
        if value == true {
            connectButton.setTitle("Disconnect", for: .normal)
            statuslabel.text = "Connected"
        }
        else {
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
        var internetStatus = Bool()
        var countryStatus = Bool()
      //  var profileVM = ProfileViewModel()
        var countryData = [DataModel]()
        var buttonSwitched : Bool = false
        var speedTestVM = SpeedTestViewModel()
        let profileVM = ProfileViewModel()
        override func viewDidLoad() {
            super.viewDidLoad()
            statuslabel.textColor = hexStringColor(hex: "#EC2727")
                // ConnectedTimer.instanceHelper.itemdelegates = self
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideView))
            transView.addGestureRecognizer(tapGesture)
            let monitor = NetworkSpeedMonitor()
            monitor.startMonitoring()
            ConnectionState.instanceHelper.itemdelegates = self
            ConnectionStatus.instanceHelper.itemdelegates = self
            callCatApi()
            // Stop monitoring after a certain duration or when needed
            // monitor.stopMonitoring()
            TimerManager.shared.delegate = self
                    
                    let elapsedTime = TimerManager.shared.getElapsedTime()
                    updateTimerLabel(time: elapsedTime)
//            let elapsedTime = TimerManager.shared.getElapsedTime()
//                updateTimerLabel(time: elapsedTime)
        }
    func updateTimerLabel(time: TimeInterval) {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        
        let formattedString = formatter.string(from: time)
        timerLabel.text = formattedString
    }

//    func updateTimerLabel(time: TimeInterval) {
//        let formatter = DateComponentsFormatter()
//        formatter.allowedUnits = [.hour, .minute, .second]
//        formatter.zeroFormattingBehavior = .pad
//        
//        let formattedString = formatter.string(from: time)
//        timerLabel.text = formattedString
//    }

    override func viewDidAppear(_ animated: Bool) {
          
        CountrySelectionList.instanceHelper.itemdelegates = self
        
    }
        
    override func viewWillAppear(_ animated: Bool) {
        getBannerAd(self, adView, heightConstraint)
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
        }
    private func hideBottomSheet(){
        bottomSheet.isHidden = true
     }
    @IBAction func connectButtonActions(_ sender: UIButton) {
        TimerManager.shared.startTimer()
        if NetworkHelper.sharedInstanceHelper.isConnectedToNetwork(){
            ConnectionStatus.instanceHelper.itemdelegates = self
            self.buttonSwitched = !self.buttonSwitched
            if self.buttonSwitched{
               
              
                    
                    Settings.saveProfile(profile: profileVM.profile)
                    Settings.setSelectedProfile(profileId: profileVM.profile.profileId)
                    
                    profileVM.mainButtonAction()
                    print("called for data")
               
                
               
                
            }
            
            else {
                profileVM.connection.stopVPN()
              //ConnectionStatus.instanceHelper.itemdelegates = self
                
            }
        }
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
       // KRProgressHUD.show()
        if NetworkHelper.sharedInstanceHelper.isConnectedToNetwork(){
            CountryDataVM.shared.getExcercise(completion: {categoryList,error  in

                if error == "No Internet Connection"{

                }else{
                    if categoryList.count == 0{
                       // KRProgressHUD.dismiss()
                      
                    }else{
                     //   KRProgressHUD.dismiss()
                        self.countryData=categoryList
                        print("co\(self.countryData[0].vpnname)")
                        if UserDefaults.standard.string(forKey: "VPN_NAME") == nil {
                        self.countrylabel.text = self.countryData[0].vpnname
                        self.flagImg.sd_setImage(with: URL.init(string: self.countryData[0].vpn_flag))
                        self.profileVM.connection.setCustomConfigFile(url: self.countryData[0].file_location)
                            
                        }
                    }
                }
            })
        }else{
           // fetchCategoryInDirectory(cell:cell)
          //  KRProgressHUD.dismiss()
        }

    }
  
   
    
    }
