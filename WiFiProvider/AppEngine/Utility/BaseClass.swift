//
//  BaseClass.swift
//  WiFiProvider
//
//  Created by gautam  on 30/05/23.
//



import Foundation
import UIKit

class BaseClass {
   
   
    func privacyPolicy(){
        if let url = URL(string: ABOUTDETAIL_PRIVACYPOLICY),
           UIApplication.shared.canOpenURL(url){
           UIApplication.shared.open(url, options: [:])
        }
    }
    
    
    func termsCondition(){
        if let url = URL(string : ABOUTDETAIL_TERM_AND_COND),
        UIApplication.shared.canOpenURL(url){
        UIApplication.shared.open(url, options: [:])
      }
    }

    
    func bannerAds(target:UIViewController,adsView:UIView,adsHeightConstraint:NSLayoutConstraint){
        getBannerAd(target,adsView,adsHeightConstraint)
    }
    
    

    
    func showFullAd(target: UIViewController, isForce: Bool){
        showFullAds(viewController: target, isForce: false)
    }
       
   

    
  
    
}

extension Bundle {
    static func swizzleLocalization() {
        let orginalSelector = #selector(localizedString(forKey:value:table:))
        guard let orginalMethod = class_getInstanceMethod(self, orginalSelector) else { return }

        DispatchQueue.main.async {

            let mySelector = #selector(myLocaLizedString(forKey:value:table:))
            guard let myMethod = class_getInstanceMethod(self, mySelector) else { return }
            if class_addMethod(self, orginalSelector, method_getImplementation(myMethod), method_getTypeEncoding(myMethod)) {
                class_replaceMethod(self, mySelector, method_getImplementation(orginalMethod), method_getTypeEncoding(orginalMethod))
            } else {
                method_exchangeImplementations(orginalMethod, myMethod)
            }
        }
    }

    @objc private func myLocaLizedString(forKey key: String,value: String?, table: String?) -> String {
        guard let bundlePath = Bundle.main.path(forResource: UserDefaults.standard.string(forKey: "AppleLanguage"), ofType: "lproj"),
              let bundle = Bundle(path: bundlePath)
        else {
            return Bundle.main.myLocaLizedString(forKey: key, value: value, table: table)
        }
        return bundle.myLocaLizedString(forKey: key, value: value, table: table)
    }
}

