////
////  Helper.swift
////  LanScanner
////
////  Created by gautam  on 08/05/23.
////
//
//
//import Foundation
//class WifiHelper:LANScannerDelegate{
//    var limit:Int
//    var wifiList = [String]()
//    var timerIterationNumber: Int = 0
//    var last:Int? = 0
//    init(limit:Int){
//        self.limit = limit
//       
//    }
//    
//    func startWifiScan(){
//        
//      // DispatchQueue.global(qos: .background).async {
//           
//           let ipAddress = LANScanner.getLocalAddress()?.ip
//           let ipComponents = ipAddress?.components(separatedBy: ".")
//           print("IpAddress \(ipAddress)")
//             
//           if ipComponents?.count == 4 {
//               
//               let subnet = "\(ipComponents![0]).\(ipComponents![1]).\(ipComponents![2])"
//               
//               //Set 10 IPs are assigned to 1 thread
//               let setOfIpsInThread : Int = 10
//               let noOfThreads : Int = 255 / setOfIpsInThread;
//               for i in 0...noOfThreads {
//                   var start = i * setOfIpsInThread
//                   var end = start + setOfIpsInThread
//                   
//                   start = max(start, 1)
//                   end = min(end, 256)
//                   last = end
//                  // DispatchQueue.global(qos: .background).async {
//                       let scanner = LANScanner(ipAddress: ipAddress!, subnet: subnet, start: start, end: end, delegate: self,continuous: false)
//                       scanner.startScan()
//                print("end11 \(end)")
//                  
//                  // }
//               }
//           }
//        print("lst \(last)")
//       
//      //  }
//       
//
//    }
//    
//    func LANScannerFinished() {
//        print("finished \(wifiList.count)")
//        MainListHelper.instanceHelper.showList(list: wifiList)
//    }
//    
//    func LANScannerRestarted() {
//        
//    }
//    
//     func LANScannerDiscovery(_ object: AnyObject) {
//         print("timerIterationNumber\(timerIterationNumber)")
//
//        self.timerIterationNumber += 1
//        if(timerIterationNumber <= 255){
//            print("timerIterationNumber1 \(timerIterationNumber)")
//        
//            let success = object["status"] as! Bool
//            if success {
//                /// Send device to delegate
//                let device = LANDevice()
//                device.ipAddress = object["address"] as! String
//                print("device.ipAddress \(device.ipAddress)")
//                if let hostName = LANScanner.getHostName(device.ipAddress) {
//                    device.hostName = hostName
//                }
//                
//                wifiList.append(device.ipAddress)
//                if last == 256{
//                 
//                        MainListHelper.instanceHelper.showList(list: wifiList)
//                  
//                }
//                // timer?.invalidate()
//            }
//            
//        }else{
//            print("isFinished")
//            LANScannerFinished()
//        }
//
//        
//    }
//    
//    func LANScannerFailed(_ error: NSError) {
//       
//    }
//    
//}
