//
//  PasswordHintVC.swift
//  WiFiProvider
//
//  Created by gautam  on 19/05/23.
//

import UIKit
import Alamofire
import Toast_Swift

class PasswordHintVC: UIViewController {
    @IBOutlet weak var adView:UIView!
    @IBOutlet weak var heightConstraint:NSLayoutConstraint!
    @IBOutlet weak var passwordTaableView:UITableView!
    
    let URL = "https://quantum4you.com/engine/wifiauthservice/routerlist" + "/v5wifitrackernew"
    let passwordData = [PasswordDataDetail]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        passwordTaableView.dataSource = self
        passwordTaableView.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        callPasswordHintApi()
    }
    
    
    private func callPasswordHintApi(){
       if NetworkHelper.sharedInstanceHelper.isConnectedToNetwork(){
           NetworkHelper.sharedInstanceHelper.getPasswordApiData(networkListner: { listData,error in
               
               if listData != nil{
                  
                  // let code = listData?.routerlist?.count
               }
               
           })
           
                    
               
       }else{
           view.makeToast("Please connect to internet")
       }
    }
    
}
extension PasswordHintVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passwordData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = passwordData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordHintCell", for: indexPath) as! PasswordHintCell
        cell.brand.text = data.brand
        cell.type.text = data.type
        cell.username.text = data.username
        cell.password.text = data.passwrod
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    
    
}
