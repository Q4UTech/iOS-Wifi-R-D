//
//  ShareAppVC.swift
//  CustomGallery
//
//  Created by Deepti Chawla on 17/06/20.
//  Copyright © 2020 Pavle Pesic. All rights reserved.
//

import UIKit

public class ShareAppVC: UIViewController {

   public var share_text = String()
    public var share_url = String()

    @IBOutlet weak var shareDone: UIButton!
    
   
      public  override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    
        }

    @IBAction func shareDone(_ sender: Any) {
     
        shareAppsUrl(self,url:share_url,text:share_text)
        self.view.removeFromSuperview()
     //   self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareCancel(_ sender: Any) {
         self.view.removeFromSuperview()
    }
    
    }
