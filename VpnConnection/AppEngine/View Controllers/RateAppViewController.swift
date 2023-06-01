//
//  RateAppViewController.swift
//  App Engine
//
//  Created by Quantum_MAC_7 on 09/04/20.
//  Copyright © 2020 Pulkit Babbar. All rights reserved.
//

import UIKit
import HCSStarRatingView

class RateAppViewController: UIViewController {
    @IBOutlet weak var ratingView: HCSStarRatingView!
          @IBOutlet weak var rateDescription: UILabel!
          @IBOutlet weak var rateTitle: UILabel!
    
    @IBOutlet weak var rateusView: UIView!
    @IBAction func rateDone(_ sender: Any) {
           
//                if ratingView.value == CGFloat(1) {
//                    self.view.makeToast("Your Response Has Been Submitted", duration: 3.0, position: .bottom)
//                       self.view.removeFromSuperview()
//
//                } else if ratingView.value == CGFloat(2) {
//                    self.view.makeToast("Your Response Has Been Submitted", duration: 3.0, position: .bottom)
//                       self.view.removeFromSuperview()
//                } else {
//                    self.view.makeToast("Your Response Has Been Submitted", duration: 3.0, position: .bottom)
//                    if let url = URL(string: RATE_APP_appurl),
//                        UIApplication.shared.canOpenURL(url){
//                        UIApplication.shared.open(url, options: [:])
//                    }
//                        self.view.removeFromSuperview()
//                }
        
        if  ratingView.value == CGFloat(0) {
//            self.view.makeToast("Please select rating stars", duration: 3.0, position: .bottom)
                          
                       } else if (ratingView.value <= CGFloat(3) && ratingView.value > CGFloat(0)) {
                          sendFeedback()
                          self.view.removeFromSuperview()
                       } else {
                          
                          if let url = URL(string: RATE_APP_rateurl),
                                    UIApplication.shared.canOpenURL(url){
                                    UIApplication.shared.open(url, options: [:])
                                }
//                        self.navigationController?.popViewController(animated: false)
                                    self.view.removeFromSuperview()
                       }
    }
    
    
    @IBAction func rateCancel(_ sender: Any) {
         self.view.removeFromSuperview()
       //  self.navigationController?.popViewController(animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
         rateTitle.text = RATE_APP_HEADER_TEXT
                 rateDescription.text = RATE_APP_rateapptext
                  // ratingView.tintColor = UIColor.ratingYellowColor()

        let color = hexStringToUIColor(hex: RATE_APP_BG_COLOR)
        ratingView.backgroundColor = color
                  rateusView.backgroundColor = color
       
    }
    

 

}
