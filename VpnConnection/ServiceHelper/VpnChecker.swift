//
//  VpnChecker.swift
//  Q4U_VPNAPP
//
//  Created by Poornima on 07/11/22.
//

import Foundation
struct VpnChecker {

    private static let vpnProtocolsKeysIdentifiers = [
        "tap", "tun", "ppp", "ipsec", "utun"
    ]

    static func isVpnActive() -> Bool {
        guard let cfDict = CFNetworkCopySystemProxySettings() else { return false }
        let nsDict = cfDict.takeRetainedValue() as NSDictionary
        guard let keys = nsDict["__SCOPED__"] as? NSDictionary,
            let allKeys = keys.allKeys as? [String] else { return false }

        // Checking for tunneling protocols in the keys
        for key in allKeys {
            for protocolId in vpnProtocolsKeysIdentifiers
                where key.starts(with: protocolId) {
                // I use start(with:), so I can cover also `ipsec4`, `ppp0`, `utun0` etc...
                return true
            }
        }
        return false
    }
}
