//
//  ViewController.swift
//  WiFiProvider
//
//  Created by gautam  on 27/04/23.
//

import UIKit
import Lottie
import NetworkExtension
import Foundation

import Network



class SplashVC: UIViewController  {
    @IBOutlet weak var animationView:UIView!
    @IBOutlet weak var adsView:UIView!
    @IBOutlet weak var heightConstraint:NSLayoutConstraint!
    var splashAnimationView:LottieAnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       // getConnectedWifiList()
       // playAnimation()
       
          
       
//        let strIPAddress : String = self.getIPAddress()
//        print("IPAddress :: \(strIPAddress)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){ [self] in
            let vc = storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
    
//   func getIPAddress() -> String {
//    var address: String?
//    var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
//    if getifaddrs(&ifaddr) == 0 {
//        var ptr = ifaddr
//        while ptr != nil {
//            defer { ptr = ptr?.pointee.ifa_next }
//
//            guard let interface = ptr?.pointee else { return "" }
//            let addrFamily = interface.ifa_addr.pointee.sa_family
//            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
//
//                // wifi = ["en0"]
//                // wired = ["en2", "en3", "en4"]
//                // cellular = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]
//
//                let name: String = String(cString: (interface.ifa_name))
//                if  name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
//                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
//                    getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
//                    address = String(cString: hostname)
//                }
//            }
//        }
//        freeifaddrs(ifaddr)
//    }
//    return address ?? ""
//}
//
//    func getConnectedWifiList() {
//        PlainPing.ping("www.google.com", withTimeout: 1.0, completionBlock: { (timeElapsed:Double?, error:Error?) in
//            if let latency = timeElapsed {
////                self.pingResultLabel.text = "latency (ms): \(latency)"
//                print("latency (ms): \(latency)")
//            }
//
//
//            if let error = error {
//                print("error: \(error.localizedDescription)")
//            }
//        })
////
////           let task = Process()
////            task.launchPath = "/sbin/ping"
////            task.arguments = ["-c", "1", ipAddress]
////            let pipe = Pipe()
////            task.standardOutput = pipe
////            task.launch()
////            task.waitUntilExit()
////            let data = pipe.fileHandleForReading.readDataToEndOfFile()
////            let output = String(data: data, encoding: .utf8)
////            print(output ?? "No output")
//
//    }
//
    private func playAnimation(){
        splashAnimationView=LottieAnimationView(name: "splash")
        splashAnimationView.contentMode = .scaleAspectFit
        splashAnimationView.center=animationView.center
        splashAnimationView.frame = animationView.bounds
        splashAnimationView.loopMode = .playOnce
        splashAnimationView.animationSpeed = 1
        splashAnimationView.play()
        animationView?.addSubview(splashAnimationView)


    }
    
}

