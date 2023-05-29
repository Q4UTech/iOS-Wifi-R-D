//
//  CountryVC.swift
//  WiFiProvider
//
//  Created by gautam  on 16/05/23.
//

import UIKit
import SDWebImage

protocol CountryControllerProtocol {
    func countryChanged(newCountry: Bool)
}
@available(iOS 13.0, *)
class CountryVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var countryTableView: UITableView!
    @IBOutlet weak var bannerAdsView: UIView!
    @IBOutlet weak var bannerAdsHeightContraint: NSLayoutConstraint!
        
    var delegate: CountryControllerProtocol?
    var categoryData:[DataModel]!
    var selectedCountry:String?
    var delegateSelectedCountry:CountryControllerProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        headingLabel.text = "Secure VPN"

        lightTheme()
        selectedCountry = UserDefaults.standard.string(forKey: "VPN_NAME")
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func setUpTableView(){
        countryTableView.delegate = self
        countryTableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        getBannerAd(self, bannerAdsView, bannerAdsHeightContraint)
    }
    override func viewDidAppear(_ animated: Bool) {
       
    }
    func reloadTableView(){
        DispatchQueue.main.async {
           
            self.countryTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("categoryData\(categoryData.count)")
        return categoryData.count
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: MyConstant.keyName.kCountryCell) as! CountryTableViewCell
        cell.countryName.text = categoryData[indexPath.row].vpnname
        cell.countryFlagImage.sd_setImage(with: URL.init(string: categoryData[indexPath.row].vpn_flag))
        print("vpnflag \(categoryData[indexPath.row].vpn_flag)")
        if selectedCountry == nil {
            if indexPath.row == 0 {
                cell.selectedButton.setImage(UIImage(named:  "selected_icon"), for: .normal)
            }
        }
      else if selectedCountry == categoryData[indexPath.row].vpnname {
            cell.selectedButton.setImage(UIImage(named:  "selected_icon"), for: .normal)
        }
        else {
            cell.selectedButton.setImage(UIImage(named:  "unselected_icon"), for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegateSelectedCountry.countryChanged(newCountry: true)
        let cell = tableView.dequeueReusableCell(withIdentifier: MyConstant.keyName.kCountryCell) as! CountryTableViewCell
     
        let countryData = categoryData[indexPath.row]
        print("countrydata \(countryData.file_location)")
//        if countryData.purchsedType == "free" {
            CountrySelectionList.instanceHelper.checkConnectionState(countrySelection:categoryData[indexPath.row].vpnname, fileLocation: categoryData[indexPath.row].file_location)
            UserDefaults.standard.set(categoryData[indexPath.row].vpnname, forKey: "VPN_NAME")
            cell.isSelected = true
            UserDefaults.standard.set(categoryData[indexPath.row].file_location, forKey: "VPN_FILE")
            self.navigationController?.popViewController(animated: false)
//        }else{
//            print("hhh")
//        }
//        }else{
////            let purchased = UserDefaults.standard.bool(forKey: IN_APP_PURCHASED)
////            if purchased{
//                CountrySelectionList.instanceHelper.checkConnectionState(countrySelection:categoryData[indexPath.row].vpnname, fileLocation: categoryData[indexPath.row].file_location)
//                UserDefaults.standard.set(categoryData[indexPath.row].vpnname, forKey: "VPN_NAME")
//                cell.isSelected = true
//                UserDefaults.standard.set(categoryData[indexPath.row].file_location, forKey: "VPN_FILE")
//                self.navigationController?.popViewController(animated: false)
////            }else{
////                showPurchaseAlert(fileLocation: countryData.file_location,cell:cell,tableView)
////            }
//        }
      
        
    }

    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
//    func showPurchaseAlert(fileLocation : String,cell : CountryTableViewCell,_ tableView: UITableView){
//        let alert = UIAlertController(title: "Alert!", message: "Don't wanna loose the access to VPN Premium?Subscribe Now!", preferredStyle: UIAlertController.Style.alert)
//        
//        alert.addAction(UIAlertAction(title: "Ok",
//                                      style: UIAlertAction.Style.default,
//                                      handler: { [self](_: UIAlertAction!) in
//            cell.isSelected = false
//            tableView.reloadData()
//            
//            self.dismiss(animated: true, completion: nil)
//            let goPremiumStoryBoard = UIStoryboard(name: MyConstant.constants.kMain, bundle: nil).instantiateViewController(withIdentifier:MyConstant.keyName.kPremiumVC) as! PurchaseVC
//            
//            goPremiumStoryBoard.fromMoreTool = true
//            self.navigationController?.pushViewController(goPremiumStoryBoard, animated: true)
//            // self.navigationController?.popViewController(animated: false)
//        }))
//        
//        alert.addAction(UIAlertAction(title: "Cancel",
//                                      style: UIAlertAction.Style.default,
//                                      handler: {(_: UIAlertAction!) in
//            cell.isSelected = false
//            tableView.reloadData()
//            self.dismiss(animated: true, completion: nil)
//        }))
//        
//        self.present(alert, animated: true, completion: nil)
//    }
}
