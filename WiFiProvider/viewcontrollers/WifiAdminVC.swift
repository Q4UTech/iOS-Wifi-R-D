//
//  WifiAdminVC.swift
//  WiFiProvider
//
//  Created by gautam  on 15/05/23.
//

import UIKit
import WebKit

class WifiAdminVC: UIViewController, WKUIDelegate {
    var webView: WKWebView!
    
    
    
    override func loadView() {
       let webConfiguration = WKWebViewConfiguration()
       webView = WKWebView(frame: .zero, configuration: webConfiguration)
       webView.uiDelegate = self
       view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let myURL = URL(string:"https://www.apple.com")
          let myRequest = URLRequest(url: myURL!)
          webView.load(myRequest)
    }
    

   

}
