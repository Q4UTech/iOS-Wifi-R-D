//
//  InHouseAds.swift
//  App Engine
//
//  Created by Quantum_MAC_7 on 26/03/20.
//  Copyright © 2020 Pulkit Babbar. All rights reserved.
//

import Foundation
import UIKit

import CommonCrypto
import CryptoSwift
import SDWebImage
import WebKit
var customView = UIView()

class InHouseAds : NSObject{
    static let shared = InHouseAds()
    var imhousebannerView = UIView()
    var viewConstraint = NSLayoutConstraint()
    func getInhouseBannerAds(from viewController: UIViewController ,type: String,_ view:UIView,_ heightConstaint:NSLayoutConstraint){
       
        let inhouseUrl = "adservicevfour/inhousbanner?engv=4"
        var params = [String:Any]()
        
        let launchCount =  UserDefaults.standard.string(forKey: LAUNCH_COUNT)
        
        params = ["app_id": APP_ID, "country": countryname.getCountryNameInfo(), "screen": screenHeight.getScreenHeightResolution() ,"launchcount": launchCount!, "version": appVersionInfo.getAppVersionInfo(), "osversion": osVersion.getOSInfo(), "type": type, "os": "2"]
        print("InHousepArams:\(params)")
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        let encodedString = hexadecimal.encrypt(text:jsonString)
        var parametr = [String:String]()
        parametr = ["data":encodedString!]
        
          ServiceHelper.sharedInstanceHelper.createPostRequest(method: .post, showHud: true, params: parametr, apiName: inhouseUrl) { (result, error) in
            
            if result != nil{
//                view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 65)
                heightConstaint.constant = 65
                self.imhousebannerView = view
                self.viewConstraint = heightConstaint
                parseInHouseResponse(result!,viewController: viewController)
                InHouseHelper.inHouseInstanceHelper.inhousedelegate = self
               
            }
          
            
        }
   
    }
    
}

extension InHouseAds : InhouseListenerProtocol,WKNavigationDelegate{
    func onInhouseDownload( inHouse: Inhouse, viewController: UIViewController) {
        if inHouse.campType != "" {

                   if inHouse.campType == "html"{

                       let webV = WKWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
                       webV.load(NSURLRequest(url: NSURL(string: inHouse.html)! as URL) as URLRequest)
                       webV.navigationDelegate = self
                       viewController.view.addSubview(webV)
                      AdsListenerHelper.adsInstanceHelper.adsLoad(adsView: viewController.view, viewcontroller: viewController,viewConstarint)
                      // AdsListenerHelper.adsInstanceHelper.adsLoad(adsView: , viewcontroller:contoller)
                     }
                   else{
                       
                       let imageView = UIImageView()
                       imageView.frame = CGRect(x: 0,y: 0,width: imhousebannerView.frame.width,height: 65)
                             if let imageUrl = NSURL(string: inHouse.src){
                                           print("ImageUrl\(imageUrl)")
                                            imageView.sd_setImage(with: imageUrl as URL, placeholderImage: UIImage.init(named:"image.png" ))
                                            print("Imageview\(imageView)")
                                           
                                           // viewController.view.addSubview(imageView)
//                                            setinhouseBannerToOnScreenPosition(imageView, from: viewController)
                        
                                 viewConstarint.constant = 55
                                imhousebannerView.addSubview(imageView)
                               AdsListenerHelper.adsInstanceHelper.adsLoad(adsView:viewController.view, viewcontroller:viewController,viewConstarint)
                               
                            let tapGesture = MyTapGesture(target: self, action: #selector(imageTapped(gesture:)))

                            // add it to the image view;
                            imageView.addGestureRecognizer(tapGesture)
                            // make sure imageView can be interacted with by user
                               tapGesture.clicktype = inHouse.clicklink
                            imageView.isUserInteractionEnabled = true
                                          }
                   }
             
           }
               else{
            viewConstarint.constant = 0
                   AdsListenerHelper.adsInstanceHelper.adsFailed(viewController.view,AdsEnum.ADS_INHOUSE, "Inhouse campType null or not valid ",viewController,viewConstarint)
               }
    }
   
    
    

    @objc func imageTapped(gesture: MyTapGesture) {
       // if the tapped view is a UIImageView then set it to imageview
       if (gesture.view as? UIImageView) != nil {
           print("Image Tapped")
           print("Gesture:\(gesture.clicktype)")
        // UIApplication.shared.openURL(NSURL(string: gesture.clicktype)! as URL)
        if let url = URL(string: gesture.clicktype),
                                                  UIApplication.shared.canOpenURL(url){
                                                  UIApplication.shared.open(url, options: [:])
                                              }
       }
   }
    
    
    
}




// Banner position
  enum InhouseBannerPosition {
      case bottom
      case top
  }

var inhousebannerPosition = InhouseBannerPosition.bottom


   func setinhouseBannerToOnScreenPosition(_ bannerAd: UIImageView, from viewController: UIViewController?) {
      print("BannerAddhdhhdh\(bannerAd) \(viewController!)")
       guard let viewController = viewController else { return }

       switch inhousebannerPosition {
       case .bottom:
           bannerAd.center = CGPoint(x: viewController.view.frame.midX, y: viewController.view.frame.maxY - (bannerAd.frame.height / 2))
       case .top:
           bannerAd.center = CGPoint(x: viewController.view.frame.midX, y: viewController.view.frame.minY + (bannerAd.frame.height / 2))
       }
   }

  

class MyTapGesture: UITapGestureRecognizer {
    var clicktype = String()
}


class InHouseFullAds:NSObject{
     static let shared = InHouseFullAds()
    func InhouseshowFullAds(viewController:UIViewController, type:String,  src:String,link:String) {
          
            if type != "" {

                //FullPagePromo.onStart(viewController, type, src, link , listener);
                print("FullPagePromoInhouseVC \(src) \(type)")
              let vc = UIStoryboard.init(name: "Engine", bundle: Bundle.main).instantiateViewController(withIdentifier: "FullPagePromoInhouseVC") as? FullPagePromoInhouseVC
                vc?.clicklink = link
                vc?.src = src
                vc?.type = type
                 viewController.navigationController?.pushViewController(vc!, animated: false)
              //  FullAdsListener.adsInstanceHelper.fullAdsLoaded()
            } else {
//                FullAdsListener.adsInstanceHelper.FullAdsFailed(AdsEnum.FULL_ADS_INHOUSE, "type null ", viewController)
                
            }
        }
    
    
    
    func getInhouseFullAds(from viewController: UIViewController ,type: String){
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                
         
        let inhouseUrl = "adservicevfour/inhousbanner?engv=4"
        var params = [String:Any]()
        
        let launchCount =  UserDefaults.standard.string(forKey: LAUNCH_COUNT)
        print("InhouseTypeCheck\(type)")
        params = ["app_id": APP_ID, "country": countryname.getCountryNameInfo(), "screen": screenHeight.getScreenHeightResolution() ,"launchcount": launchCount!, "version": appVersionInfo.getAppVersionInfo(), "osversion": osVersion.getOSInfo(), "type": type, "os": "2"]
        print("InHousepArams:\(params)")
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        let encodedString = hexadecimal.encrypt(text:jsonString)
        var parametr = [String:String]()
        parametr = ["data":encodedString!]
        
          ServiceHelper.sharedInstanceHelper.createPostRequest(method: .post, showHud: true, params: parametr, apiName: inhouseUrl) { (result, error) in
            print("InhouseResultheck]\(result)")
            if result != nil{
               
                parseInHouseResponse(result!,viewController: viewController)
               // InHouseHelper.inHouseInstanceHelper.inhousedelegate = self
            }

        }
        
        
        
    }
    
        }
    }
    
}



class InHouseNativeLargeAds:NSObject{
    var viewConstraint = NSLayoutConstraint()
     static let shared = InHouseNativeLargeAds()
  var nativeView = UIView()
    func getNativeLargeAds(from viewController: UIViewController ,view:UIView,_ heightConstraint:NSLayoutConstraint){
       InHouseHelper.inHouseInstanceHelper.inhousedelegate = self
        nativeView = view
       getInhouseNativeLargeAds(from: viewController, type: IH_NL,heightConstraint)
    }
    
    
    func getInhouseNativeLargeAds(from viewController: UIViewController ,type: String ,_ heightConstraint:NSLayoutConstraint){
        
        let inhouseUrl = "adservicevfour/inhousbanner?engv=4"
        var params = [String:Any]()
        
        let launchCount =  UserDefaults.standard.string(forKey: LAUNCH_COUNT)
        
        params = ["app_id": APP_ID, "country": countryname.getCountryNameInfo(), "screen": screenHeight.getScreenHeightResolution() ,"launchcount": launchCount!, "version": appVersionInfo.getAppVersionInfo(), "osversion": osVersion.getOSInfo(), "type": type, "os": "2"]
        print("InHousepArams:\(params)")
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        let encodedString = hexadecimal.encrypt(text:jsonString)
        var parametr = [String:String]()
        parametr = ["data":encodedString!]
        
          ServiceHelper.sharedInstanceHelper.createPostRequest(method: .post, showHud: true, params: parametr, apiName: inhouseUrl) { (result, error) in
            
            if result != nil{
                self.viewConstraint = heightConstraint
                parseInHouseResponse(result!,viewController: viewController)
                   
            }
          
            
        }
        
        
        
    }
    
    
    
}


extension InHouseNativeLargeAds:InhouseListenerProtocol,WKNavigationDelegate{
  
    func onInhouseDownload(inHouse: Inhouse, viewController: UIViewController) {
        print("InhouseNativensnsnAds\(inHouse.src)")
        
        if inHouse.campType != "" {

                  if inHouse.campType == "html" {
                    if inHouse.html != ""{
                        let webV = WKWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
                        webV.load(NSURLRequest(url: NSURL(string: inHouse.html)! as URL) as URLRequest)
                                             webV.navigationDelegate = self
                                             nativeView.addSubview(webV)
                                            AdsListenerHelper.adsInstanceHelper.adsLoad(adsView: nativeView, viewcontroller: viewController,NSLayoutConstraint())
                    }
                    else{
                        AdsListenerHelper.adsInstanceHelper.adsFailed(nativeView, AdsEnum.ADS_INHOUSE, "INHOUSE HTML NULL", viewController,viewConstarint)

                    }
                     
                     // AdsListenerHelper.adsInstanceHelper.adsLoad(adsView: , viewcontroller:contoller)
                  }
                  else{
                    if inHouse.src != ""{
                        let imageView = UIImageView()
                                                   if let imageUrl = NSURL(string: inHouse.src){
                                                                 print("ImageUrl\(imageUrl)")
                                                                  imageView.sd_setImage(with: imageUrl as URL, placeholderImage: UIImage.init(named:"image.png" ))
                                                                  print("Imageview\(imageView)")
                                                       imageView.frame = CGRect(x: 0,y: 0,width: nativeView.frame.width,height: nativeView.frame.height)
                                                                 nativeView.addSubview(imageView)
                                                    viewConstraint.constant = 55

                                                  let tapGesture = MyTapGesture(target: self, action: #selector(imageTapped(gesture:)))

                                                  // add it to the image view;
                                                  imageView.addGestureRecognizer(tapGesture)
                                                  // make sure imageView can be interacted with by user
                                                     tapGesture.clicktype = inHouse.clicklink
                                                  imageView.isUserInteractionEnabled = true
                                                              }
                        
                        AdsListenerHelper.adsInstanceHelper.adsLoad(adsView: nativeView, viewcontroller: viewController,viewConstarint)
                                           
                    }
                    else{
                         viewConstraint.constant = 0
                        AdsListenerHelper.adsInstanceHelper.adsFailed(nativeView, AdsEnum.ADS_INHOUSE, "INHOUSE SRC NULL", viewController,viewConstarint)
                    }
                     
                
                        
                    }
            
        }
    }
              
    
    
    @objc func imageTapped(gesture: MyTapGesture) {
          // if the tapped view is a UIImageView then set it to imageview
          if (gesture.view as? UIImageView) != nil {
              print("Image Tapped")
              print("Gesture:\(gesture.clicktype)")
          //  UIApplication.shared.openURL(NSURL(string: gesture.clicktype)! as URL)
            if let url = URL(string: gesture.clicktype),
                                                      UIApplication.shared.canOpenURL(url){
                                                      UIApplication.shared.open(url, options: [:])
                                                  }
          }
      }

}





class InHouseNativeMediumAds:NSObject{
     static let shared = InHouseNativeMediumAds()
  var nativeView = UIView()
    var viewConstarint = NSLayoutConstraint()
    func getNativeMediumAds(from viewController: UIViewController ,view:UIView, _ heightConstarint:NSLayoutConstraint){
       InHouseHelper.inHouseInstanceHelper.inhousedelegate = self
       nativeView = view
        viewConstarint = heightConstarint
       getInhouseNativeMediumAds(from: viewController, type: TYPE_NATIVE_MEDIUM)
    }
    
    
    func getInhouseNativeMediumAds(from viewController: UIViewController ,type: String){
        
        let inhouseUrl = "adservicevfour/inhousbanner?engv=4"
        var params = [String:Any]()
        
        let launchCount =  UserDefaults.standard.string(forKey: LAUNCH_COUNT)
        
        params = ["app_id": APP_ID, "country": countryname.getCountryNameInfo(), "screen": screenHeight.getScreenHeightResolution() ,"launchcount": launchCount!, "version": appVersionInfo.getAppVersionInfo(), "osversion": osVersion.getOSInfo(), "type": type, "os": "2"]
        print("InHousepArams:\(params)")
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        let encodedString = hexadecimal.encrypt(text:jsonString)
        var parametr = [String:String]()
        parametr = ["data":encodedString!]
        
          ServiceHelper.sharedInstanceHelper.createPostRequest(method: .post, showHud: true, params: parametr, apiName: inhouseUrl) { (result, error) in
            
            if result != nil{
                parseInHouseResponse(result!,viewController: viewController)
                   
            }
          
            
        }
        
        
        
    }
    
    
    
}


extension InHouseNativeMediumAds:InhouseListenerProtocol,WKNavigationDelegate{
   
    func onInhouseDownload(inHouse: Inhouse, viewController: UIViewController) {
        print("InhouseNativensnsnAds\(inHouse.src)")
        
        if inHouse.campType != "" {

                  if inHouse.campType == "html" {
                    if inHouse.html != ""{
                        let webV  = WKWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
                        webV.load(NSURLRequest(url: NSURL(string: inHouse.html)! as URL) as URLRequest)
                                             webV.navigationDelegate = self
                                             nativeView.addSubview(webV)
                      
                                            AdsListenerHelper.adsInstanceHelper.adsLoad(adsView: nativeView, viewcontroller: viewController,viewConstarint)
                    }
                    else{
                        AdsListenerHelper.adsInstanceHelper.adsFailed(nativeView, AdsEnum.ADS_INHOUSE, "INHOUSE HTML NULL", viewController,viewConstarint)

                    }
                     
                     // AdsListenerHelper.adsInstanceHelper.adsLoad(adsView: , viewcontroller:contoller)
                  }
                  else{
                    if inHouse.src != ""{
                        let imageView = UIImageView()
                                                   if let imageUrl = NSURL(string: inHouse.src){
                                                                 print("ImageUrl\(imageUrl)")
                                                                  imageView.sd_setImage(with: imageUrl as URL, placeholderImage: UIImage.init(named:"image.png"))
                                                                  print("Imageview\(imageView)")
                                                       imageView.frame = CGRect(x: 0,y: 0,width: nativeView.frame.width,height: nativeView.frame.height)
                                                                 nativeView.addSubview(imageView)


                                                  let tapGesture = MyTapGesture(target: self, action: #selector(imageTapped(gesture:)))

                                                  // add it to the image view;
                                                  imageView.addGestureRecognizer(tapGesture)
                                                  // make sure imageView can be interacted with by user
                                                     tapGesture.clicktype = inHouse.clicklink
                                                  imageView.isUserInteractionEnabled = true
                                                              }
                          viewConstarint.constant = 55
                        AdsListenerHelper.adsInstanceHelper.adsLoad(adsView: nativeView, viewcontroller: viewController,viewConstarint)
                                           
                    }
                    else{
                          viewConstarint.constant = 0
                        AdsListenerHelper.adsInstanceHelper.adsFailed(nativeView, AdsEnum.ADS_INHOUSE, "INHOUSE SRC NULL", viewController,viewConstarint)
                    }
                     
                
                        
                    }
            
        }
    }
              
    
    
    @objc func imageTapped(gesture: MyTapGesture) {
          // if the tapped view is a UIImageView then set it to imageview
          if (gesture.view as? UIImageView) != nil {
              print("Image Tapped")
              print("Gesture:\(gesture.clicktype)")
          //  UIApplication.shared.openURL(NSURL(string: gesture.clicktype)! as URL)

            
            if let url = URL(string: gesture.clicktype),
                                                      UIApplication.shared.canOpenURL(url){
                                                      UIApplication.shared.open(url, options: [:])
                                                  }
          }
      }

}






