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

class SpeedTestViewModel{
    var speedTestList  = [String:[SpeedTestData]]()
    var speedDataList = [SpeedTestData]()
    var downLoadArray = [Double]()
    var uploadArray = [Double]()
    var downloadSpeed:Double = 0.0
    var uploadSpeed:Double = 0.0
    func downloadSpeedTest(target: UIViewController, completion:@escaping (_ speed: Double,_ uploadSpeed:Double,_ status:Bool) -> Void) {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async { [self] in
                
                uploadArray.removeAll()
                downLoadArray.removeAll()
            if NetworkHelper.sharedInstanceHelper.isConnectedToNetwork(){
                NetworkSpeedTest.shared.testDownloadSpeedWithTimout(timeout: 5.0) { [self]  (speed,status, error) in
                   
                    if speed! > 0 && !status {
                        print("speedData \(speed)")
                        downLoadArray.append(speed!)
                        SpeedTestCompleteListener.instanceHelper.showChartData(show: status,data: downLoadArray)
                        completion(speed!, 0,false)
                        
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
                                        formatter1.dateStyle = .short
                                        print(formatter1.string(from: today))
                                        
                                       
                                        
                                        print("speedList1 \(speedTestList.count)")
                                        if speedTestList[formatter1.string(from: today)] == nil{
                                            speedTestList[formatter1.string(from: today)] = [SpeedTestData(time: "2:09", ping: 0.00, downloadSpeed: downLoadArray.last!, uploadSpeed: uploadArray.last!)]
                                            speedDataList.append(SpeedTestData(time: "2:09", ping: 0.00, downloadSpeed: downLoadArray.last!, uploadSpeed:uploadArray.last!))
                                            if let encode = try?  JSONEncoder().encode(speedTestList) {
                                                UserDefaults.standard.set(encode, forKey:MyConstant.SPEED_LIST)
                                            }
                                            print("speedDataList7777\(speedDataList)")
                                        }else {
                                            speedDataList.append(SpeedTestData(time: "2:09", ping: 0.00, downloadSpeed: downLoadArray.last!, uploadSpeed:uploadArray.last!))
                                            print("speedDataList77\(speedDataList)")
                                            if let savedData = UserDefaults.standard.data(forKey: MyConstant.SPEED_LIST) {
                                                do {
                                                         
                                                    speedTestList = try JSONDecoder().decode([String:[SpeedTestData]].self, from: savedData)
                                                    print("speedDataList777\(speedDataList)")
                                                    for (_ ,data) in speedTestList{
                                                        print("dataCount \(data.count)")
                                                        for i in data{
                                                            speedDataList.append( SpeedTestData(time: i.time, ping:i.ping, downloadSpeed: i.downloadSpeed, uploadSpeed: i.uploadSpeed))
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [self] in
            SpeedTestCompleteListener.instanceHelper.isSpeedCheckComplete(complete: true,upload: uploadArray.last!,download: downLoadArray.last!)
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
        speedMeterView.backgroundColor = UIColor.clear
        speedMeterView.showInnerBackground = false
        speedMeterView.innerRimBorderWidth = 8
        speedMeterView.minValue = 0
        speedMeterView.maxValue = 100.0
        speedMeterView.scaleDivisions = 5
        speedMeterView.scaleSubdivisions = 5
        speedMeterView.scaleStartAngle = 45
        speedMeterView.scaleEndAngle = 315
        speedMeterView.showScaleShadow = false
        speedMeterView.scaleDivisionColor = UIColor.white
        speedMeterView.unitOfMeasurementColor = UIColor.green
        speedMeterView.scalesubdivisionsaligment = WMGaugeViewSubdivisionsAlignmentCenter
        speedMeterView.scaleSubdivisionsWidth = 0.000
        speedMeterView.scaleSubdivisionsLength = 0.00
        speedMeterView.scaleDivisionsWidth = 0.000
        speedMeterView.scaleDivisionsLength = 0.00
        

    }
}
