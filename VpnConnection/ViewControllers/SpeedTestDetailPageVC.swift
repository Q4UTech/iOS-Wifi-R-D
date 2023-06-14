//
//  SpeedTestDetailPageVC.swift
//  VpnConnection
//
//  Created by gautam  on 12/06/23.
//

import UIKit
import SystemConfiguration.CaptiveNetwork
import CoreLocation
import CoreTelephony

class SpeedTestDetailPageVC: UIViewController {
    @IBOutlet weak var adView:UIView!
    @IBOutlet weak var heightConstraint:NSLayoutConstraint!
    @IBOutlet weak var pingLabel:UILabel!
    @IBOutlet weak var downloadLabel:UILabel!
    @IBOutlet weak var uploadLabel:UILabel!
    @IBOutlet weak var connectedType:UILabel!
    @IBOutlet weak var ipAddress:UILabel!
    @IBOutlet weak var providerLabel:UILabel!
    @IBOutlet weak var deleteView:UIView!
    @IBOutlet weak var transView:UIView!
    @IBOutlet weak var deleteBtn:UIButton!
    @IBOutlet weak var retestButton:UIButton!
    @IBOutlet weak var retestMsg:UILabel!
    private var locationManager = CLLocationManager()
    var ping = String()
    var uploadSpeed = Double()
    var downloadSpeed = Double()
    var provider = String()
    var ipAddressData = String()
    var isFrom = String()
    var providername = String()
    var connectiontype = String()
    var speedTestList  = [String:[SpeedTestData]]()
    var speedTestData  = [SpeedTestData]()
    var historyKey:String?
    var historyValue:SpeedTestData?
    
    var speedDataList = [SpeedTestData]()
    var downLoadArray = [Double]()
    var uploadArray = [Double]()
    var downloadSpeedData:Double = 0.0
    var uploadSpeedData:Double = 0.0
    var pingData = String()
    var currentTime:String? = ""
    
    var connectionType = String()
    var ipDetail = String()
    var wifiName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  askEnableLocationService()
        
       // print("add: \(getIFAddresses())")
    }
    private func getCurrentTime()->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"  // Set the desired format
        
        let currentTime = Date()
        let currentTimeString = formatter.string(from: currentTime)
        
        print("currentTimeString \(currentTimeString)")
        return currentTimeString
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isFrom == "SpeedHistory"{
            deleteBtn.isHidden = false
            pingLabel.text = ping + ".00"
            uploadLabel.text = String(uploadSpeed).maxLength(length: 4)
            downloadLabel.text = String(downloadSpeed).maxLength(length: 4)
            ipAddress.text = ipAddressData
            connectedType.text = connectiontype
            providerLabel.text = providername
            retestButton.isHidden = true
            retestMsg.isHidden = true
            print("historyData \(historyKey) \(historyValue)")
            print("complete data \(historyValue?.ipAddress) \(historyValue?.time) ")

        }else{
            deleteBtn.isHidden = true
            pingLabel.text = ping + ".00"
            uploadLabel.text = String(uploadSpeed).maxLength(length: 4)
            downloadLabel.text = String(downloadSpeed).maxLength(length: 4)
            ipAddress.text = ipDetail
            connectedType.text = connectionType
            ipAddress.text = wifiName

           
            providerLabel.text = wifiName
            if #available(iOS 15, *)  {
                                                  let today = Date.now
                                                 let formatter1 = DateFormatter()
                                                formatter1.dateFormat = "d MMMM"
                                           print(formatter1.string(from: today))
        
     
                                              // Convert the date to the desired output format
     
           
                                                currentTime = getCurrentTime()
                                                 pingData = UserDefaults.standard.string(forKey: "pingData") ?? "0.00"
          
                                              print("speedList1 \(pingData)")
              //  DispatchQueue.global(qos: .background).async { [self] in
                    
              
                                                if UserDefaults.standard.data(forKey: MyConstant.SPEED_LIST) == nil{
                                                   speedTestList[formatter1.string(from: today)] = [SpeedTestData(time: currentTime!, ping: pingData, downloadSpeed: downloadSpeed, uploadSpeed: uploadSpeed,connectionType: connectionType,ipAddress: ipDetail,providerName: wifiName ?? "No Data Available" )]
                                                      speedDataList.append(SpeedTestData(time: currentTime!, ping: pingData, downloadSpeed: downloadSpeed, uploadSpeed: uploadSpeed,connectionType: connectionType,ipAddress: ipDetail,providerName: wifiName ?? "No Data Available"))
                                                     if let encode = try?  JSONEncoder().encode(speedTestList) {
                                                          UserDefaults.standard.set(encode, forKey:MyConstant.SPEED_LIST)
                                                  }
                                                      print("speedDataList7777\(speedDataList)")
         
                                                }else {
                                                     speedDataList.append(SpeedTestData(time: currentTime!, ping: pingData, downloadSpeed: downloadSpeed, uploadSpeed: uploadSpeed,connectionType: connectionType,ipAddress: ipDetail,providerName: wifiName  ?? "No Data Available" ))
                                                       print("speedDataList88\(speedDataList)")
                                                 if let savedData = UserDefaults.standard.data(forKey: MyConstant.SPEED_LIST) {
                                                        do {
         
                                                            speedTestList = try JSONDecoder().decode([String:[SpeedTestData]].self, from: savedData)
                                                               print("speedDataList777\(speedDataList)")
                                                           for (_ ,data) in speedTestList{
                                                                  print("dataCount \(data.count)")
                                                         for i in data{
                                                                     speedDataList.append( SpeedTestData(time: i.time, ping:i.ping, downloadSpeed: i.downloadSpeed, uploadSpeed: i.uploadSpeed,connectionType: connectionType,ipAddress: ipDetail,providerName: wifiName ?? "No Data Available"))
                                                                 }
            
                                                            }
                                                       speedTestList[formatter1.string(from: today)] = speedDataList
                                                          if let encode = try?  JSONEncoder().encode(speedTestList) {
                                                           UserDefaults.standard.set(encode, forKey:MyConstant.SPEED_LIST)
                                                             }
                                                               print("working99 \(speedDataList.count)")
                                                          }catch{
          
                                                        }
                                                     }
                                                 }
            
                                             // }
            }
       }
        getBannerAd(self, adView, heightConstraint)
    }
    
    @IBAction func deleteButtonDialog(_ sender:UIButton){
        showHideDeleteDialog(isShow:false)
    }
    
    private func showHideDeleteDialog(isShow:Bool){
        deleteView.isHidden = isShow
    }
    
    func askEnableLocationService() {
        var showAlertSetting = false
        var showInitLocation = false
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .denied:
                showAlertSetting = true
                
                print("HH: kCLAuthorizationStatusDenied")
            case .restricted:
                showAlertSetting = true
                print("HH: kCLAuthorizationStatusRestricted")
            case .authorizedAlways:
               
                showInitLocation = true
                print("HH: kCLAuthorizationStatusAuthorizedAlways")
            case .authorizedWhenInUse:
               
                showInitLocation = true
                print("HH: kCLAuthorizationStatusAuthorizedWhenInUse")
            case .notDetermined:
                showInitLocation = true
                print("HH: kCLAuthorizationStatusNotDetermined")
            default:
                break
            }
        } else {
            showAlertSetting = true
            print("HH: locationServicesDisabled")
        }
        
        if showAlertSetting {
            let alertView = UIAlertController(title: nil, message: "Please enable location service for this app in ALLOW LOCATION ACCESS: Always, Go to Setting?", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            alertView.addAction(UIAlertAction(title: "Open Setting", style: .default) { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            })
           
            present(alertView, animated: true, completion: nil)
        }
        
        if showInitLocation {
            initLocationManager()
        }
    }

    func initLocationManager() {
        self.locationManager = CLLocationManager()
        if self.locationManager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization)) {
            self.locationManager.requestAlwaysAuthorization()
        }
    }

    
    @IBAction func back(_ sender:UIButton){
        RetestListener.instanceHelper.isSpeedTestComplete(complete: true)
        navigationController?.popViewController(animated: true)
    }
    @IBAction func deleteData(_ sender:UIButton){
        hideUnhideView(true, true)
        if UserDefaults.standard.data(forKey: MyConstant.SPEED_LIST) != nil{
            if let savedData = UserDefaults.standard.data(forKey: MyConstant.SPEED_LIST) {
                do {
                         
                    speedTestList = try JSONDecoder().decode([String:[SpeedTestData]].self, from: savedData)
                 //   print("speedDataList777\(speedDataList)")
                    for (_ ,data) in speedTestList{
                        print("dataCount \(data.count)")
                        for i in data{
                            speedTestData.append( SpeedTestData(time: i.time, ping:i.ping, downloadSpeed: i.downloadSpeed, uploadSpeed: i.uploadSpeed,connectionType: i.connectionType,ipAddress: i.ipAddress,providerName: wifiName ?? "No Data Available"))
                        }

                    }
                    if  speedTestList.keys.contains(historyKey!){
                      
                        if let index = speedTestData.firstIndex(where: { $0 == historyValue }) {
                            // Remove the object from the array
                            speedTestData.remove(at: index)
                        }
                        print("complete data1 \(speedTestData.count)")
                        speedTestList[historyKey!] = speedTestData
                        if let encode = try?  JSONEncoder().encode(speedTestList) {
                            UserDefaults.standard.set(encode, forKey:MyConstant.SPEED_LIST)
                        }
                        HistoryListener.instanceHelper.isDeleteComplete(complete: true)
                        navigationController?.popViewController(animated: true)
                    }
                 
                }catch{

                }
            }

        }
    }
    @IBAction func cancel(_ sender:UIButton){
        hideUnhideView(true, true)
    }
    @IBAction func openDeleteDialog(_ sender:UIButton){
      hideUnhideView(false, false)
    }
    @IBAction func retest(_ sender:UIButton){
        RetestListener.instanceHelper.isSpeedTestComplete(complete: true)
        navigationController?.popViewController(animated: true)
    }
    
    private func hideUnhideView(_ forDelete:Bool,_ forTrans:Bool){
        deleteView.isHidden = forDelete
        transView.isHidden = forTrans
    }
    
   
}
