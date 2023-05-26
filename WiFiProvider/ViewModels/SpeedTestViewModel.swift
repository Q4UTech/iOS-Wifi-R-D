//
//  SpeedTestViewModel.swift
//  Q4U_VPNAPP
//
//  Created by Deepti Chawla on 13/04/21.
//  Copyright © 2021 Anchorfree Inc. All rights reserved.
//

import Foundation
import UIKit
import WMGaugeView
import Toast_Swift
import PlainPing
import SystemConfiguration.CaptiveNetwork
import CoreTelephony

class SpeedTestViewModel{
    var speedTestList  = [String:[SpeedTestData]]()
    var speedDataList = [SpeedTestData]()
    var downLoadArray = [Double]()
    var uploadArray = [Double]()
    var downloadSpeed:Double = 0.0
    var uploadSpeed:Double = 0.0
    var pingData = String()
    var currentTime:String? = ""
    func downloadSpeedTest(target: UIViewController, completion:@escaping (_ speed: Double,_ uploadSpeed:Double,_ status:Bool) -> Void) {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async { [self] in
                
//                uploadArray.removeAll()
//                downLoadArray.removeAll()
            if NetworkHelper.sharedInstanceHelper.isConnectedToNetwork(){
                NetworkSpeedTest.shared.testDownloadSpeedWithTimout(timeout: 5.0) { [self]  (speed,status, error) in
                   
                    if speed! > 0 && !status {
                        print("speedData \(speed)")
                        downLoadArray.append(speed!)
                        
                       
                        completion(speed!, 0,false)
                        if status{
                            SpeedTestCompleteListener.instanceHelper.downloadFinsihedFinished(isFinsihed: true,data: downLoadArray)
                        }
                        
                    }else{
                        SpeedTestViewModel.init().uploadSpeedTest(completion: { [self]
                            speed ,status in
                            if speed > 0 {
                                uploadArray.append(speed)
                                print("uploadArray\(uploadArray.count)")
                                completion(0,speed,status)
                             //   uploadSpeed = speed
                                if status{
                                    if #available(iOS 15, *) {
                                        let today = Date.now
                                        let formatter1 = DateFormatter()
                                        formatter1.dateFormat = "d MMMM"
                                        print(formatter1.string(from: today))
                                       

                                        // Convert the date to the desired output format
                                      
                                       
                                      currentTime = getCurrentTime()
                                      pingData = UserDefaults.standard.string(forKey: "pingData")!
                                       
                                      print("speedList1 \(pingData)")
                                        if UserDefaults.standard.data(forKey: MyConstant.SPEED_LIST) == nil{
                                            speedTestList[formatter1.string(from: today)] = [SpeedTestData(time: currentTime!, ping: pingData, downloadSpeed: downLoadArray.last!, uploadSpeed: uploadArray.last!,connectionType: getConnectionType(),ipAddress: getIFAddresses(),providerName: getWiFiSsid()! )]
                                            speedDataList.append(SpeedTestData(time: currentTime!, ping: pingData, downloadSpeed: downLoadArray.last!, uploadSpeed: uploadArray.last!,connectionType: getConnectionType(),ipAddress: getIFAddresses(),providerName: getWiFiSsid()!))
                                            if let encode = try?  JSONEncoder().encode(speedTestList) {
                                                UserDefaults.standard.set(encode, forKey:MyConstant.SPEED_LIST)
                                            }
                                            print("speedDataList7777\(speedDataList)")
                                           
                                        }else {
                                            speedDataList.append(SpeedTestData(time: currentTime!, ping: pingData, downloadSpeed: downLoadArray.last!, uploadSpeed: uploadArray.last!,connectionType: getConnectionType(),ipAddress: getIFAddresses(),providerName: getWiFiSsid()! ))
                                            print("speedDataList77\(speedDataList)")
                                            if let savedData = UserDefaults.standard.data(forKey: MyConstant.SPEED_LIST) {
                                                do {
                                                         
                                                    speedTestList = try JSONDecoder().decode([String:[SpeedTestData]].self, from: savedData)
                                                    print("speedDataList777\(speedDataList)")
                                                    for (_ ,data) in speedTestList{
                                                        print("dataCount \(data.count)")
                                                        for i in data{
                                                            speedDataList.append( SpeedTestData(time: i.time, ping:i.ping, downloadSpeed: i.downloadSpeed, uploadSpeed: i.uploadSpeed,connectionType: getConnectionType(),ipAddress: getIFAddresses(),providerName: getWiFiSsid()!))
                                                        }

                                                    }
                                                    speedTestList[formatter1.string(from: today)] = speedDataList
                                                    if let encode = try?  JSONEncoder().encode(speedTestList) {
                                                        UserDefaults.standard.set(encode, forKey:MyConstant.SPEED_LIST)
                                                    }
                                                    print("working11 \(speedDataList.count)")
                                                }catch{

                                                }
                                            }
                                        }
                                        SpeedTestCompleteListener.instanceHelper.uploadFinished(isFinsihed: true,data: uploadArray)
                                    } else {
                                        // Fallback on earlier versions
                                    }
                                }
                            }
                        })
                    }
                    print("speedData1 \(speed) \(status)")
                    

                }
                
                
            }else{
                target.view.makeToast(MyConstant.constants.kCheckInternet, point: CGPoint(x:target.view.center.x, y: target.view.frame.maxY - 70), title: "", image: nil, completion: nil)
            }
           
        }
        }
    }

    
    func uploadSpeedTest(completion:@escaping (_ speed: Double,_ status:Bool) -> Void){
        DispatchQueue.global(qos: .background).async {
            UploadNetworkSpeedTest.shared.testUploadSpeedWithTimout(timeout: 5.0) {  (speed, status,error) in
                completion(speed!,status)
                
            }
           
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+5) { [self] in
            pingData = UserDefaults.standard.string(forKey: "pingData")!
            SpeedTestCompleteListener.instanceHelper.isSpeedCheckComplete(complete: true,ping:pingData,upload: uploadArray.last ?? 1.09  ,download: downLoadArray.last ?? 2.03)
        }
    }
    
    func downloadSpeed(downloadSpeed:Double ,speedLabel:UILabel,currentSpeedLabel:UILabel,speedMeterView:WMGaugeView,status:Bool){
        DispatchQueue.main.async {
            if status {
                speedMeterView.value = 0
            }else{
                speedMeterView.setValue(Float(downloadSpeed), animated: true, duration: 0.1) { finished in
                                }
              //  speedMeterView.progress = CGFloat(Float(downloadSpeed))
                speedLabel.text = String(format:  MyConstant.constants.kFormat, downloadSpeed)
                currentSpeedLabel.text = String(format:  MyConstant.constants.kFormat, downloadSpeed)
            }
           
        }
    }
    
    
    func setSpeedMeterValue(speedMeterView:WMGaugeView){
        speedMeterView.needleStyle = WMGaugeViewNeedleStyleFlatThin
        speedMeterView.needleHeight = 0.3
        speedMeterView.backgroundColor = UIColor.clear
        speedMeterView.showInnerBackground = false
        speedMeterView.innerRimBorderWidth = 8
        speedMeterView.tintColor = UIColor.green
        speedMeterView.showInnerRim = true
      
        speedMeterView.minValue = 0
        speedMeterView.maxValue = 100.0
        speedMeterView.scaleDivisions = 10
//        speedMeterView.scaleSubdivisions = 5
        speedMeterView.scaleStartAngle = 35
        speedMeterView.scaleEndAngle = 315
        speedMeterView.showScaleShadow = false
        speedMeterView.scaleDivisionColor = UIColor.white
        speedMeterView.unitOfMeasurementColor = UIColor.green
        speedMeterView.scalesubdivisionsaligment = WMGaugeViewSubdivisionsAlignmentCenter
        speedMeterView.scaleSubdivisionsWidth = 0.000
        speedMeterView.scaleSubdivisionsLength = 0.00
        speedMeterView.scaleDivisionsWidth = 0.000
        speedMeterView.scaleDivisionsLength = 0.00
        
//        speedMeterView.needleStyle = WMGaugeViewNeedleStyleFlatThin
//        speedMeterView.backgroundColor = UIColor.clear
//        speedMeterView.showInnerBackground = false
//        speedMeterView.minValue = 0
//        speedMeterView.maxValue = 100.0
//        speedMeterView.scaleDivisions = 10
//        speedMeterView.scaleSubdivisions = 10
//        speedMeterView.scaleStartAngle = 45
//        speedMeterView.scaleEndAngle = 315
//        speedMeterView.showScaleShadow = false
//        speedMeterView.scaleDivisionColor = UIColor.white
//        speedMeterView.unitOfMeasurementColor = UIColor.white
//        speedMeterView.scalesubdivisionsaligment = WMGaugeViewSubdivisionsAlignmentCenter
//        speedMeterView.scaleSubdivisionsWidth = 0.002
//        speedMeterView.scaleSubdivisionsLength = 0.04
//        speedMeterView.scaleDivisionsWidth = 0.007
//        speedMeterView.scaleDivisionsLength = 0.07
        
       
//        speedMeterView.maxValue = 240.0
//        speedMeterView.showRangeLabels = true
//        speedMeterView.rangeValues = [50, 90, 130, 240.0]
//
//        speedMeterView.rangeLabels = ["VERY LOW", "LOW", "OK", "OVER FILL"]
//        speedMeterView.unitOfMeasurement = "psi"
//        speedMeterView.showUnitOfMeasurement = true
//        speedMeterView.scaleDivisionsWidth = 0.008
//        speedMeterView.scaleSubdivisionsWidth = 0.006
//        speedMeterView.rangeLabelsFontColor = UIColor.black
//        speedMeterView.rangeLabelsWidth = 0.04
//        speedMeterView.rangeLabelsFont = UIFont(name: "Helvetica", size: 0.04)
//
//       // speedMeterView.style = WMGaugeViewStyleFlatThin()
//        speedMeterView.maxValue = 100.0
//        speedMeterView.scaleDivisions = 10
//        speedMeterView.scaleSubdivisions = 5
//        speedMeterView.scaleStartAngle = 30
//        speedMeterView.scaleEndAngle = 280
//        speedMeterView.showScaleShadow = false
//      //  speedMeterView.scaleFont = UIFont(name: "AvenirNext-UltraLight", size: 0.065)
////speedMeterView.scalesubdivisionsAligment = WMGaugeViewSubdivisionsAlignmentCenter
//        speedMeterView.scaleSubdivisionsWidth = 0.002
//        speedMeterView.scaleSubdivisionsLength = 0.04
//        speedMeterView.scaleDivisionsWidth = 0.007
//        speedMeterView.scaleDivisionsLength = 0.07

        

    }
    
    func setPingData(pingLabel:UILabel){
        PlainPing.ping("www.google.com", withTimeout: 1.0, completionBlock: { [self] (timeElapsed:Double?, error:Error?) in
            if let latency = timeElapsed {
                pingData = "\(String(latency).prefix(4))"
                print("pingData\(pingData)")
                UserDefaults.standard.set(pingData, forKey: "pingData")
                pingLabel.text = pingData
                
               
            }

            if let error = error {
                print("error: \(error.localizedDescription)")
            }
        })
    }
    
    private func getCurrentTime()->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"  // Set the desired format
        
        let currentTime = Date()
        let currentTimeString = formatter.string(from: currentTime)
        
        print("currentTimeString \(currentTimeString)")
        return currentTimeString
    }
    func getConnectionType() -> String {
            guard let reachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, "www.google.com") else {
                return "NO INTERNET"
            }

            var flags = SCNetworkReachabilityFlags()
            SCNetworkReachabilityGetFlags(reachability, &flags)

            let isReachable = flags.contains(.reachable)
            let isWWAN = flags.contains(.isWWAN)

            if isReachable {
                if isWWAN {
                    let networkInfo = CTTelephonyNetworkInfo()
                    let carrierType = networkInfo.serviceCurrentRadioAccessTechnology

                    guard let carrierTypeName = carrierType?.first?.value else {
                        return "UNKNOWN"
                    }

                    switch carrierTypeName {
                    case CTRadioAccessTechnologyGPRS, CTRadioAccessTechnologyEdge, CTRadioAccessTechnologyCDMA1x:
                        return "2G"
                    case CTRadioAccessTechnologyLTE:
                        return "4G"
                    default:
                        return "3G"
                    }
                } else {
                    return "WIFI"
                }
            } else {
                return "NO INTERNET"
            }
        }
   
    func getIFAddresses()->String {
        let url = URL(string: "https://api.ipify.org")
        var myIp=""
        do {
            if let url = url {
                let ipAddress = try String(contentsOf: url)
                myIp = ipAddress
                print("My public IP address is: " + ipAddress)
            }
        } catch let error {
            print(error)
        }
        return myIp
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
        return ssid
    }
}
