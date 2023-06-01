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
    @IBOutlet weak var onlineDurationLabel:UILabel!
    @IBOutlet weak var osLabel:UILabel!
    @IBOutlet weak var osVersionLabel:UILabel!
    @IBOutlet weak var brandLabel:UILabel!
    @IBOutlet weak var modelLabel:UILabel!
    @IBOutlet weak var parentLabel:UILabel!
    @IBOutlet weak var mainLabel:UILabel!
   
  
  let info = DeviceInfo()
    
    var data = FingNodes()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if data != nil {
            deviceBestName.text = data.bestCategory
                switch(data.bestType){
                case "ROUTER":
                    devideTypeImg.image = UIImage(named: "router")
                    break
                case "LAPTOP":
                    devideTypeImg.image = UIImage(named: "desktop")
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
                if data.bestOS != nil{
                    let img = info.getOsIcon(value: data.bestOS!)
                    devideOsImg.image = UIImage(named:img)
                }
                
                osLabel.text = data.bestOS
                osVersionLabel.text = data.bestMake
            }else{
                bestMakeView.isHidden = true
                bestMakeHeight.constant = 0
            }
            
            if data.bestModel != nil{
                deviceBestModel.text = data.bestName
                parentLabel.text = data.bestMake
              
                let img = info.getDeviceIcon(value: data.bestMake!)
                devideModelImg.image = UIImage(named: img)
                brandLabel.text = data.bestName
                modelLabel.text = data.bestModel
            }else{
                bestModelView.isHidden = true
                bestMakeHeight.constant = 0
            }
            
            if data.bestMake != nil && data.bestModel != nil{
                mainLabel.text = "\(data.bestName ?? "") / \(data.bestMake ?? "")"
            }else{
                mainLabel.isHidden = true
            }
           if let firstSeenTimestamp = data.firstSeenTimestamp {
             
               
               let timestamp = Date().timeIntervalSince1970
               let date = Date(timeIntervalSince1970: timestamp)
               let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
               let formattedDate = dateFormatter.string(from: date)
               print("firstSeenTimestamp\(firstSeenTimestamp) \(formattedDate) \(Date().timeIntervalSinceNow)")
               let formatter = DateFormatter()
               formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"

               let timestamp1String = firstSeenTimestamp
               let timestamp2String = formattedDate

               if let timestamp1 = formatter.date(from: timestamp1String),
                  let timestamp2 = formatter.date(from: timestamp2String) {

                   let difference = timestamp2.timeIntervalSince(timestamp1)
                   print("Time difference: \(difference)")
                   let minutes = Int(difference / 60)
                   let hours = minutes / 60
                   let remainingMinutes = minutes % 60

                   var timeDifferenceString = ""
                   if hours > 0 {
                       timeDifferenceString = "\(hours) hour"
                       if hours > 1 {
                           timeDifferenceString += "s"
                           print("Time difference11: \(timeDifferenceString)")
                           onlineDurationLabel.text = timeDifferenceString
                       }
                   } else {
                       timeDifferenceString = "\(remainingMinutes) minute"
                       if remainingMinutes > 1 {
                           timeDifferenceString += "s"
                           print("Time difference22: \(timeDifferenceString)")
                           onlineDurationLabel.text = timeDifferenceString
                       }
                   }

                   print("Time difference33: \(timeDifferenceString)")
               }

           }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getBannerAd(self, adView, heightConstraint)
    }

    @IBAction func blockDevice(_ sender:UIDevice){
       
            let vc = storyboard?.instantiateViewController(withIdentifier: "WifiAdminVC") as! WifiAdminVC
            navigationController?.pushViewController(vc, animated: true)
        showFullAds(viewController: self, isForce: false)

    }
    @IBAction func back(_ sender:UIDevice){
        
        navigationController?.popViewController(animated: true)
    }

}
