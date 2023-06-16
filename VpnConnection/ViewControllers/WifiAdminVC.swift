//
//  WifiAdminVC.swift
//  WiFiProvider
//
//  Created by gautam  on 15/05/23.
//

import UIKit
import WebKit
import KRProgressHUD

class WifiAdminVC: UIViewController,WKNavigationDelegate, UIScrollViewDelegate{
    var wkWebview: WKWebView!
    @IBOutlet weak var customWebView:UIView!
    @IBOutlet weak var premiumView:UIView!
    @IBOutlet weak var loadingLabel:UILabel!
    @IBOutlet weak var loadingView:UIView!
    var counter = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if hasPurchased(){
            
            KRProgressHUD.show()
            hideUnhidePremiumView(hide: true)
            wkWebview = WKWebView(frame: customWebView.bounds, configuration: WKWebViewConfiguration())
            wkWebview.navigationDelegate = self
            wkWebview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.customWebView.addSubview(wkWebview)
            let router_url = "http://"+UserDefaults.standard.string(forKey: MyConstant.ROUTER_IP)!
            let url = URL(string: router_url)
            
            wkWebview.load(URLRequest(url: url!,cachePolicy: .returnCacheDataElseLoad))
            
            loadingView.isHidden = true
            
            
        }else{
            hideUnhidePremiumView(hide:false)
        }

    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        counter += 1
        if counter == 2{
            KRProgressHUD.dismiss()
            wkWebview.scrollView.delegate = self;
            wkWebview.scrollView.maximumZoomScale = 140
        }
    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        wkWebview.scrollView.maximumZoomScale = 140
    }
    
    @IBAction func openRouterSetting(_ sender:UIButton){
        let vc = storyboard?.instantiateViewController(withIdentifier: "RouterVC") as! RouterVC
        navigationController?.pushViewController(vc, animated: true)
        vc.isFrom = true
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
