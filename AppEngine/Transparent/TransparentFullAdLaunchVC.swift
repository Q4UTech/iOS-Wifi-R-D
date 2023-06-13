//
//  TransparentFullAdLaunchVC.swift
//  App Engine
//
//  Created by Quantum_MAC_7 on 03/04/20.
//  Copyright © 2020 Pulkit Babbar. All rights reserved.
//

import UIKit


class TransparentFullAdLaunchVC: UIViewController,AppFullAdsCloseProtocol,FullAdsCloseListenerProtocol,LaunchFullCallBackListenerProtocol {

    var fulladstype = String()
    var type = String()
    var value = String()
    var fullAdTimer : Timer?
    var fullAdcounter = 3
    var isFirstTime = false
    var service = String()
    @IBOutlet weak var crossButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        crossButton.isHidden = true
        AppFullAdsCloseListner.adsInstanceHelper.fulladsclosedelegates = self
        FullAdsCloseListener.adsInstanceHelper.fulladsdelegates = self
        LaunchFullCallBackListener.adsInstanceHelper.fulladsdelegates = self
        startTimer()
        let hasInAppPurchased = UserDefaults.standard.bool(forKey: IN_APP_PURCHASED)
        print("hasInAppPurchased12 \(hasInAppPurchased)")
        if hasInAppPurchased {
            goTODashboard()
        }
        else{
            if ServiceHelper.sharedInstanceHelper.isConnectedToNetwork(){
                if fulladstype  == Launch_FullAds {
                    HandleLaunchFullAds.shared.handle_launch_For_FullAds(viewController: self,value: value,type: type,crossButtons:crossButton)
                }
            }
            else{
                goTODashboard()
            }
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.isStatusBarHidden = true
    }

    private func startTimer() {
        self.fullAdcounter = 3
        self.fullAdTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    @objc func updateTimer() {

        if fullAdcounter != 0 {
            fullAdcounter -= 1
        } else {
            if let timer = self.fullAdTimer {
                timer.invalidate()
                self.fullAdTimer = nil

                crossButton.isHidden = false
            }
        }
    }

    
    func goTODashboard(){
       
        let vc = UIStoryboard.init(name: MyConstant.keyName.kMain, bundle: Bundle.main).instantiateViewController(withIdentifier:"DashboardVC") as? DashboardVC
        vc?.value = value
        vc?.type = type
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func crosbuttonAction(_ sender: Any) {
        goTODashboard()
    }

    
    func onFullAdClosed(viewController: UIViewController) {
   
        goTODashboard()
        crossButton.isHidden = true
    }
    
    func onFullAdClose(_ viewController: UIViewController) {
       
        goTODashboard()
        crossButton.isHidden = true
    }
    
    func onFullAdsReturn(status: Bool) {
        
        
        if status && !isFirstTime{
            goTODashboard()
            isFirstTime = true
        }
    }
   
}






