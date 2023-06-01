//
//  SpeedTestCompleteListener.swift
//  WiFiProvider
//
//  Created by gautam  on 12/05/23.
//

import Foundation

protocol SpeedCheckProtocol{
    func isSpeedCheckComplete(complete: Bool,ping:String,upload:Double,download:Double)
    func showChartData(show:Bool,data:[Double])
    func uploadFinished(isFinsihed:Bool,data:[Double])
    func downloadFinsihedFinished(isFinsihed:Bool,data:[Double])
}

class SpeedTestCompleteListener:NSObject,SpeedCheckProtocol{
    var speedCheckDelegate : SpeedCheckProtocol?
    
    class var instanceHelper: SpeedTestCompleteListener {
        struct Static {
            static let instance = SpeedTestCompleteListener()
        }
        return Static.instance
    }
    
    func isSpeedCheckComplete(complete: Bool,ping:String,upload:Double,download:Double){
        speedCheckDelegate?.isSpeedCheckComplete(complete: complete, ping: ping,upload:upload,download:download)
    }
    func showChartData(show:Bool,data:[Double]){
        speedCheckDelegate?.showChartData(show:show,data:data)
    }
    
    func uploadFinished(isFinsihed:Bool,data:[Double]){
    speedCheckDelegate?.uploadFinished(isFinsihed: isFinsihed,data:data)
    }
    
    func downloadFinsihedFinished(isFinsihed: Bool,data:[Double]){
        speedCheckDelegate?.downloadFinsihedFinished(isFinsihed: isFinsihed,data:data)
    }
    
    
}
