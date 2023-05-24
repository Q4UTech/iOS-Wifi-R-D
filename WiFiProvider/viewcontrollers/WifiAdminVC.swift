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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wkWebview = WKWebView(frame: customWebView.bounds, configuration: WKWebViewConfiguration())
               wkWebview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
               self.customWebView.addSubview(wkWebview)

               let url = URL(string: "https://www.google.com")
               wkWebview.load(URLRequest(url: url!))

    }
    
    @IBAction func openRouterSetting(_ sender:UIButton){
        let vc = storyboard?.instantiateViewController(withIdentifier: "RouterVC") as! RouterVC
        navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func closePage(_ sender:UIButton){
        
        navigationController?.popViewController(animated: true)
        
    }
   
    
    

   

}
