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
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.data(forKey: MyConstant.PASSWORD_LIST) == nil{
            callPasswordHintApi()
            
        }else{
            
            fetchFromLocal()
        }
        getBannerAd(self, adView, heightConstraint)
       
        
    }
    
    private func fetchFromLocal(){
        passwordList.removeAll()
       
            
          
            if let savedData = UserDefaults.standard.data(forKey: MyConstant.PASSWORD_LIST) {
                do {
                   
                    // Create an instance of JSONDecoder
                    let decoder = JSONDecoder()
                    
                    // Decode the data back into an array of persons
                    let savedPersons = try decoder.decode([PasswordDataDetail].self, from: savedData)
                    for i in savedPersons{
                        passwordList.append(PasswordDataDetail(brand: i.brand, type: i.type, username: i.username, passwrod: i.passwrod))
                    }
                    filteredData = passwordList
                  
                    DispatchQueue.main.async { [self] in
                        KRProgressHUD.dismiss()
                        print("fifilteredData \(filteredData.count)")
                       
                        if totalCount != nil{
                            totalPassword.text = "Total Password : \(filteredData.count)"
                        }
                        passwordTaableView.reloadData()
                        //                           }
                    }
                    print("savedPersons\(savedPersons.count)")
                } catch {
                    print("Error decoding persons array: \(error)")
                }
            }
       
    }
    
    
   
    
    @IBAction func goPremium(_ sender:UIButton){
        
    }
    
     func callPasswordHintApi(){
       if NetworkHelper.sharedInstanceHelper.isConnectedToNetwork(){
           KRProgressHUD.showOn(self).show()
         
         //  passwordList.removeAll()
         print("URL \(URL)")
           guard let url = Foundation.URL(string: URL) else {
                   print("Invalid URL")
                   return
               }
           let session = URLSession.shared

               var request = URLRequest(url: url)
               request.httpMethod = "GET"
           let task = session.dataTask(with: request) { [self] (data, response, error) in
               // Handle the response and error
               if let error = error {
                   print("Error: \(error.localizedDescription)")
                   return
               }
               
               guard let httpResponse = response as? HTTPURLResponse else {
                   print("Invalid response")
                   return
               }
               
               if httpResponse.statusCode == 200 {
                  
                   // Successful response
                   if let data = data {
                       print("data_val \(data.count) ")
                       // Parse and handle the data
                       // You can use JSONSerialization or other methods to parse the data
                       // Example: let json = try? JSONSerialization.jsonObject(with: data, options: [])
                       // ...
                       let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                       let status = json!["status"] as? String
                       let array = json!["routerlist"] as? NSArray
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
                           savePasswordListToLocal(passwordList: filteredData)
                           passwordTaableView.reloadData()
                           if totalCount != nil{
                               totalPassword.text = "Total Password : \(totalCount)"
                           }
                           //                           }
                       }
                       
                   }
               } else {
                   // Handle unsuccessful response
                   print("HTTP response status code: \(httpResponse.statusCode)")
               }
            
           }
           task.resume()

//           let urlPath: String = URL
//           var url: NSURL = NSURL(string: urlPath)!
//           var request1: NSURLRequest = NSURLRequest(url: url as URL)
//           let queue:OperationQueue = OperationQueue()
//           NSURLConnection.sendAsynchronousRequest(request1 as URLRequest, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
//               var err: NSError
//               var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
//               print("Asynchronous\(jsonResult)")
//           })
//               Alamofire.request(URL, method: .get ,encoding: JSONEncoding.default).responseData { [self] response in
//                   print("respnse \(response)")
//
//                   switch response.result {
//
//                   case .success(let value):
//                       print("respnse1 \(value)")
//
//                       do {
//
//                           let jObject : Dictionary? = try JSONSerialization.jsonObject(with: value) as? Dictionary<String, Any>
//                           let status = jObject!["status"] as? String
//                           let array = jObject!["routerlist"] as? NSArray
//                           // print("status \(String(describing: status)) \(jObject)")
//                           for i in array! {
//                               let data:Dictionary? = i as? Dictionary<String, Any>
//                               let brand = data!["brand"] as? String
//                               let type = data!["type"] as? String
//                               let username = data!["username"] as? String
//                               let password = data!["passwrod"] as? String
//                               passwordList.append(PasswordDataDetail(brand: brand!, type: type!, username: username ?? "no data", passwrod: password ?? "no data"))
//                               filteredData = passwordList
//                               totalCount = filteredData.count
//
//                           }
//                           DispatchQueue.main.async { [self] in
//                               KRProgressHUD.dismiss()
//                               passwordTaableView.reloadData()
//                               if totalCount != nil{
//                                   totalPassword.text = "Total Password : \(totalCount)"
//                               }
//                           }
//
//
//                       }catch{
//                           KRProgressHUD.dismiss()
//                       }
//
//
//
//                       break
//                   case .failure(_):
//                       KRProgressHUD.dismiss()
//                       print("failure11\(response.error)")
//
//                       break
//
//
//                   }
//               }
               
//           }
               
       }else{
           view.makeToast("Please connect to internet")
       }
    }
    
}

func savePasswordListToLocal(passwordList:[PasswordDataDetail]){
    do {
        // Create an instance of JSONEncoder
        let encoder = JSONEncoder()
        
        // Encode the array of persons into data
        let data = try encoder.encode(passwordList)
        
        // Save the encoded data using UserDefaults
        UserDefaults.standard.set(data, forKey: MyConstant.PASSWORD_LIST)
    } catch {
        print("Error encoding persons array: \(error)")
    }
}

extension PasswordHintVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordHintCell", for: indexPath) as! PasswordHintCell
        print("filteredData1 \(filteredData.count)")
        if filteredData != nil {
            let data = filteredData[indexPath.row]
            
            cell.brand.text = data.brand
            cell.type.text = data.type
            cell.username.text = data.username
            cell.password.text = data.passwrod
        }
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
