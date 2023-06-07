//
//  LANScanner.swift
//  Pods
//
//  Created by Chris Anderson on 2/14/16.
//
//

import UIKit

#if os(OSX)
import ifaddrsOSX
#elseif os(iOS)
#if (arch(i386) || arch(x86_64))
import ifaddrsiOSSim

#else
//  import ifaddrsiOS
#endif
#endif

@objc public protocol LANScannerDelegate
{
    /**
     Triggered when the scanning has discovered a new device
     */
    @objc optional func LANScannerDiscovery(_ object: AnyObject)
    
    /**
     Triggered when all of the scanning has finished
     */
    @objc optional func LANScannerFinished()
    
    /**
     Triggered when the scanner starts over
     */
    @objc optional func LANScannerRestarted()
    
    /**
     Triggered when there is an error while scanning
     */
    @objc optional func LANScannerFailed(_ error: NSError)
}

open class LANScanner: NSObject {
    
    public struct NetInfo {
        public let ip: String
        public let netmask: String
    }
    
    
    open var delegate: LANScannerDelegate?
    
    var localAddress: String?
    static var baseAddress: String?
    var currentHostAddress: Int = 0
    var timer: Timer?
//    var netMask: String?
    var baseAddressEnd: Int = 0
    var timerIterationNumber: Int = 0
    var limit = 0
    var count = 0
    var startTime = 0
    var endTime = 0
    var continuous:Bool = true
//    var setOfIpsInThread: Int = 20
//     var noOfThreads: Int = 0
   
//    let startSignal = DispatchSemaphore(value: 0)
//    let doneSignal = DispatchGroup()
//
   

    public override init() {
        
        super.init()
    }
    
    public init(ipAddress: String, subnet: String, start: Int,end: Int,delegate: LANScannerDelegate, continuous: Bool) {
        
        super.init()
        self.localAddress = ipAddress
        LANScanner.baseAddress = subnet
        self.startTime = start
        self.endTime = end
        self.delegate = delegate
        self.continuous = continuous

    }
    
    // MARK: - Actions
    open func startScan() {
        pingWifiAddress()
        
    //  wifiData.noOfThreads =  limit / wifiData.setOfIpsInThread
            
//              if let localAddress = LANScanner.getLocalAddress() {
//                self.localAddress = localAddress.ip
//                let ipComponents = addressParts(self.localAddress!)
//
//                if  ipComponents.count == 4 {
//
//                    LANScanner.baseAddress = "\(ipComponents[0]).\(ipComponents[1]).\(ipComponents[2])."
//
//                    self.currentHostAddress = 0
//                    self.timerIterationNumber = 0
//                    self.baseAddressEnd = 255
//
//                    for i in 0...wifiData.noOfThreads {
                      
                        
//                       wifiData.start = i * wifiData.setOfIpsInThread
//
//                        print("starttime\(wifiData.start) \(wifiData.setOfIpsInThread)")
//                       wifiData.end = wifiData.start + wifiData.setOfIpsInThread
                       // print("starttimeEnd \( wifiData.end)")
                        
                    //}
   
//                }else{
//                    onWiFiScannError("LANScanner", 102, "Local IP Address is not correct")
//                }
//            }
//            else {
//                onWiFiScannError("LANScanner", 101, "Unable to find a local address")
//            }
    }
    
    private func onWiFiScannError(_ domain:String,_ code : Int,_ message : String){
        self.delegate?.LANScannerFailed?(NSError(
            domain: domain,
            code: code,
            userInfo: [ "error": message ]
        )
        )
    }
    
    open func stopScan() {
        
        self.timer?.invalidate()
    }
   
    
    // MARK: - Network methods
    public static func getHostName(_ ipaddress: String) -> String? {
        
        var hostName:String? = nil
        var ifinfo: UnsafeMutablePointer<addrinfo>?
        
        /// Get info of the passed IP address
        if getaddrinfo(ipaddress, nil, nil, &ifinfo) == 0 {
            
            var ptr = ifinfo
            while ptr != nil {
                
                let interface = ptr!.pointee
                
                /// Parse the hostname for addresses
                var hst = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                if getnameinfo(interface.ai_addr, socklen_t(interface.ai_addrlen), &hst, socklen_t(hst.count),
                               nil, socklen_t(0), 0) == 0 {
                    
                    if let address = String(validatingUTF8: hst) {
                        hostName = address
                    }
                }
                ptr = interface.ai_next
            }
            freeaddrinfo(ifinfo)
        }
        
        return hostName
    }
    
    public static func getLocalAddress() -> NetInfo? {
        var localAddress:NetInfo?
        
        /// Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            
            /// For each interface ...
            var ptr = ifaddr
            while ptr != nil {
                
                let interface = ptr!.pointee
                let flags = Int32(interface.ifa_flags)
                var addr = interface.ifa_addr.pointee
                print("flags\(flags)\(addr)")
                /// Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        /// Narrow it down to just the wifi card
                        let name = String(cString:interface.ifa_name)
                        if name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3"{
                            
                            /// Convert interface address to a human readable string
                            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                           
                            if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                            nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                                if let address = String(validatingUTF8: hostname) {
                                    var net = interface.ifa_netmask.pointee
                                    var netmaskName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                                    print("addressss1\(address)")
                                    if getnameinfo(&net, socklen_t(net.sa_len), &netmaskName, socklen_t(netmaskName.count),
                                                   nil, socklen_t(0), NI_NUMERICHOST) == 0 {
                                        if let netmask = String(validatingUTF8: netmaskName) {
                                            let allAddress = NetInfo(ip: address, netmask: netmask)
                                            print("localAddress1\(allAddress.netmask)")
                                            if allAddress.netmask == "255.255.255.0" {
                                               localAddress = NetInfo(ip: address, netmask: netmask)
                                            }
                                           
                                           
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                ptr = interface.ifa_next
                
                
            }
            
            freeifaddrs(ifaddr)
            
        }
        return localAddress
    }
    
    func addressParts(_ address: String) -> [String] {
        return address.components(separatedBy: ".")
    }
    
    // MARK: - Ping helpers
    @objc func pingAddress() {
            self.currentHostAddress += 1
        let address:String = "\(LANScanner.baseAddress!)\(self.currentHostAddress)"
        print("running  \(LANScanner.baseAddress!)\(self.currentHostAddress)")
        SimplePingHelper(address: address, target: self, selector: #selector(LANScanner.pingResult(_:)))
            if self.currentHostAddress >= self.limit && !continuous {
                self.timer?.invalidate()
            }
      
    }
    
    func pingWifiAddress(){
        print("IpAddress \(LANScanner.baseAddress)")
        
       // DispatchQueue.global(qos: .background).async {[self] in
      
      //      self.currentHostAddress = 0
        
        if startTime <= endTime {
            //self.currentHostAddress += 1
            
            for currentHostAddress in startTime...endTime {
             
                print("currentHostAddress \(currentHostAddress) \(startTime) \(endTime)")
                let address: String = "\(LANScanner.baseAddress!).\(currentHostAddress)"
                print("addressss helllo \(address)")
                SimplePingHelper(address:address, target: self, selector: #selector(LANScanner.pingResult(_:)))
            
            }
        } else {
            // handle the case where start is greater than end
        }

           
     //   }
       
        //doneSignal.enter()
//        DispatchQueue.global(qos: .background).async {[self] in
//
//            self.currentHostAddress += 1
//            //        for i in 1...lastAddress{
//            //            if i <= lastAddress{
//
//            //    self.currentHostAddress = self.currentHostAddress
//
//            let address:String = "\(self.baseAddress!)\(self.currentHostAddress)"
//            print("running11  \(self.baseAddress!)\(self.currentHostAddress)")
//
//            SimplePingHelper.start(address, target: self, selector: #selector(LANScanner.pingResult(_:)))
            //doneSignal.leave()
      //  }
//                if i >= self.limit &&  !continuous {
//                    count = 0
//                    return
//                }
                
            //}
       // }
        
       print("Task Done")
    }
    
    
    @objc func pingResult(_ object:AnyObject) {
       print("running result")
     //   DispatchQueue.global(qos: .background).async { [self] in
//            self.timerIterationNumber += 1
            let success = object["status"] as! Bool
            if success {
                /// Send device to delegate
                let device = LANDevice()
                device.ipAddress = object["address"] as! String
                print("device.ipAddress \(device.ipAddress)")
                if let hostName = LANScanner.getHostName(device.ipAddress) {
                    device.hostName = hostName
                }
                
                self.delegate?.LANScannerDiscovery?(object)
                // timer?.invalidate()
            }
            
//            /// When you reach the end, either restart or call it quits
//            if self.timerIterationNumber >= 255 {
//
//                if continuous {
//                    self.timerIterationNumber = 0
//                    self.currentHostAddress = 0
//                    self.delegate?.LANScannerRestarted?()
//                }
//                else {
//                    self.delegate?.LANScannerFinished?()
//                }
//            }
       // }
            
       
    }
    
    
    
}

