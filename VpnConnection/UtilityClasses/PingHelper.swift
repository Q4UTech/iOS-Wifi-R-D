////
////  PingHelper.swift
////  WiFiProvider
////
////  Created by gautam  on 28/04/23.
////
//
//import Foundation
//
//
//class PingHelper: NSObject {
//    
//    var ping: SimplePing?
//    
//    func pingAddress(address: String) {
//        ping = SimplePing(hostName: address)
//        ping?.delegate = self
//        ping?.start()
//    }
//}
//
//extension PingHelper: SimplePingDelegate {
//    
//    func simplePing(_ pinger: SimplePing, didStartWithAddress address: Data) {
//        print("Started pinging: \(pinger.hostName ?? "")")
//    }
//    
//    func simplePing(_ pinger: SimplePing, didFailWithError error: Error) {
//        print("Failed to ping: \(pinger.hostName ?? "")")
//    }
//    
//    func simplePing(_ pinger: SimplePing, didSendPacket packet: Data, sequenceNumber: UInt16) {
//        print("Packet sent to \(pinger.hostName ?? "")")
//    }
//    
//    func simplePing(_ pinger: SimplePing, didReceivePingResponsePacket packet: Data, sequenceNumber: UInt16) {
//        print("Received response from \(pinger.hostName ?? "")")
//    }
//    
//    func simplePing(_ pinger: SimplePing, didReceiveUnexpectedPacket packet: Data) {
//        print("Received unexpected packet from \(pinger.hostName ?? "")")
//    }
//    
//    func simplePing(_ pinger: SimplePing, didFailToSendPacket packet: Data, sequenceNumber: UInt16, error: Error) {
//        print("Failed to send packet to \(pinger.hostName ?? "")")
//    }
//    
//    func simplePing(_ pinger: SimplePing, didReceiveReplyWithSequenceNumber sequenceNumber: UInt16) {
//        print("Received reply from \(pinger.hostName ?? "")")
//    }
//}
