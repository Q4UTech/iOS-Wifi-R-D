//
//  Helper.swift
//  LanScanner
//
//  Created by gautam  on 08/05/23.
//


import Foundation
class WifiHelper:LANScannerDelegate{
    var limit:Int
    var wifiList = [String]()
    
    init(limit:Int){
        self.limit = limit
       
    }
    
    func startWifiScan(){
        
        DispatchQueue.global(qos: .background).async {
            let scanner = LANScanner(delegate: self, continuous: false)
            scanner.startScan(limit:self.limit)
        }
       

    }
    
    func LANScannerFinished() {
        print("finished \(wifiList.count)")
        MainListHelper.instanceHelper.showList(list: wifiList)
    }
    
    func LANScannerRestarted() {
        
    }
    
    func LANScannerDiscovery(_ device: LANDevice) {
            
            print("Device ip list : \(device.ipAddress) hostname: \(device.hostName)")
            wifiList.append(device.ipAddress)
             
      
    }
    
    func LANScannerFailed(_ error: NSError) {
       
    }
    
}
