//
//  AdsGlobal.swift
//  CustomGallery
//
//  Created by Deepti Chawla on 11/06/20.
//  Copyright © 2020 Pavle Pesic. All rights reserved.
//

import Foundation

import UIKit
import SystemConfiguration
import AdSupport
let reachability = Reachability()

class ApiLink {
    

    static let HOST_URL = "https://quantum4you.com/engine/"
       static let IMAGE_BASE_URL = "https://quantum4you.com/engine/"
       static let INTERNET_ERROR_MESSAGE = "Oops! It seems you are not connected with internet. Please check your internet connection."
 
}

@objc class Reachability: NSObject {
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags)
        {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
   }
}



class IDFA {
    // MARK: - Stored Type Properties
    static let shared = IDFA()

    // MARK: - Computed Instance Properties
    /// Returns `true` if the user has turned off advertisement tracking, else `false`.
    var limited: Bool {
        return !ASIdentifierManager.shared().isAdvertisingTrackingEnabled
    }

    /// Returns the identifier if the user has turned advertisement tracking on, else `nil`.
    var identifier: String? {
        guard !limited else { return nil }
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
}



public enum AdsEnum {
     case ADS_ADMOB
     case ADS_FACEBOOK
     case ADS_INHOUSE
    case ADS_IRON_SOURCE
     case ADS_APP_LOVIN
     case FULL_ADS_ADMOB
    case FULL_ADS_IRONSOURCE
    case FULL_ADS_APPLOVIN
     case FULL_ADS_FACEBOOK
     case FULL_ADS_INHOUSE
     case OPEN_ADS_ADMOB
 }


