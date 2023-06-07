//
//  WifiModel.swift
//  LanScanner
//
//  Created by gautam  on 10/05/23.
//

//import Foundation
//class WifiData{
//    let startSignal = DispatchSemaphore(value: 0)
//    let doneSignal = DispatchGroup()
//    var baseAddress: String?
//    var currentHostAddress: Int = 0
//    var timerIterationNumber: Int = 0
////    class var instanceHelper: WifiData {
////        struct Static {
////            static let instance = WifiData()
////        }
////        return Static.instance
////    }
//    
//    init (delegate:LANScannerDelegate){
//        self.delegate = delegate
//    }
//    var start:Int = 0
//    var end :Int = 0
//    var setOfIpsInThread: Int = 20
//    var noOfThreads: Int = 0
//    open var continuous:Bool = true
//    var delegate:LANScannerDelegate
//    func pingWifiAddress() {
//        print("check \(Thread.isMainThread) \(Thread.isMultiThreaded())")
//        if start <= end {
//          
//                
//            for addindex in start...end {
//                         
//                         self.currentHostAddress = addindex
//                         let address: String = "\(LANScanner.baseAddress!).\(currentHostAddress)"
//                         print("addressssValue \(address)")
//                       
//                SimplePingHelper(address: address, target: self, selector: #selector(pingResult(_:)))
//                       
//                     }
//            
//            
//            
//        } else {
//            // handle the case where starttime is greater than endtime
//        }
//
//    }
//}
