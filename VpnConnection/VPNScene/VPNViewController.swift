////
////  VPNViewController.swift
////  Q4U_VPNAPP
////
////  Created by Deepti Chawla on 12/04/21.
////  Copyright © 2021 Anchorfree Inc. All rights reserved.
////
//
//import UIKit
//import UserNotifications
//import KRProgressHUD
////import SwiftyGif
//import MapKit
//import Lottie
//
//@available(iOS 13.0, *)
//class VPNViewController: UIViewController ,VPNConnectedStatusDelegate,CountryControllerProtocol,UITableViewDelegate,UITableViewDataSource,ConnectionStatusDelegate{
//    func countryChanged(newCountry: Bool) {
//        connectButton.setTitle("Connect", for: .normal)
//        profileVM.connection.stopVPN()
//        buttonSwitched = false
//    }
//    
//    func connectionStatus(connectionStatus: String) {
//        if connectionStatus == "connecting" {
//            connectionStatusValue = true
//        }
//        if connectionStatus == "disconnected" {
//            buttonSwitched = true
//           
//            connectLbl.text = "Connect"
//            ipProtectedLbl.text = "Your device’s IP is not protected"
//            if connectedAnimationView != nil {
//                connectedAnimationView.removeFromSuperview()
//
//            }
//            if loaderAnimationView != nil {
//                loaderAnimationView.removeFromSuperview()
//            }
//            lockImg.image = UIImage(named: "lock")
//           
//            startAnimation()
//            pauseTimer()
//            value = false
//            
//        }
//        if connectionStatus == "connected" {
//            
//            ipProtectedLbl.text = "Your device’s IP is protected."
//            loaderAnimationView.removeFromSuperview()
//            connectionAnimationView.removeFromSuperview()
//            startConnectedAnimation()
//            lockImg.image = UIImage(named: "Lock_green")
//           
//            value = true
//           startTimer()
//            if (UserDefaults.standard.string(forKey: "VPN_NAME")) != nil {
//                view.makeToast("\(UserDefaults.standard.string(forKey: "VPN_NAME")! + " is conneted")")
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                self.connectLbl.text = "Disconnect"
//            }
//            
//        }
//        
//    }
//    @IBOutlet weak var mapView: MKMapView!
//    @IBOutlet weak var tblView: UITableView!
//    @IBOutlet weak var menuButton: UIButton!
//    @IBOutlet weak var flagIcon: UIImageView!
//    @IBOutlet weak var connectionTime: UILabel!
//    @IBOutlet weak var rateusBtn: UIButton!
//    @IBOutlet weak var locationSelectionButton: UIButton!
//    @IBOutlet weak var rightArrowLabel: UIButton!
//    @IBOutlet weak var bottomView: UIView!
//    @IBOutlet weak var redview: UIView!
//    @IBOutlet weak var fasterServerLabel: UILabel!
//    @IBOutlet weak var ipProtectedLbl: UILabel!
//    @IBOutlet weak var ipLbl: UILabel!
//    @IBOutlet weak var animationView: UIView!
//    @IBOutlet weak var lockImg: UIImageView!
//    fileprivate let pulseAnimationUniqueIdentifier = "com.connected.com"
//    @IBOutlet weak var connectButton: UIButton!
//    @IBOutlet weak var connectLbl: UILabel!
//    //private var films: Film?
//    var internetStatus = Bool()
//    var countryStatus = Bool()
//    var profileVM = ProfileViewModel()
//    var countryData = [DataModel]()
//    var buttonSwitched : Bool = false
//   
//    var selectedCountry:String?
//    var selectedCountryFlag:String?
//    var value:Bool?
//    var connectionStatusValue = Bool()
////    private var connectionAnimationView:AnimationView!
////    private var connectedAnimationView:AnimationView!
////    private var loaderAnimationView:AnimationView!
//    var counter = 0
//    var timeStamp = Timer()
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        selectedCountry = UserDefaults.standard.string(forKey: "VPN_NAME")
//        connectButton.isUserInteractionEnabled = true
//        callCatApi()
//        locationSelectionButton.layer.borderWidth = 1
//  
//        tblView.isHidden = true
//        tblView.layer.borderWidth = 1
//        
//        tblView.layer.cornerRadius = 30
//        ipProtectedLbl.text = "Your device’s IP is not protected"
//        mapView.delegate = self
//      
//        rateusBtn.setTitle("Rate us", for: .normal)
//        value = false
//        checkApplicationState()
//    }
//    deinit {
//        
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        if UserDefaults.standard.string(forKey: "VPN_NAME") != nil && UserDefaults.standard.string(forKey: "FLAG") != nil {
//            self.fasterServerLabel.text = UserDefaults.standard.string(forKey: "VPN_NAME")
//            self.flagIcon.sd_setImage(with: URL.init(string: UserDefaults.standard.string(forKey: "FLAG")!))
//            self.profileVM.connection.setCustomConfigFile(url: UserDefaults.standard.string(forKey: "VPN_FILE")!)
//            coordinates(forAddress: UserDefaults.standard.string(forKey: "VPN_NAME_FIRST")!) {
//                (location) in
//                guard let location = location else {
//                    // Handle error here.
//                    return
//                }
//                self.openMapForPlace(lat: location.latitude, long: location.longitude)
//            }
//            
//        }
//        tblView.isHidden = true
//        locationSelectionButton.isHidden = false
//        rightArrowLabel.isHidden = false
//        fasterServerLabel.isHidden = false
//        flagIcon.isHidden = false
//     
//        removeAnnotation()
//       
//        if value == true {
//           
//            connectLbl.text = "Disconnect"
//            loaderAnimationView.removeFromSuperview()
//            connectionAnimationView.removeFromSuperview()
//            startConnectedAnimation()
//        }
//        else {
//         
//           
//            connectLbl.text = "Connect"
//            ipProtectedLbl.text = "Your device’s IP is not protected"
//            lockImg.image = UIImage(named: "lock")
//            startAnimation()
//            
//        }
//    }
//    func checkApplicationState(){
//      
//            let notificationCenter = NotificationCenter.default
//            notificationCenter.addObserver(self, selector: #selector(appCameToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
//   
//        }
//        @objc func appCameToForeground() {
//            if connectionStatusValue == true {
//                
//                connectionAnimationView.play()
//                loaderAnimationView.play()
//            }
//        }
//    
//    override func viewDidLayoutSubviews() {
////        redview.roundCorners([.topLeft,.topRight], radius: 15)
////        bottomView.roundCorners([.topLeft,.topRight], radius: 10)
//    }
//    
// 
//    func startTimer() {
//            counter = 0
//            self.timeStamp = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateConnectedTimer), userInfo: nil, repeats: true)
//            
//        }
//        
//        @objc func updateConnectedTimer() {
//            ipLbl.text = "Connected Since \(timeFormatted(self.counter))"
//            counter += 1
//        }
//        
//        func pauseTimer() {
//            timeStamp.invalidate()
//        }
//    func timeFormatted(_ totalSeconds: Int) -> String {
//           let seconds: Int = totalSeconds % 60
//           let minutes: Int = (totalSeconds / 60) % 60
//        let hours:Int = ((totalSeconds % 86400) / 3600)
//        return String(format: "%02d:%02d:%02d", hours,minutes, seconds)
//       }
//    func startAnimation(){
//        connectionAnimationView=AnimationView(name: "con1")
//        connectionAnimationView.contentMode = .scaleToFill
//        connectionAnimationView.center=animationView.center
//        connectionAnimationView.frame = animationView.bounds
//        connectionAnimationView.loopMode = .loop
//        connectionAnimationView.animationSpeed = 1
//        //connectionAnimationView.play()
//        animationView?.addSubview(connectionAnimationView)
//    }
//    func startConnectedAnimation(){
//        connectedAnimationView=AnimationView(name: "con2")
//        connectedAnimationView.contentMode = .scaleToFill
//        connectedAnimationView.center=animationView.center
//        connectedAnimationView.frame = animationView.bounds
//        connectedAnimationView.loopMode = .playOnce
//        connectedAnimationView.animationSpeed = 1
//        connectedAnimationView.play()
//        animationView?.addSubview(connectedAnimationView)
//    }
//    func loaderAnimation(){
//        loaderAnimationView=AnimationView(name: "loader")
//        loaderAnimationView.contentMode = .scaleToFill
//       
//        loaderAnimationView.center=redview.center
//        loaderAnimationView.frame = redview.bounds
//        loaderAnimationView.loopMode = .loop
//        loaderAnimationView.animationSpeed = 1
//        loaderAnimationView.play()
//        
//        redview?.addSubview(loaderAnimationView)
//    }
//    func coordinates(forAddress address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
//        let geocoder = CLGeocoder()
//        geocoder.geocodeAddressString(address) {
//            (placemarks, error) in
//            guard error == nil else {
//                print("Geocoding error: \(error!)")
//                completion(nil)
//                return
//            }
//            completion(placemarks?.first?.location?.coordinate)
//        }
//    }
//    func  openMapForPlace(lat:Double = 0, long:Double = 0, placeName:String = "") {
//        let latitude: CLLocationDegrees = lat
//        let longitude: CLLocationDegrees = long
//        let regionDistance:CLLocationDistance = 1000000
//        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
//        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
//        mapView.setRegion(regionSpan, animated: true)
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = coordinates
//        mapView.addAnnotation(annotation)
//        mapView.mapType = .mutedStandard
//    
//    }
//    
//    
//    @IBAction func connectButtonActions(_ sender: UIButton) {
//       // if ServiceHelper.sharedInstanceHelper.isConnectedToNetwork(){
//           
//            ConnectionStatus.instanceHelper.itemdelegates = self
//            tblView.isHidden = true
//            locationSelectionButton.isHidden = false
//            rightArrowLabel.isHidden = false
//            fasterServerLabel.isHidden = false
//            flagIcon.isHidden = false
//            self.buttonSwitched = !self.buttonSwitched
//            if self.buttonSwitched{
//                Settings.saveProfile(profile: self.profileVM.profile)
//                Settings.setSelectedProfile(profileId: self.profileVM.profile.profileId)
//                
//                connectLbl.text = "Connecting"
//                profileVM.mainButtonAction()
//                connectionAnimationView.play()
//                loaderAnimation()
//            }
//            else{
//                profileVM.connection.stopVPN()
//                connectionAnimationView.stop()
//                connectLbl.text = "Connect"
//                
//                if connectedAnimationView != nil {
//                    connectedAnimationView.removeFromSuperview()
//                    
//                }
//                if loaderAnimationView != nil {
//                    loaderAnimationView.removeFromSuperview()
//                }
//                lockImg.image = UIImage(named: "lock")
//               
//                ipProtectedLbl.text = "Your device’s IP is not protected"
//                startAnimation()
//                
//            }
////        }
////        else {
////            self.view.makeToast(kConstant.constants.kCheckInternet, point: CGPoint(x:view.center.x, y: view.frame.maxY - 70), title: "", image: nil, completion: nil)
////        }
//    }
//    
//    @IBAction func rateusBtn(_ sender: UIButton) {
//       // rateApp(showCustom: true, self: self)
//        
//    }
//    
//    func callCatApi(){
//        KRProgressHUD.show()
//       // if ServiceHelper.sharedInstanceHelper.isConnectedToNetwork(){
//            CountryDataVM.shared.getExcercise(completion: {categoryList,error  in
//                
//                if error == "No Internet Connection"{
//                    
//                }else{
//                    if categoryList.count == 0{
//                        KRProgressHUD.dismiss()
//                        
//                    }else{
//                        KRProgressHUD.dismiss()
//                        self.countryData=categoryList
//                        print("countryData\(self.countryData)")
//                        print("cooooo\(self.countryData[0].vpnname)")
//                        if UserDefaults.standard.string(forKey: "VPN_NAME") == nil {
//                            self.fasterServerLabel.text = self.countryData[0].vpnname
//                            self.flagIcon.sd_setImage(with: URL.init(string: self.countryData[0].vpn_flag))
//                            self.coordinates(forAddress: self.countryData[0].vpnname.firstWord()!) {
//                                (location) in
//                                guard let location = location else {
//                                    // Handle error here.
//                                    
//                                    return
//                                }
//                                self.openMapForPlace(lat: location.latitude, long: location.longitude)
//                            }
//                            self.profileVM.connection.setCustomConfigFile(url: self.countryData[0].file_location)
//                            
//                            
//                        }
//                    }
//                }
//            })
////        }else{
////            // fetchCategoryInDirectory(cell:cell)
////            KRProgressHUD.dismiss()
////        }
//        
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//       // getFirebaseTrackScreen(VPN_SCREEN)
//        //  CountrySelectionList.instanceHelper.itemdelegates = self
//        
//    }
//    
//    func createConnection(){
//        
//        setUIVisibilty(status: true)
//        setConnectionTimeVisibility(status:true)
//    }
//    
//    
//    
//    func setUIVisibilty(status:Bool){
//        
//        
//        locationSelectionButton.isHidden = status
//        fasterServerLabel.isHidden = status
//        flagIcon.isHidden = status
//        rightArrowLabel.isHidden = status
//        
//        flagIcon.isHidden = status
//        
//        
//    }
//    
//    
//    
//    @IBAction func menuActionButton(_ sender: UIButton) {
//        
//    }
//    
//    
//    func setConnectionTimeVisibility(status:Bool){
//        connectionTime.isHidden = status
//    }
//    func removeAnnotation(){
//        let allAnnotations = self.mapView.annotations
//        self.mapView.removeAnnotations(allAnnotations)
//    }
//    
//    @IBAction func locationListButtonAction(_ sender: Any) {
//      //  if ServiceHelper.sharedInstanceHelper.isConnectedToNetwork(){
//            selectedCountry = UserDefaults.standard.string(forKey: "VPN_NAME")
//            tblView.isHidden = false
//            locationSelectionButton.isHidden = true
//            rightArrowLabel.isHidden = true
//            fasterServerLabel.isHidden = true
//            flagIcon.isHidden = true
//            DispatchQueue.main.async {
//                self.tblView.reloadData()
//            }
//            
////        }else{
////            self.view.makeToast(kConstant.constants.kCheckInternet, point: CGPoint(x:view.center.x, y: view.frame.maxY - 70), title: "", image: nil, completion: nil)
////        }
//    }
//    
//    
//    
//    func countrySelection(countrySelection: String,fileLocation:String) {
//        fasterServerLabel.text = countrySelection
//        profileVM.connection.setCustomConfigFile(url: fileLocation)
//    }
//    
//    
//    
//    func vpnConnectedStatus(status: Bool) {
//        
//    }
//    
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("countryData.count\(countryData.count)")
//        return countryData.count
//        
//    }
//    
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell") as! CountryTableViewCell
//        cell.countryName.text = countryData[indexPath.row].vpnname
//        cell.countryFlagImage.sd_setImage(with: URL.init(string: countryData[indexPath.row].vpn_flag))
//        if selectedCountry == nil {
//            if indexPath.row == 0 {
//                cell.selectedButton.setImage(UIImage(named: "selected_icon"), for: .normal)
//            }
//        }
//        else if selectedCountry == countryData[indexPath.row].vpnname {
//            cell.selectedButton.setImage(UIImage(named: "selected_icon"), for: .normal)
//        }
//        else {
//            cell.selectedButton.setImage(UIImage(named: "unSelected_icon"), for: .normal)
//        }
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell") as! CountryTableViewCell
//        let countryData = countryData[indexPath.row]
//        connectLbl.text = "Connect"
//        lockImg.image = UIImage(named: "lock")
//        
//        ipProtectedLbl.text = "Your device’s IP is not protected"
//        profileVM.connection.stopVPN()
//        if connectedAnimationView != nil {
//            connectedAnimationView.removeFromSuperview()
//            
//        }
//        if loaderAnimationView != nil {
//            loaderAnimationView.removeFromSuperview()
//        }
//        startAnimation()
//        pauseTimer()
//        value = false
//        buttonSwitched = false
//        
//        fasterServerLabel.text = countryData.vpnname
//        flagIcon.sd_setImage(with: URL.init(string: countryData.vpn_flag))
//        profileVM.connection.setCustomConfigFile(url: countryData.file_location)
//        UserDefaults.standard.set(countryData.vpnname, forKey: "VPN_NAME")
//        UserDefaults.standard.set(countryData.vpnname.firstWord(), forKey: "VPN_NAME_FIRST")
//        UserDefaults.standard.set(countryData.vpn_flag, forKey: "FLAG")
//        cell.isSelected = true
//        UserDefaults.standard.set(countryData.file_location, forKey: "VPN_FILE")
//        tblView.isHidden = true
//        locationSelectionButton.isHidden = false
//        rightArrowLabel.isHidden = false
//        fasterServerLabel.isHidden = false
//        flagIcon.isHidden = false
//        removeAnnotation()
//        coordinates(forAddress:countryData.vpnname.firstWord()!) {
//            (location) in
//            guard let location = location else {
//                // Handle error here.
//                print("Errrrrrr\(location)")
//                return
//            }
//            self.openMapForPlace(lat: location.latitude, long: location.longitude)
//        }
//    }
//
//    
////    func showPurchaseAlert(fileLocation : String,cell : CountryTableViewCell,_ tableView: UITableView){
////        let alert = UIAlertController(title: "Alert!", message: "Don't wanna loose the access to VPN Premium?Subscribe Now!", preferredStyle: UIAlertController.Style.alert)
////
////        alert.addAction(UIAlertAction(title: "Ok",
////                                      style: UIAlertAction.Style.default,
////                                      handler: { [self](_: UIAlertAction!) in
////            cell.isSelected = false
////            tableView.reloadData()
////
////            self.dismiss(animated: true, completion: nil)
////            let goPremiumStoryBoard = UIStoryboard(name: kConstant.constants.kMain, bundle: nil).instantiateViewController(withIdentifier:kConstant.keyName.kPremiumVC) as! PurchaseVC
////
////            //   goPremiumStoryBoard.fromMoreTool = true
////            self.navigationController?.pushViewController(goPremiumStoryBoard, animated: true)
////            // self.navigationController?.popViewController(animated: false)
////        }))
////
////        alert.addAction(UIAlertAction(title: "Cancel",
////                                      style: UIAlertAction.Style.default,
////                                      handler: {(_: UIAlertAction!) in
////            cell.isSelected = false
////            tableView.reloadData()
////            self.dismiss(animated: true, completion: nil)
////        }))
////
////        self.present(alert, animated: true, completion: nil)
////    }
//}
//
//@available(iOS 13.0, *)
//extension VPNViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
//        renderer.strokeColor = UIColor(red: 1, green: 0.238, blue: 0.574, alpha: 1)
//        renderer.lineWidth = 5
//        renderer.alpha = 1
//        
//        return renderer
//        
//        
//    }
//    func removeOverlays() {
//        mapView.removeAnnotations(mapView.annotations)
//        mapView.removeOverlays(mapView.overlays)
//    }
//    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
//        UIView.animate(withDuration: 0.15, animations: {
//        }, completion: { [self] _ in
//            let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
//            pulseAnimation.duration = 0.5
//            pulseAnimation.fromValue = 1.0
//            pulseAnimation.toValue = 0.8
//            pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//            pulseAnimation.autoreverses = true
//            pulseAnimation.repeatCount = .greatestFiniteMagnitude
//            annotationView.layer.add(pulseAnimation, forKey: self.pulseAnimationUniqueIdentifier)
//            annotationView.image = UIImage(named: "Connected_2")
//        })
//        return annotationView
//    }
//    
//    
//}
//
//extension String {
//    func firstWord() -> String? {
//        return self.components(separatedBy: " ").first
//    }
//}
