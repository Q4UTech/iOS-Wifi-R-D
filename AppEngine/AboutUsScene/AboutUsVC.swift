//
//  AboutUsVC.swift
//  RunReminder
//
//  Created by Pulkit Babbar on 12/03/20.
//  Copyright © 2020 Pulkit Babbar. All rights reserved.
//

import UIKit

class AboutUsVC: UIViewController {
    
    @IBOutlet weak var privacyPolicyButton: UIButton!
    @IBOutlet weak var tmsAndSrvcsButton: UIButton!
    @IBOutlet weak var allAppsButton: UIButton!
    @IBOutlet weak var officialWebsiteButton: UIButton!
    @IBOutlet weak var contactUsButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func privacyPolicyButtonAction(_ sender: Any) {
        if let url = URL(string: ABOUTDETAIL_PRIVACYPOLICY) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func tmsAndSrvcsButtonAction(_ sender: Any) {
        if let url = URL(string: ABOUTDETAIL_TERM_AND_COND) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func allAppsButtonAction(_ sender: Any) {
        if let url = URL(string: ABOUTDETAIL_OURAPP),
            UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func officialWebsiteButtonAction(_ sender: Any) {
        if let url = URL(string: ABOUTDETAIL_WEBSITELINK) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func fbButtonAction(_ sender: Any) {
        if let url = URL(string: ABOUTDETAIL_FACEBOOK),
                  UIApplication.shared.canOpenURL(url){
                  UIApplication.shared.open(url, options: [:])
              }
    }
    @IBAction func instagramButtonAction(_ sender: Any) {
        if let url = URL(string: ABOUTDETAIL_INSTA),
                        UIApplication.shared.canOpenURL(url){
                        UIApplication.shared.open(url, options: [:])
                    }
    }
    @IBAction func twitterButtonAction(_ sender: Any) {
        if let url = URL(string: ABOUTDETAIL_TWITTER),
                        UIApplication.shared.canOpenURL(url){
                        UIApplication.shared.open(url, options: [:])
                    }
    }
    
    @IBAction func contactUsButtonIcon(_ sender: Any) {
        if let url = URL(string: "https://www.quantum4u.in/contact") {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
