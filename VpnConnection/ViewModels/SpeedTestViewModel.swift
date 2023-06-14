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
//import PlainPing
import SystemConfiguration.CaptiveNetwork
import CoreTelephony
import SpeedcheckerSDK
import CoreLocation


class SpeedTestViewModel{
//    func internetTestError(error: SpeedcheckerSDK.SpeedTestError) {
//       print(error)
//    }
//
//    func internetTestFinish(result: SpeedcheckerSDK.SpeedTestResult) {
//        print("latency \(result.latencyInMs)")
//
//    }
//
//    func internetTestReceived(servers: [SpeedcheckerSDK.SpeedTestServer]) {
//       print(servers)
//    }
//
//    func internetTestSelected(server: SpeedcheckerSDK.SpeedTestServer, latency: Int, jitter: Int) {
//        SpeedTestCompleteListener.instanceHelper.showData(data: latency)
//        pingData = "\(latency)"
//        UserDefaults.standard.set(pingData, forKey: "pingData")
//    }
//
//    func internetTestDownloadStart() {
//       print("Start")
//    }
//
//    func internetTestDownloadFinish() {
//        print("")
//    }
//
//    func internetTestDownload(progress: Double, speed: SpeedcheckerSDK.SpeedTestSpeed) {
//        print("")
//    }
//
//    func internetTestUploadStart() {
//        print("")
//    }
//
//    func internetTestUploadFinish() {
//        print("")
//    }
//
//    func internetTestUpload(progress: Double, speed: SpeedcheckerSDK.SpeedTestSpeed) {
//       print("")
//    }
    
    private var internetTest: InternetSpeedTest?
       private var locationManager = CLLocationManager()
    
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

               NetworkSpeedTest.shared.testDownloadSpeedWithTimout(timeout: 5.0) {  (speed,status, error) in
                
                if speed! > 0 && !status {
                    completion(speed!, 0,false)
                }else{
                    SpeedTestViewModel.init().uploadSpeedTest(completion: {
                        speed ,status in
                        if speed > 0 {
                       
                            completion(0,speed,status)
                        }
                    })
                }

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
       
    }
    
    func downloadSpeed(downloadSpeed:Double ,speedLabel:UILabel,currentSpeedLabel:UILabel,speedMeterView:WMGaugeView,status:Bool){
        DispatchQueue.main.async {
            if status {
               // speedMeterView.value = 0
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
    
//    func setPingData(pingLabel:UILabel){
//        PlainPing.ping("www.google.com", withTimeout: 1.0, completionBlock: { [self] (timeElapsed:Double?, error:Error?) in
//            if let latency = timeElapsed {
//                pingData = "\(String(latency).prefix(4))"
//                print("pingData\(pingData)")
//                UserDefaults.standard.set(pingData, forKey: "pingData")
//                pingLabel.text = pingData
//
//
//            }
//
//            if let error = error {
//                print("error: \(error.localizedDescription)")
//            }
//        })
//    }
    
//    func setPingData(pingLabel:UILabel) {
//
//            let config:PingConfiguration = PingConfiguration(interval: 1)
//
//
//        SwiftPing.pingOnce(host: "www.google.com",
//                                  configuration: config,
//                                  queue: DispatchQueue.main){ (response: PingResponse) in
//
//                                   print(response)
//                                   print(response.duration)
//                                   print(response.ipAddress)
//                                   print(response.error)
//                                   print(response.identifier)
//               }
//
//
//        }
    
    func setPingData(pingLabel:UILabel) {
       
//        internetTest = InternetSpeedTest(delegate: self)
//        internetTest?.startTest() { (error) in
//            if error != .ok {
//                print(error)
//            }
//        }
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
        print("ssid11233 \(String(describing: ssid))")
        return ssid
    }
}

