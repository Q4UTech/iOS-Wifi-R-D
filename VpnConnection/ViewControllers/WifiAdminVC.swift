//
//  WifiAdminVC.swift
//  WiFiProvider
//
//  Created by gautam  on 15/05/23.
//

import UIKit
import WebKit

class WifiAdminVC: UIViewController, WKUIDelegate {
    var wkWebview: WKWebView!
    @IBOutlet weak var customWebView:UIView!
    @IBOutlet weak var premiumView:UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       if hasPurchased(){
            hideUnhidePremiumView(hide: true)
            wkWebview = WKWebView(frame: customWebView.bounds, configuration: WKWebViewConfiguration())
            wkWebview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.customWebView.addSubview(wkWebview)
            var router_url = "http://"+UserDefaults.standard.string(forKey: MyConstant.ROUTER_IP)!
            let url = URL(string: router_url)
            wkWebview.load(URLRequest(url: url!))
        }else{
            hideUnhidePremiumView(hide:false)
        }

    }
    
    @IBAction func openRouterSetting(_ sender:UIButton){
        let vc = storyboard?.instantiateViewController(withIdentifier: "RouterVC") as! RouterVC
        navigationController?.pushViewController(vc, animated: true)
        showFullAds(viewController: self, isForce: false)
        
    }
    @IBAction func closePage(_ sender:UIButton){
        
        navigationController?.popViewController(animated: true)
        
    }
    
    private func hideUnhidePremiumView(hide:Bool){
        premiumView.isHidden = hide
    }
    
    @IBAction func purchasePaln(_ sender:UIButton){
       
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PurchaseVC") as! PurchaseVC
        navigationController?.pushViewController(vc, animated: true)
        showFullAds(viewController: self, isForce: false)
        
    }
    
    @IBAction func cancelPremiumPlan(_ sender:UIButton){
       
        navigationController?.popViewController(animated: true)
        
    }
   
    
    

   

}
