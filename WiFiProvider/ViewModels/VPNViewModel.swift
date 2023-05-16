////
////  HomeViewModel.swift
////  Q4U_VPNAPP
////
////  Created by Deepti Chawla on 15/04/21.
////
//
import Foundation
import UIKit
//import SwiftyGif
import Alamofire
//import FirebaseAnalytics
//
class VPNViewModel {
    func runningAnimation(_ animationImageView:UIImageView,name:String,durationinSec:TimeInterval){
        animationImageView.setGIFImage(name: name,durationinSec:durationinSec)
        animationImageView.startAnimating()
        
    }
    @available(iOS 13.0, *)
    func disconnectVPNAlert(target:VpnVC){
        let alert = UIAlertController(title: MyConstant.constants.kAlert, message: MyConstant.constants.kWantDisConnect, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: MyConstant.constants.kCancel, style: UIAlertAction.Style.default, handler: { _ in
            target.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: MyConstant.constants.kDisConnect,
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        DispatchQueue.main.async {
                                           // target.connectButton.isUserInteractionEnabled = false
                                          // VPNConnection.shared.stopVPN()
                                            
                                          
                                        }
                                      }))
        target.present(alert, animated: true, completion: nil)
    }
    func setConnectionStatus(status:Bool){
       
        ConnectingState.instanceHelper.checkConnectionState(status: status)
    }

}
