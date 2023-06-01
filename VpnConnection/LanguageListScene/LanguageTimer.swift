//
//  LanguageTimer.swift
//  Q4U-PhoneSwtich
//
//  Created by Deepti Chawla on 14/02/22.
//

import Foundation


import UIKit

class LanguageTimer {
    
    static var shared: LanguageTimer = {
       return LanguageTimer()
    }()
    var counter = 1
    var timer : Timer?
    var viewController = UIViewController()
    func startTimer(target:UIViewController) {
        viewController = target
        counter = 1
      
        timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    @objc func updateTimer() {
        
        if counter != 0 {
            counter -= 1
        } else {
            if let timer = self.timer {
                timer.invalidate()
                self.timer = nil
                setLanguageAlert()
            }
        }
    }

    func setLanguageAlert(){
        viewController.view.makeToast("Language Change Successfully".localiz())
        let alert = UIAlertController(title: "Alert!".localiz(), message: "Please Relaunch the app to see changes".localiz(), preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Exit".localiz(),
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        exit(0);
                                      }))
        viewController.present(alert, animated: true, completion: nil)
    }
}

