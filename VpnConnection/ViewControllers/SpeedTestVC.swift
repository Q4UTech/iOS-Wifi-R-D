//
//  SpeedTestVC.swift
//  WiFiProvider
//
//  Created by gautam  on 11/05/23.
//

import UIKit
import WMGaugeView
import Charts
import PlainPing

class SpeedTestVC: UIViewController, UIDocumentInteractionControllerDelegate, SpeedCheckProtocol,LanguageSelectionDelegate{
    func languageSelection(name: String, code: String) {
        UserDefaults.standard.set(code, forKey: MyConstant.constant.APPLE_LANGUAGE)
        LanguageTimer.shared.startTimer(target: self)
    }
    func uploadFinished(isFinsihed: Bool,data:[Double]) {
//        let array =  Array(self.data.suffix(10))
//        setChart(dataPoints: months, values: array)
    }
    
    func downloadFinsihedFinished(isFinsihed: Bool,data:[Double]) {
//        let array =  Array(self.data.suffix(10))
       // setChart(dataPoints: months, values: array)
    }
    
    func isSpeedCheckComplete(complete: Bool, ping: String, upload: Double, download: Double) {
        print("ping11\(ping)")
        
//        let vc = storyboard?.instantiateViewController(withIdentifier: "SpeedTestDetailVC") as! SpeedTestDetailVC
//        vc.ping = ping
//        vc.uploadSpeed = upload
//        vc.downloadSpeed = download
//        navigationController?.pushViewController(vc, animated: true)
    }
    

    
    func showChartData(show: Bool,data:[Double]) {
        self.data = data
        for _ in data{
            upCounter += 1
            months.append(String(upCounter))
        }
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(showSpeedGraph),userInfo: true,repeats:true)
        showSpeedGraph()
//        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [self] timer in
//           showGraph(baseArray:months,data:data)
//
//        }
    }
    
 
    
    
    private func hideUnhideView(forRestView:Bool,forSpeedView:Bool,forBtn:Bool){
       // retestView.isHidden = forRestView
        speedView.isHidden = forSpeedView
        startBtn.isHidden = forBtn
    }
    
    var documentInteractionController = UIDocumentInteractionController()
    @IBOutlet weak var adView:UIView!
    @IBOutlet weak var heightConstraint:NSLayoutConstraint!
    @IBOutlet weak var transView:UIView!
    @IBOutlet weak var bottomSheet:UIView!
    @IBOutlet weak var speedView: UIView!
    @IBOutlet weak var downloadSpeedLabel: UILabel!
    @IBOutlet weak var uploadSpeedLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var uploadImg: UIImageView!
    @IBOutlet weak var downloadImg: UIImageView!
    @IBOutlet weak var ping: UILabel!
    @IBOutlet weak var connectionType: UILabel!
    @IBOutlet weak var ipAddress: UILabel!
    @IBOutlet weak var provideCompany: UILabel!
    @IBOutlet weak var retestView: UIView!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var mbpsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var speedTestList  = [String:[SpeedTestData]]()
    var speedDataList  = [SpeedTestData]()
    @IBOutlet weak var speedChartView: LineChartView!
    @IBOutlet weak var uploadChartView: LineChartView!
    var speedArray = [Double]()
    var uploadArray = [Double]()
    var data = [Double]()
    var speedMeterView: WMGaugeView?
    var speedTestVM = SpeedTestViewModel()
    var countinAPP = 0
    var countHydra = 0
    var pingData:String?
    var timer:Timer?
    var  months = ["1.0", "2.0", "3.0", "4.0", "5.0","6.0", "7.0", "8.0", "9.0", "10.0"]
  //  var  months = [String]()
    var downCounter = 0
    var upCounter = 0
    var isDownload:Bool = false
    private var pingSpeed: PingSpeed?
    override func viewDidLoad() {
        super.viewDidLoad()
        SpeedTestCompleteListener.instanceHelper.speedCheckDelegate = self
        LanguageSelectionListener.instanceHelper.itemdelegates = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideView))
                transView.addGestureRecognizer(tapGesture)
        setSpeedMeterUI()
       fetchFilms { [weak self] (pingSpeed) in
            self?.pingSpeed = pingSpeed
            
        }
        mbpsLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
    }
    

    func setSpeedMeterUI(){
        speedMeterView = WMGaugeView()
        speedMeterView!.frame = speedView.frame
        speedMeterView!.center = CGPoint(x: speedView.frame.size.width  / 2,
                                        y: speedView.frame.size.height / 2)
        speedView.addSubview(speedMeterView!)
        speedTestVM.setSpeedMeterValue(speedMeterView:speedMeterView!)
    }
    override func viewDidAppear(_ animated: Bool) {
        speedChartView.isHidden = true
        parentView.isHidden = true
    }
    
    @IBAction func openHistory(_ sender:UIButton){
        hideBottomSheet()
        let vc = storyboard?.instantiateViewController(withIdentifier: "SpeedHistoryVC") as! SpeedHistoryVC
        navigationController?.pushViewController(vc, animated: true)
        showFullAds(viewController: self, isForce: false)
    }
    
    
    @IBAction func openInApp(_ sender:UIButton){
        hideBottomSheet()
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PurchaseVC") as! PurchaseVC
        navigationController?.pushViewController(vc, animated: true)
        showFullAds(viewController: self, isForce: false)
        
    }
    
    @IBAction func openLanguageOption(_ sender:UIButton){
        hideBottomSheet()
        let vc = storyboard!.instantiateViewController(withIdentifier: "LanguageVC") as! LanguageVC
        navigationController?.pushViewController(vc, animated: true)
        showFullAds(viewController: self, isForce: false)
        
    }
    @IBAction func rateApp(_ sender:UIButton){
        hideBottomSheet()
        VpnConnection.rateApp(showCustom: true, self: self)
    
    }
    
    @IBAction func aboutUs(_ sender:UIButton){
        hideBottomSheet()
        let vc = UIStoryboard.init(name: "Engine", bundle: Bundle.main).instantiateViewController(withIdentifier:MyConstant.keyName.kAboutUs) as? AboutUsVC
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    @IBAction func moreApp(_ sender:UIButton){
        hideBottomSheet()
        moreAppurl()
        
    }
    @IBAction func shareApp(_ sender:UIButton){
        hideBottomSheet()
        shareAppsUrl(self,url:SHARE_URL,text:SHARE_TEXT)
        
    }
    @IBAction func feedback(_ sender:UIButton){
        hideBottomSheet()
        sendFeedback()
    }
    private func hideBottomSheet(){
        bottomSheet.isHidden = true
        transView.isHidden = true
     }
    
    @IBAction func beginTestAction(_ sender: Any) {
        uploadArray.removeAll()
        speedArray.removeAll()
        startBtn.isHidden = true
        speedChartView.isHidden = false
        parentView.isHidden = false
        topView.isHidden = false
        speedMeterView!.value = 0
        getNetworkSpeed()
        getIP()
        speedTestVM.setPingData(pingLabel: ping)
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getBannerAd(self, adView, heightConstraint)
        hideunhideLabel(true, true)
        SpeedTestCompleteListener.instanceHelper.speedCheckDelegate = self
        topView.isHidden = true
        speedMeterView!.value = 0
        startBtn.isHidden = false
        speedView.isHidden = false
        uploadChartView.isHidden = true
        speedChartView.isHidden = true
        speedChartView.data = nil

        speedChartView.xAxis.valueFormatter = nil
       // speedLabel.isHidden = true
        setSpeedTest()
    }
    
    
   private func setSpeedTest(){
        downloadSpeedLabel.text = MyConstant.constants.kZeroKB
        uploadSpeedLabel.text = MyConstant.constants.kZeroKB
    }
    
   private func getNetworkSpeed(){
        checkDownloadSpeed()
    }
    @IBAction func openMenu(_ sender:UIButton){
        hideUnhideMenuView(showTrans: false, showMenu: false)
    }
    
    @IBAction func reapperView(_ sender:UIButton){
        hideUnhideView(forRestView:true,forSpeedView:false,forBtn:false)
    }
    
    private func hideUnhideMenuView(showTrans:Bool,showMenu:Bool){
        transView.isHidden = showTrans
        bottomSheet.isHidden = showMenu
    }
    @objc func hideView() {
        hideUnhideMenuView(showTrans: true, showMenu: true)
       }
    func checkDownloadSpeed(){
       
        SpeedTestViewModel.init().downloadSpeedTest(target: self, completion: { [self] speed ,uploadSpeed,status  in
            print("status\(status)")
            
                if speed > 0{
                    isDownload = true
                    changeImgBgColor(imageView: downloadImg,position: 1)
                    speedTestVM.downloadSpeed(downloadSpeed: speed, speedLabel: downloadSpeedLabel,currentSpeedLabel: speedLabel ,speedMeterView:speedMeterView!,status: false)
                    speedArray.append(speed)
                   
                    for _ in speedArray{
                        downCounter += 1
                       // months.append(String(downCounter))
                    }
//                    timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(showGraph), userInfo: nil, repeats: true)
                  
                 
                  
                  

                }
                if uploadSpeed > 0{
                    changeImgBgColor(imageView: uploadImg,position: 2)
                    speedTestVM.downloadSpeed(downloadSpeed: uploadSpeed, speedLabel: uploadSpeedLabel,currentSpeedLabel: speedLabel,speedMeterView:speedMeterView!,status:status)
                    uploadArray.append(uploadSpeed)
            }
            
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { [self] in
            hideunhideLabel(false, false)
            let array =  Array(self.speedArray.suffix(10))
            //        setChart(dataPoints: months, values: array)
            print("yourArray\(speedArray.count)")
            if array.count == 10 {
                setChart(dataPoints: self.months, values: array)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) { [self] in
            speedChartView.isHidden = true
            uploadChartView.isHidden = false
           
//                        for _ in uploadArray{
//                            upCounter += 1
//                            months.append(String(upCounter))
//                        }
            print("yourArray\(uploadArray.count)")
            let array =  Array(self.uploadArray.suffix(10))
            if array.count == 10 {
                self.setUploadChart(dataPoints: self.months, values: array)
            }
           
            
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) { [self] in
//            let uploadDataArray =  Array(self.uploadArray.suffix(5))
//            print("yourArray\(uploadDataArray)")
//            if uploadArray != nil{
//                self.setUploadChart(dataPoints: self.months, values: uploadDataArray)
//            }
//        }
    }
    
    @objc func showGraph(baseArray:[String],data:[Double]){
        print("timer function called")
//        if isDownload{
           // self.setChart(dataPoints: baseArray, values: data)
           
//        }else{
//            
//        }
        
    }
     func showSpeedGraph(){
        print("timer function called")

           // self.setChart(dataPoints: months, values: data)
           

    }
    
    private func hideunhideLabel(_ isMbps:Bool,_ isTime:Bool){
        mbpsLabel.isHidden = isMbps
        timeLabel.isHidden = isTime
    }
    
    
    private func changeImgBgColor(imageView:UIImageView,position:Int){
        DispatchQueue.main.async {
            if position == 0{
                
            }else if position == 1{
                imageView.image = UIImage(named: "download_active")
            }else{
                imageView.image = UIImage(named: "upload_active")
            }
            
        }
        
    }
    
    
    func getIP(){
        if pingSpeed?.city != nil {
//            ping.text = String(pingSpeed!.query)
//            pingData = String(pingSpeed!.query)
            
            //ipadressLocation.text =  "Location :" + " " + films!.city
        }
    }
    func fetchFilms(completionHandler: @escaping (PingSpeed) -> Void) {
        let url = URL(string: "http://ip-api.com/json")!
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error with fetching films: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(response)")
                return
            }
            
            if let data = data,
               let filmSummary = try? JSONDecoder().decode(PingSpeed.self, from: data) {
                completionHandler(filmSummary)
            }
        })
        task.resume()
    }
    
 func setChart(dataPoints: [String], values: [Double]) {
     print("length99= \(dataPoints.count) \(values.count)")
        var dataEntries: [ChartDataEntry] = []
     if values != nil {
         if dataPoints != nil{
             print("counts \(dataPoints.count)")
             for i in 0..<dataPoints.count {
                 if i != nil{
                     let dataEntry = ChartDataEntry(x: Double(i), y: values[i], data: dataPoints[i] as AnyObject)
                     dataEntries.append(dataEntry)
                 }
             }
         }
     }
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "")
        chartDataSet.circleRadius = 0
        chartDataSet.circleHoleRadius = 0
        chartDataSet.drawValuesEnabled = false
    
         chartDataSet.setColor(hexStringColor(hex: "#3A89FF"))
     
     chartDataSet.mode = .cubicBezier
     chartDataSet.cubicIntensity = 0.2
     var gradientColors:CFArray? = nil
     gradientColors  = [hexStringColor(hex: "#3A89FF").cgColor, UIColor.clear.cgColor] as CFArray
     let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
     let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors!, locations: colorLocations) // Gradient Obj
         chartDataSet.fill = LinearGradientFill(gradient: gradient!)
     chartDataSet.drawFilledEnabled = true
    
        let chartData = LineChartData(dataSets: [chartDataSet])
    
     speedChartView.data = chartData

     speedChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
    // lineChartView.xAxis.labelPosition = .bottom
     speedChartView.rightAxis.enabled = false
     speedChartView.leftAxis.enabled = false
     speedChartView.xAxis.enabled = false
     speedChartView.rightAxis.enabled = false
     speedChartView.xAxis.drawGridLinesEnabled = false
     speedChartView.xAxis.avoidFirstLastClippingEnabled = true
//  speedChartView.data?.accessibilityPath?.fill()
     speedChartView.rightAxis.drawAxisLineEnabled = false
     speedChartView.rightAxis.drawLabelsEnabled = false
  speedChartView.animate(xAxisDuration: 0.4)
     speedChartView.leftAxis.drawAxisLineEnabled = false
     speedChartView.pinchZoomEnabled = false
     speedChartView.doubleTapToZoomEnabled = false
     speedChartView.legend.enabled = false
     speedChartView.isUserInteractionEnabled = false
     speedChartView.setScaleEnabled(false)
       
    }
    
    func setUploadChart(dataPoints: [String], values: [Double]) {
        print("length99= \(dataPoints.count) \(values.count)")
           var dataEntries: [ChartDataEntry] = []
        if values != nil && values.count > 0 {
            if dataPoints != nil{
                print("counts \(dataPoints.count)")
                for i in 0..<dataPoints.count {
                    if i != 0{
                        let dataEntry = ChartDataEntry(x: Double(i), y: values[i], data: dataPoints[i] as AnyObject)
                        dataEntries.append(dataEntry)
                    }
                }
            }
        }
           let chartDataSet = LineChartDataSet(entries: dataEntries, label: "")
           chartDataSet.circleRadius = 0
           chartDataSet.circleHoleRadius = 0
           chartDataSet.drawValuesEnabled = false
//        if isDownload{
//            chartDataSet.setColor(hexStringColor(hex: "#38BEE9"))
//        }else{
            chartDataSet.setColor(hexStringColor(hex: "#FFA620"))
       // }
        chartDataSet.mode = .cubicBezier
        chartDataSet.cubicIntensity = 0.2
        var gradientColors:CFArray? = nil
    
        gradientColors  = [hexStringColor(hex: "#FFA620").cgColor, UIColor.clear.cgColor] as CFArray
        // Colors of the gradient
        let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors!, locations: colorLocations) // Gradient Obj
            chartDataSet.fill = LinearGradientFill(gradient: gradient!)
        chartDataSet.drawFilledEnabled = true
       
           let chartData = LineChartData(dataSets: [chartDataSet])
       

         
        uploadChartView.data = chartData

     uploadChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
       // lineChartView.xAxis.labelPosition = .bottom
     uploadChartView.rightAxis.enabled = false
     uploadChartView.leftAxis.enabled = false
     uploadChartView.xAxis.enabled = false
     uploadChartView.rightAxis.enabled = false
     uploadChartView.xAxis.drawGridLinesEnabled = false
     uploadChartView.xAxis.avoidFirstLastClippingEnabled = true
   //  speedChartView.data?.accessibilityPath?.fill()
     uploadChartView.rightAxis.drawAxisLineEnabled = false
     uploadChartView.rightAxis.drawLabelsEnabled = false
     uploadChartView.animate(xAxisDuration: 0.4)
     uploadChartView.leftAxis.drawAxisLineEnabled = false
     uploadChartView.pinchZoomEnabled = false
     uploadChartView.doubleTapToZoomEnabled = false
     uploadChartView.legend.enabled = false
     uploadChartView.isUserInteractionEnabled = false
     uploadChartView.setScaleEnabled(false)
       DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
            let vc = storyboard?.instantiateViewController(withIdentifier: "SpeedTestDetailVC") as! SpeedTestDetailVC
                   vc.ping =  "10.0"
            vc.uploadSpeed = uploadArray.last!
            vc.downloadSpeed = speedArray.last!
           
                   navigationController?.pushViewController(vc, animated: true)
            showFullAds(viewController: self, isForce: false)
        }
       }
    
    @IBAction func openSpeedHistory(_ sender:UIButton){
        hideBottomSheet()
        let vc = storyboard?.instantiateViewController(withIdentifier: "SpeedHistoryVC") as! SpeedHistoryVC
        navigationController?.pushViewController(vc, animated: true)
        showFullAds(viewController: self, isForce: false)
    }
    
   
}

