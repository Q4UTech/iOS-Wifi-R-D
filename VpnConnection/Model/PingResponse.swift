//
//  PingResponse.swift
//  VpnConnection
//
//  Created by gautam  on 05/06/23.
//

import Foundation

class PingResponse : NSObject {

    public var identifier: UInt32 = 0

    public var ipAddress: String?

    public var sequenceNumber: Int64 = 0

    public var duration: TimeInterval = 0.0

    public var error: NSError?
}
