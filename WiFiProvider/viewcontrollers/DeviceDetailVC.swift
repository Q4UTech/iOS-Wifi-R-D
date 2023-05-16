//
//  DeviceDetailVC.swift
//  WiFiProvider
//
//  Created by gautam  on 15/05/23.
//

import UIKit

class DeviceDetailVC: UIViewController {
    @IBOutlet weak var adView:UIView!
    @IBOutlet weak var heightConstraint:NSLayoutConstraint!
    @IBOutlet weak var premiumView:UIView!
    @IBOutlet weak var transView:UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func blockDevice(_ sender:UIDevice){
        let vc = storyboard?.instantiateViewController(withIdentifier: "WifiAdminVC") as! WifiAdminVC
        navigationController?.pushViewController(vc, animated: true)
    }

}
