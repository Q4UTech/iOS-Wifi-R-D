//
//  FullPagePromoInhouseVC.swift
//  App Engine
//
//  Created by Quantum_MAC_7 on 06/04/20.
//  Copyright © 2020 Pulkit Babbar. All rights reserved.
//

import UIKit
import SDWebImage
import WebKit
class FullPagePromoInhouseVC: UIViewController ,InhouseListenerProtocol,WKNavigationDelegate {
  
    func onInhouseDownload(inHouse: Inhouse, viewController: UIViewController) {

        if inHouse.fullAdscampType != "" {

                   if inHouse.fullAdscampType == "html"{
                    adsImage.isHidden = true
                    webView.isHidden = false
                    let url = URL(string:inHouse.fullAdshtml)!
                     webView.load(URLRequest(url: url))
                     webView.allowsBackForwardNavigationGestures = true
                    let leftButton = UIButton(type: UIButton.ButtonType.custom)
                    leftButton.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
                    leftButton.clipsToBounds = true
                    leftButton.setImage(UIImage(named: "yourBackButton.png"), for: .normal) // add custom image
                    leftButton.addTarget(self, action: Selector(("onBackButton_Clicked:")), for: UIControl.Event.touchUpInside)
                    let leftBarButton = UIBarButtonItem()
                    leftBarButton.customView = leftButton
                    self.navigationItem.leftBarButtonItem = leftBarButton
                       FullAdsListener.adsInstanceHelper.fullAdsLoaded()
                   }
                   else{
                    adsImage.isHidden = false
                    webView.isHidden = true
                    print("FullAdsinHouseSrcCheck \(inHouse.fullAdssrc)")
                    
                    adsImage.sd_setImage(with: URL(string: inHouse.fullAdssrc), placeholderImage: UIImage(named: "placeholder.png"))
                    
                    let tapGesture = MyTapGesture(target: self, action: #selector(imageTapped(gesture:)))

                                        // add it to the image view;
                                        adsImage.addGestureRecognizer(tapGesture)
                                        // make sure imageView can be interacted with by user
                    print("inHouse.clicklink\(inHouse.fullAdsClickLink)")
                                           tapGesture.clicktype = inHouse.fullAdsClickLink
                                        adsImage.isUserInteractionEnabled = true
                    FullAdsListener.adsInstanceHelper.fullAdsLoaded()
                
                }
               }
               else{
                FullAdsListener.adsInstanceHelper.FullAdsFailed(AdsEnum.FULL_ADS_INHOUSE, "Inhouse Full Ad Failed", self)
               }

    }
    
    func onBackButton_Clicked(sender: UIButton)
    {
        if(webView.canGoBack) {
            webView.goBack()
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func imageTapped(gesture: MyTapGesture) {
         // if the tapped view is a UIImageView then set it to imageview
         if (gesture.view as? UIImageView) != nil {
            print("ImageURL \(NSURL(string: gesture.clicktype))")
           UIApplication.shared.openURL(NSURL(string: gesture.clicktype)! as URL)

         }
     }
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBAction func exit(_ sender: Any) {
        navigationController?.popViewController(animated: true)

        self.dismiss(animated: true, completion: nil)
        FullAdsListener.adsInstanceHelper.FullAdsClosed(self)
       // AppFullAdsCloseListner.adsInstanceHelper.FullAdsClos(viewController: self)
    }
    
    
    @IBOutlet weak var adsImage: UIImageView!
    var type = String()
    var clicklink = String()
    var src = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.isHidden = true
        adsImage.isHidden = true
        webView.navigationDelegate = self
        print("InhouseType\(type)")
        if type == ""{
             type = IH_FULL
            print("InhouseType111\(type)")
        }
        else{
            print("InhouseType222\(type) \(src)")
            InHouseHelper.inHouseInstanceHelper.inhousedelegate = self
            InHouseFullAds.shared.getInhouseFullAds(from: self ,type: type)
            
            
        }
  
    }
    

   

}

