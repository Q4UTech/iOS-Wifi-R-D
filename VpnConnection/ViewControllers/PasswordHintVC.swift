//
//  PasswordHintVC.swift
//  WiFiProvider
//
//  Created by gautam  on 19/05/23.
//

import UIKit
import Alamofire
import Toast_Swift
import KRProgressHUD

class PasswordHintVC: UIViewController,SearchDelegate{
    func searchData(searchDarta: String) {
        print("searchDarta\(searchDarta)")
        searchNotes(textData:searchDarta)
    }
    private func searchNotes(textData:String){
        filteredData=[]
        
        if textData == ""{
           
            filteredData = passwordList
            reloadData()
          
        }
        
        for i in passwordList{
            if  i.brand != nil{
                if i.brand.lowercased().contains(textData.lowercased()) || i.type.lowercased().contains(textData.lowercased()) {
                    
                    filteredData.append(i)
                    
                }
            }
        }
        
        if filteredData.count == 0{
           // noDataView.isHidden = false
        }else{
            //noDataView.isHidden = true
        }
        
//        setNotesCount(count: filteredData!.count)
        reloadData()

    }
    func reloadData(){
        passwordTaableView.reloadData()
    }
    
    
    @IBOutlet weak var adView:UIView!
    @IBOutlet weak var heightConstraint:NSLayoutConstraint!
    @IBOutlet weak var passwordTaableView:UITableView!
    @IBOutlet weak var totalPassword:UILabel!
    @IBOutlet weak var premiumView:UIView!
    @IBOutlet weak var premiumDialogView:UIView!
    var passwordList = [PasswordDataDetail]()
    var filteredData = [PasswordDataDetail]()
    var totalCount = 0;
    
    let URL = "https://quantum4you.com/engine/wifiauthservice/routerlist/v5wifitrackernew"
    let passwordData = [PasswordDataDetail]()
    override func viewDidLoad() {
        super.viewDidLoad()
        SearchController.instanceHelper.searchdelegate = self
        // Do any additional setup after loading the view.
        passwordTaableView.dataSource = self
        passwordTaableView.delegate = self
        callPasswordHintApi()
        
    }
    override func viewWillAppear(_ animated: Bool) {
       
        getBannerAd(self, adView, heightConstraint)
       
        
    }
    
   
    
    @IBAction func goPremium(_ sender:UIButton){
        
    }
    
     func callPasswordHintApi(){
       if NetworkHelper.sharedInstanceHelper.isConnectedToNetwork(){
           
          KRProgressHUD.showOn(self).show()
         //  passwordList.removeAll()
         print("URL \(URL)")
               Alamofire.request(URL, method: .get ,encoding: JSONEncoding.default).responseData { [self] response in
                   print("respnse \(response)")

                   switch response.result {

                   case .success(let value):
                       print("respnse1 \(value)")

                       do {

                           let jObject : Dictionary? = try JSONSerialization.jsonObject(with: value) as? Dictionary<String, Any>
                           let status = jObject!["status"] as? String
                           let array = jObject!["routerlist"] as? NSArray
                           // print("status \(String(describing: status)) \(jObject)")
                           for i in array! {
                               let data:Dictionary? = i as? Dictionary<String, Any>
                               let brand = data!["brand"] as? String
                               let type = data!["type"] as? String
                               let username = data!["username"] as? String
                               let password = data!["passwrod"] as? String
                               passwordList.append(PasswordDataDetail(brand: brand!, type: type!, username: username ?? "no data", passwrod: password ?? "no data"))
                               filteredData = passwordList
                               totalCount = filteredData.count

                           }
                           DispatchQueue.main.async { [self] in
                               KRProgressHUD.dismiss()
                               passwordTaableView.reloadData()
                               if totalCount != nil{
                                   totalPassword.text = "Total Password : \(totalCount)"
                               }
                           }


                       }catch{
                           KRProgressHUD.dismiss()
                       }



                       break
                   case .failure(_):
                       KRProgressHUD.dismiss()
                       print("failure11\(response.error)")

                       break


                   }
               }
               
//           }
               
       }else{
           view.makeToast("Please connect to internet")
       }
    }
    
}
extension PasswordHintVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = filteredData[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "WifiAdminVC") as! WifiAdminVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
