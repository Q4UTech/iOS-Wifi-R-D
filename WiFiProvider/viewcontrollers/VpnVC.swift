//
//  VpnVC.swift
//  WiFiProvider
//
//  Created by gautam  on 11/05/23.
//

import UIKit
import Network

class VpnVC: UIViewController,ConnectionStateDelegate,CountrySelectionListDelegate,VPNConnectedStatusDelegate,ConnectionStatusDelegate,CountryControllerProtocol
{
    func connectionState(uploadSpeed: String, downloadSpeed: String) {
        print("")
    }
    
    func countrySelection(countrySelection: String, fileLocation: String) {
        print("")
    }
    
    func vpnConnectedStatus(status: Bool) {
        print("")
    }
    
    func countryChanged(newCountry: Bool) {
        
//        connectButton.setTitle("Connect", for: .normal)
//        taponButton.setTitle("Your Status: Not Connected", for: .normal)
    //    profileVM.connection.stopVPN()
        buttonSwitched = false
    }
    
    func connectionStatus(connectionStatus: String) {
        if connectionStatus == "disconnected" {
//            connectButton.setTitle("Connect", for: .normal)
//            taponButton.setTitle("Your Status: Not Connected", for: .normal)
        }
        else {
           // connectButton.setTitle(connectionStatus, for: .normal)
        }
        
    }
    
    func setStatus(value: Bool) {
        if value == true {
//            connectButton.setTitle("Disconnect", for: .normal)
//            taponButton.setTitle("Your Status: Connected", for: .normal)
        }
        else {
//            connectButton.setTitle("Connect", for: .normal)
//            taponButton.setTitle("Your Status: Not Connected", for: .normal)
        }
    }
    
        @IBOutlet weak var adView:UIView!
        @IBOutlet weak var heightConstraint:NSLayoutConstraint!
        @IBOutlet weak var transView:UIView!
        @IBOutlet weak var bottomSheet:UIView!
        @IBOutlet weak var innerImg:UIImageView!
        var internetStatus = Bool()
        var countryStatus = Bool()
      //  var profileVM = ProfileViewModel()
        var countryData = [DataModel]()
        var buttonSwitched : Bool = false
        var speedTestVM = SpeedTestViewModel()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideView))
            transView.addGestureRecognizer(tapGesture)
            let monitor = NetworkSpeedMonitor()
            monitor.startMonitoring()
            
            innerImg.layer.shadowColor = UIColor(red: 0, green: 0.8706, blue: 0.9176, alpha: 1.0).cgColor
            innerImg.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            innerImg.layer.shadowOpacity = 4.0
            innerImg.layer.shadowRadius = 1.0
            innerImg.layer.masksToBounds = true
            innerImg.layer.cornerRadius = 1.0
            // Stop monitoring after a certain duration or when needed
            // monitor.stopMonitoring()
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
    }
