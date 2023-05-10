//
//  ViewController.swift
//  LanScanner
//
//  Created by Poornima on 23/03/23.
//

import UIKit
import NetworkExtension
import Network

enum Network: String {
    case wifi = "en0"
    case cellular = "pdp_ip0"
    //... case ipv4 = "ipv4"
    //... case ipv6 = "ipv6"
}

class ViewController: UIViewController,LANScannerDelegate,WifiDelegate{
    func showList(list: [String]) {
        print("listCount \(list.count)")
    }
    
    var wifiHelper:WifiHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MainListHelper.instanceHelper.wifiDelegate = self
        wifiHelper = WifiHelper(limit:254)
        wifiHelper?.startWifiScan()
       
       
    }
   

    func myMethod(number: Int) {
     ///   print("Called myMethod with number \(number)")
    }
    
   
}

