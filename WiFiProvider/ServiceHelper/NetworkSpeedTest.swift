//
//  NetworkSpeedTest.swift
//  Q4U_VPNAPP
//
//  Created by Deepti Chawla on 13/04/21.
//  Copyright © 2021 Anchorfree Inc. All rights reserved.
//

import Foundation
import Alamofire
class NetworkSpeedTest : NSObject {
    
    static var shared: NetworkSpeedTest = {
        return NetworkSpeedTest()
    }()
    var uploadTimer : Timer?
    
    typealias speedTestCompletionHandler = (_ megabytesPerSecond: Double?,_ status:Bool , _ error: Error?) -> Void
    var speedTestCompletionBlock : speedTestCompletionHandler?
    var startTime: CFAbsoluteTime!
    var stopTime: CFAbsoluteTime!
    var bytesReceived: Int!
    var uploadTask: URLSessionUploadTask!
    func testDownloadSpeedWithTimout(timeout: TimeInterval, withCompletionBlock: @escaping speedTestCompletionHandler) {
        
        guard let url = URL(string: MyConstant.constants.kImageURL) else { return }
        startTime = CFAbsoluteTimeGetCurrent()
        stopTime = startTime
        bytesReceived = 0
        speedTestCompletionBlock = withCompletionBlock
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForResource = timeout
        let session = URLSession.init(configuration: configuration, delegate: self, delegateQueue: nil)
        session.dataTask(with: url).resume()

    }
}

extension NetworkSpeedTest : URLSessionDelegate,URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
      //  let elapsed = stopTime - startTime
        bytesReceived! += data.count
        let  speed = Double(bytesReceived) / 1024.0 / 1024.0
        speedTestCompletionBlock?(speed,false,nil)
        stopTime = CFAbsoluteTimeGetCurrent()
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        let elapsed = stopTime - startTime
        
        if let aTempError = error as NSError?, aTempError.domain != NSURLErrorDomain && aTempError.code != NSURLErrorTimedOut && elapsed == 0  {
            speedTestCompletionBlock?(nil,false,error)
            return
        }
        let  speed = Double(bytesReceived) / 1024.0 / 1024.0
        speedTestCompletionBlock?(speed,true,error)
   
    }

}


class UploadNetworkSpeedTest : NSObject{
    
    static var shared: UploadNetworkSpeedTest = {
        return UploadNetworkSpeedTest()
    }()
    var uploadTimer : Timer?
    
    typealias speedTestCompletionHandler = (_ megabytesPerSecond: Double?,_ status:Bool, _ error: Error?) -> Void
    var speedTestCompletionBlock : speedTestCompletionHandler?
    var startTime: CFAbsoluteTime!
    var stopTime: CFAbsoluteTime!
    var bytesReceived: Int!
    var uploadTask: URLSessionUploadTask!
    

    func testUploadSpeedWithTimout(timeout: TimeInterval, withCompletionBlock: @escaping speedTestCompletionHandler) -> Void {

        guard let url = URL(string: MyConstant.constants.kImageURL) else { return }
        startTime = CFAbsoluteTimeGetCurrent()
        stopTime = startTime
        bytesReceived = 0
        speedTestCompletionBlock = withCompletionBlock
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForResource = timeout
        let session = URLSession.init(configuration: configuration, delegate: self, delegateQueue: nil)
        session.dataTask(with: url).resume()
    }
}

extension UploadNetworkSpeedTest : URLSessionDelegate,URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
       // let elapsed = stopTime - startTime
        bytesReceived! += data.count
        let  speed = Double(bytesReceived) / 1024.0 / 1024.0
        speedTestCompletionBlock?(speed,false ,nil)
        stopTime = CFAbsoluteTimeGetCurrent()
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        let elapsed = stopTime - startTime
        
        if let aTempError = error as NSError?, aTempError.domain != NSURLErrorDomain && aTempError.code != NSURLErrorTimedOut && elapsed == 0  {
            speedTestCompletionBlock?(nil,false, error)
            return
        }
        let  speed = Double(bytesReceived) / 1024.0 / 1024.0
        speedTestCompletionBlock?(speed,true ,nil)
    }
    
    
    
}
    
    








