//
//  MapperVC.swift
//  Q4U_VPNAPP
//
//  Created by Deepti Chawla on 23/04/21.
//

import UIKit


class MapperVC: UIViewController {
    var type = String()
    var value = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        CallBGAppLaunch.shared.v2CallOnBGLaunch(from: self)
    
        if (type != "" && value != "") {
            if type == "url"{
                launchAppWithMapper(type, value);
            }else if type == "deeplink" {
                handleValue(type, value);
            }else {
                self.dismiss(animated: true, completion: nil)
            }
        }else {
            self.dismiss(animated: true, completion: nil)
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SplashVC") as? SplashVC
            
            vc!.type = ""
            vc!.value = ""
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }

    func handleValue(_ type:String,_ value:String) {
        self.dismiss(animated: true, completion: nil)
        do {
            switch (value) {
            //Engine Mapping
            case LAUNCH_SPLASH:
  
                let vc = UIStoryboard.init(name: MyConstant.keyName.kMain, bundle: Bundle.main).instantiateViewController(withIdentifier: MyConstant.keyName.kSplashVC) as? SplashVC
                self.navigationController?.pushViewController(vc!, animated: true)
                break
                
            case gcmAppLaunch:
                
                let vc = UIStoryboard.init(name: MyConstant.keyName.kMain, bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC
                self.navigationController?.pushViewController(vc!, animated: true)
                
                break
                
            case gcmMoreApp:
                //Remember to add here your MoreAppClass.
                launchAppWithMapper(type,gcmMoreApp)
                break
                
            case gcmFeedbackApp:
                //Remember to add here your FeedbackClass.
                launchAppWithMapper(type,gcmFeedbackApp)
                break
                
            case gcmRateApp:
                //Remember to add here your RareAppClass.
                launchAppWithMapper(type,gcmRateApp)
                break
                
            case gcmShareApp:
                //Remember to add here your ShareAppClass.
                launchAppWithMapper(type, gcmShareApp)
                break
                
            case gcmRemoveAds:
                //Remember to add here your RemoveAdClass.
                launchAppWithMapper(type,gcmRemoveAds)
                break
                
            case gcmForceAppUpdate:
                launchAppWithMapper(type, gcmForceAppUpdate)
                break
            case MYPROJECTS:
                launchAppWithMapper(type, MYPROJECTS)
                break
            default:
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SplashVC") as? SplashVC
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            
        }
        catch{
            self.dismiss(animated: true, completion: nil)
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SplashVC") as? SplashVC
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    
    func launchAppWithMapper(_ type:String,_ value:String) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SplashVC") as? SplashVC
      
        vc!.type = type
        vc!.value = value
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}

