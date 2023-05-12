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

class SpeedTestViewModel{
    func downloadSpeedTest(target: UIViewController, completion:@escaping (_ speed: Double,_ uploadSpeed:Double,_ status:Bool) -> Void) {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                
            
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
//                target.view.makeToast(MyConstant.constants.kCheckInternet, point: CGPoint(x:target.view.center.x, y: target.view.frame.maxY - 70), title: "", image: nil, completion: nil)
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
    
    func downloadSpeed(downloadSpeed:Double ,speedLabel:UILabel,speedMeterView:WMGaugeView,status:Bool){
        DispatchQueue.main.async {
            if status {
                speedMeterView.value = 0
            }else{
                speedMeterView.setValue(Float(downloadSpeed), animated: true, duration: 0.1) { finished in
                                }
              //  speedMeterView.progress = CGFloat(Float(downloadSpeed))
                speedLabel.text = String(format:  MyConstant.constants.kFormat, downloadSpeed)
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
