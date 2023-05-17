//
//  SpeedTestVC.swift
//  WiFiProvider
//
//  Created by gautam  on 11/05/23.
//

import UIKit
import WMGaugeView
import Charts

class SpeedTestVC: UIViewController, UIDocumentInteractionControllerDelegate, SpeedCheckProtocol{
    func showChartData(show: Bool,data:[Double]) {
    // setChart(dataPoints: data, values:data)
    }
    
    func isSpeedCheckComplete(complete: Bool) {
        hideUnhideView(forRestView:false,forSpeedView:true,forBtn:true)
        
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
    @IBOutlet weak var uploadImg: UIImageView!
    @IBOutlet weak var downloadImg: UIImageView!
    @IBOutlet weak var ping: UILabel!
    @IBOutlet weak var connectionType: UILabel!
    @IBOutlet weak var ipAddress: UILabel!
    @IBOutlet weak var provideCompany: UILabel!
    @IBOutlet weak var retestView: UIView!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    var speedTestList  = [String:[SpeedTestData]]()
    @IBOutlet weak var speedChartView: LineChartView!
    var speedArray = [Double]()
    var uploadArray = [Double]()
    var speedMeterView: WMGaugeView?
    var speedTestVM = SpeedTestViewModel()
    var countinAPP = 0
    var countHydra = 0
    var timer:Timer?
    let  months = ["1.0", "2.0", "3.0", "4.0", "5.0"]
    private var pingSpeed: PingSpeed?
    override func viewDidLoad() {
        super.viewDidLoad()
        SpeedTestCompleteListener.instanceHelper.speedCheckDelegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideView))
                transView.addGestureRecognizer(tapGesture)
        setSpeedMeterUI()
       fetchFilms { [weak self] (pingSpeed) in
            self?.pingSpeed = pingSpeed
            
        }
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
    }
    
    
    
    @IBAction func beginTestAction(_ sender: Any) {
        speedChartView.isHidden = false
        topView.isHidden = false
        speedMeterView!.value = 0
        getNetworkSpeed()
        getIP()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        topView.isHidden = true
        speedMeterView!.value = 0
        startBtn.isHidden = false
        speedView.isHidden = false
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
        var counter = 0
        var counterArray = [Int]()
        SpeedTestViewModel.init().downloadSpeedTest(target: self, completion: { [self] speed ,uploadSpeed,status  in
            print("status\(status)")
            
                if speed > 0{
                    
                    changeImgBgColor(imageView: downloadImg,position: 1)
                    speedTestVM.downloadSpeed(downloadSpeed: speed, speedLabel: downloadSpeedLabel,speedMeterView:speedMeterView!,status: false)
                    speedArray.append(speed)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [self] in
                      
                        print("yourArray\(speedArray.count)")
                        self.setChart(dataPoints: self.months, values: speedArray)
                    }
                  
//
                }
                if uploadSpeed > 0{
                    changeImgBgColor(imageView: uploadImg,position: 2)
                    speedTestVM.downloadSpeed(downloadSpeed: uploadSpeed, speedLabel: uploadSpeedLabel,speedMeterView:speedMeterView!,status:status)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [self] in
                        uploadArray.append(uploadSpeed)
                        print("yourArray\(speedArray.count)")
                        self.setChart(dataPoints: self.months, values: uploadArray)
                        if #available(iOS 15, *) {
                            let today = Date.now
                            let formatter1 = DateFormatter()
                            formatter1.dateStyle = .short
                            print(formatter1.string(from: today))
                            speedTestList[formatter1.string(from: today)] = [SpeedTestData(time: "2:09", ping: 0.00, downloadSpeed: speedArray.last, uploadSpeed: uploadArray.last)]
                            UserDefaults.standard.set(speedTestList, forKey:MyConstant.SPEED_LIST)
                        } else {
                            // Fallback on earlier versions
                        }
                        
//                        MainSongList.instanceHelper.categoryDataList[category_id] = finalList
//                        if let encoded = try? JSONEncoder().encode(MainSongList.instanceHelper.categoryDataList) {
//
//                            userDefault.set(encoded, forKey:MyConstant.DOWNLOADED_LIST)
//                        }
                    }
            }
            
        })
       
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) { [self] in
//            let uploadDataArray =  Array(self.uploadArray.suffix(5))
//            print("yourArray\(uploadDataArray)")
//            if uploadArray != nil{
//                self.setUploadChart(dataPoints: self.months, values: uploadDataArray)
//            }
//        }
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
            ping.text = "IP : \(String(pingSpeed!.query))"
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
        var dataEntries: [ChartDataEntry] = []
        if dataPoints != nil{
            print("counts \(dataPoints.count)")
            for i in 0..<dataPoints.count {
                if i != 0{
                    let dataEntry = ChartDataEntry(x: Double(i), y: values[i], data: dataPoints[i] as AnyObject)
                    dataEntries.append(dataEntry)
                }
            }
        }
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "")
        chartDataSet.circleRadius = 0
        chartDataSet.circleHoleRadius = 0
        chartDataSet.drawValuesEnabled = false
        chartDataSet.setColor(hexStringColor(hex: "#38BEE9"))
     chartDataSet.mode = .cubicBezier
     chartDataSet.cubicIntensity = 0.2
     let gradientColors = [UIColor.cyan.cgColor, UIColor.clear.cgColor] as CFArray // Colors of the gradient
     let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
     let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Obj
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
    
    @IBAction func openSpeedHistory(_ sender:UIButton){
        let vc = storyboard?.instantiateViewController(withIdentifier: "SpeedHistoryVC") as! SpeedHistoryVC
        navigationController?.pushViewController(vc, animated: true)
    }
}

