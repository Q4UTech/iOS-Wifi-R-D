//
//  EngineOpenAdsListener.swift
//  Q4U-BG REMOVER
//
//  Created by Deepti Chawla on 18/02/21.
//  Copyright © 2021 Deepti Chawla. All rights reserved.
//

import Foundation
import UIKit
protocol EngineOpenAdsListenerProtocol: class {
    func onOpenAdsLoad()
    func onOpenAdsFailed(provider:AdsEnum,error: String,viewController:UIViewController)
    func onOpenAdClosed(_ viewController:UIViewController)
}

class EngineOpenAdsListener: NSObject{
    var openAdsdelegates: EngineOpenAdsListenerProtocol?
    
    class var adsInstanceHelper: EngineOpenAdsListener {
        struct Static {
            static let instance = EngineOpenAdsListener()
        }
        return Static.instance
    }
    
    func openAdsLoaded(){
        openAdsdelegates?.onOpenAdsLoad()
    }
    
    func OpenAdsFailed(_ adsenum:AdsEnum,_ error:String,_ viewController:UIViewController) {
        openAdsdelegates?.onOpenAdsFailed(provider: adsenum, error: error, viewController: viewController)
    }
    
    func OpenAdsClosed(_ viewController:UIViewController) {
        openAdsdelegates?.onOpenAdClosed(viewController)
    }
    
}

