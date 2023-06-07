//
//  CheckForceUpdateVC.swift
//  CustomGallery
//
//  Created by Deepti Chawla on 17/06/20.
//  Copyright © 2020 Pavle Pesic. All rights reserved.
//

import UIKit

public class CheckForceUpdateVC: UIViewController {

    public  override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)

    }
    

    @IBAction func ForceUpdateDone(_ sender: Any) {
        checkForForceUpdates(self)
          self.view.removeFromSuperview()
    }
    
    
    @IBAction func ForceUpdateCancel(_ sender: Any) {
        self.view.removeFromSuperview()
           }
    }
    

