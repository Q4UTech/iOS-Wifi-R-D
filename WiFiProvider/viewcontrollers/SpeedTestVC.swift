//
//  SpeedTestVC.swift
//  WiFiProvider
//
//  Created by gautam  on 11/05/23.
//

import UIKit
import WMGaugeView

class SpeedTestVC: UIViewController, UIDocumentInteractionControllerDelegate{
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
    var speedMeterView: WMGaugeView?
    var speedTestVM = SpeedTestViewModel()
    var countinAPP = 0
    var countHydra = 0
    private var pingSpeed: PingSpeed?
    override func viewDidLoad() {
        super.viewDidLoad()

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
       
    }
    
    
    @IBAction func beginTestAction(_ sender: Any) {
        speedMeterView!.value = 0
        getNetworkSpeed()
        getIP()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        speedMeterView!.value = 0
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
                    
                    changeImgBgColor(imageView: downloadImg,position: 1)
                    speedTestVM.downloadSpeed(downloadSpeed: speed, speedLabel: downloadSpeedLabel,speedMeterView:speedMeterView!,status: false)
                }
                if uploadSpeed > 0{
                    changeImgBgColor(imageView: uploadImg,position: 2)
                    speedTestVM.downloadSpeed(downloadSpeed: uploadSpeed, speedLabel: uploadSpeedLabel,speedMeterView:speedMeterView!,status:status)
                
            }
        })
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
}

