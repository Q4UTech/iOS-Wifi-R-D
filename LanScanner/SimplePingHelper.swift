//
//  SimplePingHelper.swift
//  Pods
//
//  Created by Chris Anderson on 2/14/16.
//
//

import UIKit




import UIKit



class SimplePingHelper: NSObject, SimplePingDelegate {
    
    var address:String
    var simplePing:SimplePing?
    var target:AnyObject
    var selector:Selector
    
//    static func start(_ address:String, target:AnyObject, selector:Selector) {
//
//        SimplePingHelper(address: address, target: target, selector: selector).start()
//    }
    
    init(address: String, target:AnyObject, selector:Selector) {
        
        self.simplePing = SimplePing(hostName:address)
       // self.simplePing = SimplePing(hostAddress: address.data(using: .utf8))
        self.target = target
        self.selector = selector
        self.address = address
        
        super.init()
        
        self.simplePing!.delegate = self
        
        start()
    }
    
    func start() {
        print("simplePing start")

        self.simplePing?.start()
        self.perform(#selector(endTime), with: nil, afterDelay: 2)
        
    }
    
    
    // MARK: - Helper Methods
    func killPing() {
        self.simplePing?.stop()
        self.simplePing = nil
    }
    
    func successPing() {
       print("successPing")
        self.killPing()
        let _ = self.target.perform(self.selector, with: [
            "status": true,
            "address": self.address
            ])
    }
    
    func failPing(_ reason: String) {
        print("failPing \(reason)")
        self.killPing()
        let _ = self.target.perform(self.selector, with: [
            "status": false,
            "address": self.address,
            "error": reason
            ])
    }
    
    @objc func endTime() {
        print("endTime")
        if let _ = self.simplePing {
            self.failPing("timeout")
            return
        }
    }
    
    
    // MARK: - SimplePing Delegate
    func simplePing(_ pinger: SimplePing!, didStartWithAddress address: Data!) {
        self.simplePing?.send(with: nil)
    }
    
    func simplePing(_ pinger: SimplePing!, didFailWithError error: Error!) {
        self.failPing("didFailWithError")
    }
    
    func simplePing(_ pinger: SimplePing!, didFailToSendPacket packet: Data!, error: Error!) {
        self.failPing("didFailToSendPacked")
    }
    
    func simplePing(_ pinger: SimplePing!, didReceivePingResponsePacket packet: Data!) {
        self.successPing()
    }
    
}
