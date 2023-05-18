//
//  SpeedTestCompleteListener.swift
//  WiFiProvider
//
//  Created by gautam  on 12/05/23.
//

import Foundation

protocol SpeedCheckProtocol{
    func isSpeedCheckComplete(complete: Bool,upload:Double,download:Double)
    func showChartData(show:Bool,data:[Double])
}

class SpeedTestCompleteListener:NSObject,SpeedCheckProtocol{
    var speedCheckDelegate : SpeedCheckProtocol?
    
    class var instanceHelper: SpeedTestCompleteListener {
        struct Static {
            static let instance = SpeedTestCompleteListener()
        }
        return Static.instance
    }
    
    func isSpeedCheckComplete(complete: Bool,upload:Double,download:Double){
        speedCheckDelegate?.isSpeedCheckComplete(complete: complete,upload:upload,download:download)
    }
    func showChartData(show:Bool,data:[Double]){
        speedCheckDelegate?.showChartData(show:show,data:data)
    }
    
    
}
