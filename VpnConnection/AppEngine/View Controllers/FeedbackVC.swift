//
//  FeedbackVC.swift
//  CustomGallery
//
//  Created by Deepti Chawla on 17/06/20.
//  Copyright © 2020 Pavle Pesic. All rights reserved.
//

import UIKit

public class FeedbackVC: UIViewController {

    public  override func viewDidLoad() {
        super.viewDidLoad()
      self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
       
    }
    

    @IBAction func feedbackDone(_ sender: Any) {
         self.sendFeedback()
         self.view.removeFromSuperview()
    }
    

    @IBAction func feedbackCancel(_ sender: Any) {
         self.view.removeFromSuperview()
    }
}
