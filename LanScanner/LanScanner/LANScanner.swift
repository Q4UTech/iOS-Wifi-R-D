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
    @objc optional func LANScannerDiscovery(_ device: LANDevice)
    
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
    open var continuous:Bool = true
    
    
    var localAddress: String?
    var baseAddress: String?
    var currentHostAddress: Int = 0
    var timer: Timer?
//    var netMask: String?
    var baseAddressEnd: Int = 0
    var timerIterationNumber: Int = 0
    var limit = 0
    var count = 0
    var starttime = 0
    var endtime = 0
    var setOfIpsInThread: Int = 20
     var noOfThreads: Int = 0
   
    let startSignal = DispatchSemaphore(value: 0)
    let doneSignal = DispatchGroup()
    let wifiData = WifiData()
   

    public override init() {
        
        super.init()
    }
    
    public init(delegate: LANScannerDelegate, continuous: Bool) {
        
        super.init()
        
        self.delegate = delegate
        self.continuous = continuous
    }
    
    // MARK: - Actions
    open func startScan(limit:Int) {
        self.limit = limit
      noOfThreads =  limit / setOfIpsInThread
            
              if let localAddress = LANScanner.getLocalAddress() {
                self.localAddress = localAddress.ip
//                self.netMask = localAddress.netmask
//                let netMaskComponents = addressParts(self.netMask!)
                let ipComponents = addressParts(self.localAddress!)
                  
                if  ipComponents.count == 4 {
                
                    self.baseAddress = "\(ipComponents[0]).\(ipComponents[1]).\(ipComponents[2])."
                   
                    self.currentHostAddress = 0
                    self.timerIterationNumber = 0
                    self.baseAddressEnd = 255
                   
                    for i in 0...noOfThreads {
                      
                        
                        WifiData.instanceHelper.start = i * WifiData.instanceHelper.setOfIpsInThread
                       // var temp = wifiData.start
                        print("starttime\(WifiData.instanceHelper.start) \(WifiData.instanceHelper.setOfIpsInThread)")
                        WifiData.instanceHelper.end = WifiData.instanceHelper.start + WifiData.instanceHelper.setOfIpsInThread
                        print("starttimeEnd \( WifiData.instanceHelper.end)")
                        WifiData.instanceHelper.start = max(WifiData.instanceHelper.start, 0)
                        WifiData.instanceHelper.end = min(WifiData.instanceHelper.end, limit)
                        doneSignal.enter()
                        pingWifiAddress()
                        
//                        starttime = i * setOfIpsInThread
//                        print("starttime\(starttime)")
//                        endtime = starttime + setOfIpsInThread
//                        print("starttimeEnd \(endtime)")
//                        starttime = max(starttime, 0)
//                        endtime = min(endtime, limit)
//                        doneSignal.enter()
//                        pingWifiAddress()
                        
                        
                        
                    }
   
                }else{
                    onWiFiScannError("LANScanner", 102, "Local IP Address is not correct")
                }
            }
            else {
                onWiFiScannError("LANScanner", 101, "Unable to find a local address")
            }
        
        
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
    
    @objc func pingResult(_ result: [String: Any]) {
        print("running result")
        DispatchQueue.global(qos: .background).async { [self] in
            
            self.timerIterationNumber += 1
            let success = result["status"] as! Bool
            if success {
                let device = LANDevice()
                device.ipAddress = result["address"] as! String
                print("device.ipAddress \(device.ipAddress)")
                if let hostName = LANScanner.getHostName(device.ipAddress) {
                    device.hostName = hostName
                }
                
                self.delegate?.LANScannerDiscovery?(device)
            }
            
            if self.timerIterationNumber >= limit {
                if continuous {
                    self.timerIterationNumber = 0
                    self.currentHostAddress = 0
                    self.delegate?.LANScannerRestarted?()
                } else {
                    self.delegate?.LANScannerFinished?()
                }
            }
        }
    }



    func pingWifiAddress() {
      
        if WifiData.instanceHelper.start <= WifiData.instanceHelper.end {
          
//            let queue = DispatchQueue(label: "com.appcoda.myqueue")
//
//            queue.async { [self] in
                    
                
            for addindex in WifiData.instanceHelper.start...WifiData.instanceHelper.end {
                         
                         self.currentHostAddress = addindex
                         let address: String = "\(self.baseAddress!)\(currentHostAddress)"
                         print("addressssValue \(address)")
                       
                             SimplePingHelper.start(address, target: self, selector: #selector(LANScanner.pingResult(_:)))
                       
                     }
              //  }
                
           // }
            
            
        } else {
            // handle the case where starttime is greater than endtime
        }
       
        doneSignal.leave()
        doneSignal.notify(queue: .main) {
            print("All tasks finished")
        }
        
//        doneSignal.notify(queue: DispatchQueue.global(qos: .background), execute: { [self] in
//            print("thread is Stop")
//
//
//        })
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
}
