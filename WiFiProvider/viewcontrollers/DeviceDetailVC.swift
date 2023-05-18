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
    @IBOutlet weak var bestModelView:UIView!
    @IBOutlet weak var bestModelHeight:NSLayoutConstraint!
    @IBOutlet weak var bestMakeView:UIView!
    @IBOutlet weak var bestMakeHeight:NSLayoutConstraint!
    @IBOutlet weak var devideTypeImg:UIImageView!
    @IBOutlet weak var devideOsImg:UIImageView!
    @IBOutlet weak var devideModelImg:UIImageView!
    @IBOutlet weak var deviceBestName:UILabel!
    @IBOutlet weak var deviceBestMake:UILabel!
    @IBOutlet weak var deviceBestModel:UILabel!
  
  
    
    var data = FingNodes()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if data != nil {
            
                switch(data.bestType){
                case "ROUTER":
                    devideTypeImg.image = UIImage(named: "router")
                    break
                case "LAPTOP":
                    devideTypeImg.image = UIImage(named: "router")
                    break
                case "MOBILE":
                    devideTypeImg.image = UIImage(named: "iphone")
                    break
                case "COMPUTER":
                    devideTypeImg.image = UIImage(named: "desktop")
                    break
                case "PRINTER":
                    devideTypeImg.image = UIImage(named: "printer")
                    break
                default :
                    print("none")
                
            }
            if data.bestMake != nil{
                deviceBestMake.text = data.bestOS
               // devideOsImg.image = UIImage(named: data)
            }else{
                bestMakeView.isHidden = true
                bestMakeHeight.constant = 0
            }
            
            if data.bestModel != nil{
                deviceBestModel.text = data.bestMake
            }else{
                bestModelView.isHidden = true
                bestMakeHeight.constant = 0
            }
//            if let firstSeenTimestamp = data.firstSeenTimestamp {
//                let diffDay: Int
//                let diffHour: Int
//                let diffMint: Int
//                if let value = AppUtils.convertDateToLong(firstSeenTimestamp) {
//                    let currentTime = Int(Date().timeIntervalSince1970 * 1000)
//                    diffDay = AppUtils.daysDifferent(currentTime, value)
//                    diffHour = AppUtils.hoursDifferent(currentTime, value)
//                    diffMint = AppUtils.mintDifferent(currentTime, value)
//                    if diffDay == 0 {
//                        if diffHour == 0 {
//                            deviceDetailsBinding?.tvOnline?.text = "Online since (\(diffMint)m)"
//                        } else {
//                            deviceDetailsBinding?.tvOnline?.text = "Online since (\(diffHour)h)"
//                        }
//                    } else {
//                        deviceDetailsBinding?.tvOnline?.text = "Online since (\(diffDay)d)"
//                    }
//                }
//            }
        }
        
    }
    

    @IBAction func blockDevice(_ sender:UIDevice){
        let vc = storyboard?.instantiateViewController(withIdentifier: "WifiAdminVC") as! WifiAdminVC
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func back(_ sender:UIDevice){
        
        navigationController?.popViewController(animated: true)
    }

}
