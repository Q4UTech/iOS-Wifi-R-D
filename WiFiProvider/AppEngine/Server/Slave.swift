//
//  Slave.swift
//  App Engine
//
//  Created by Quantum_MAC_7 on 17/03/20.
//  Copyright © 2020 Pulkit Babbar. All rights reserved.
//

import Foundation
import UIKit
import MessageUI


public var BILLING_DETAILS = [Billing]()

let  IS_NORMAL_UPDATE = "0"
let IS_FORCE_UPDATE = "1"

let IN_APP_PURCHASED = "In_App_Purchase"
let IN_APP_PURCHASED_FIRST = "In_App_Purchase_FIRST"

var ADMOB_FULLAD_ID = ""
var IRONSOURCE_FULLAD_ID = ""
var APPLOVIN_FULLAD_ID = ""
var ADMOB_BANNERHEADER_ID = ""
var IRONSOURCE_BANNERHEADER_ID = ""
var APPLOVIN_BANNERHEADER_ID = ""
var ADMOB_ADAPTIVE_BANNERHEADER_ID = ""
var ADMOB_BANNERRECTANGLE_ID = ""
var APPLOVIN_BANNERRECTANGLE_ID = ""
let ABMOB_NATIVEID = ""
var FB_BANNERHEADER_ID = ""
var FB_BANNERRECTANGLE_ID = ""

var FB_FULLAD_ID = ""

//Banner Ads
let Provider_Admob_Banner =  "Admob_Banner"
let Provider_Facebook_Banner =  "Facebook_Banner"
let Provider_Inhouse_Banner =  "Inhouse_Banner"
let Provider_Applovin_Banner =  "Applovin_Banner"
let Provider_Admob_Mediation_Banner =  "Admob_Mediation_Banner"
let Provider_IronSource =  "Inmobi_Banner"
let Provider_AppLovin = "Applovin_Banner"

//Fullads
let Provider_Admob_FullAds = "Admob_FullAds"
let Provider_Facebook_Full_Page_Ads = "Facebook_Full_Page_Ads"
let Provider_Inhouse_FullAds = "Inhouse_FullAds"
let Provider_IronSource_FullAds = "Inmobi_Full_Ads"
let Provider_AppLovin_FullAds = "Applovin_Full_Ads"
let provider_Admob_Mediation_Full_Ads = "Admob_Mediation_Full_Ads"

let NATIVE_TYPE_LARGE = "native_large"
let  NATIVE_TYPE_MEDIUM = "native_medium"

let  Provider_Admob_Native_Medium = "Admob_Native_Medium"
let Provider_Facebook_Native_Medium = "Facebook_Native_Medium"
let Provider_Inhouse_Medium = "Inhouse_Medium"
let Provider_AppLovin_Medium = "Applovin_Native_Medium"

let Provider_Admob_Native_Large = "Admob_Native_Large"
let Provider_Facebook_Native_Large = "Facebook_Native_Large"
let Provider_Inhouse_Large = "Inhouse_Large"

let Provider_Admob_Banner_Rectangle = "Admob_Banner_Rectangle"
let Provider_Facebook_Banner_Rectangle = "Facebook_Banner_Rectangle"
let Provider_Applovin_Banner_Rectangle = "Applovin_Banner_Rectangle"

//TOP BANNER
let TYPE_TOP_BANNER = "top_banner"
var TOP_BANNER_STARTDATE = ""
var TOP_BANNER_CLICKLINK = ""
var TOP_BANNER_nevigation = ""
var TOP_BANNER_call_native = ""
var TOP_BANNER_rateapptext = ""
var TOP_BANNER_rateurl = ""
var TOP_BANNER_email = ""
var TOP_BANNER_updateTYPE = ""
var TOP_BANNER_appurl = ""
var TOP_BANNER_prompttext = ""
var TOP_BANNER_version = ""
var TOP_BANNER_moreurl = ""
var TOP_BANNER_src = ""
var TOP_BANNER_providers =  [AdsProvider]()
var BOTTOM_BANNER_start_date = ""

//BOTTOM BANNER

let TYPE_BOTTOM_BANNER = "bottom_banner"
var BOTTOM_BANNER_STARTDATE = ""
var BOTTOM_BANNER_CLICKLINK = ""
var BOTTOM_BANNER_nevigation = ""
var BOTTOM_BANNER_call_native = ""
var BOTTOM_BANNER_rateapptext = ""
var BOTTOM_BANNER_rateurl = ""
var BOTTOM_BANNER_email = ""
var BOTTOM_BANNER_updateTYPE = ""
var BOTTOM_BANNER_appurl = ""
var BOTTOM_BANNER_prompttext = ""
var BOTTOM_BANNER_version = ""
var BOTTOM_BANNER_moreurl = ""
var BOTTOM_BANNER_src = ""
var BOTTOM_BANNER_providers =  [AdsProvider]()


//BANNER LARGE

let TYPE_BANNER_LARGE = "banner_large"
var LARGE_BANNER_clicklink = ""
var LARGE_BANNER_start_date = ""
var LARGE_BANNER_nevigation = ""
var LARGE_BANNER_call_native = ""
var LARGE_BANNER_rateapptext = ""
var LARGE_BANNER_rateurl = ""
var LARGE_BANNER_email = ""
var LARGE_BANNER_updateTYPE = ""
var LARGE_BANNER_appurl = ""
var LARGE_BANNER_prompttext = ""
var LARGE_BANNER_version = ""
var LARGE_BANNER_moreurl = ""
var LARGE_BANNER_src = ""
var LARGE_BANNER_providers =  [AdsProvider]()


// BANNER_RECTANGLE

let TYPE_BANNER_RECTANGLE = "banner_rectangle"
var RECTANGLE_BANNER_clicklink = ""
var RECTANGLE_BANNER_start_date = ""
var RECTANGLE_BANNER_nevigation = ""
var RECTANGLE_BANNER_call_native = ""
var RECTANGLE_BANNER_rateapptext = ""
var RECTANGLE_BANNER_rateurl = ""
var RECTANGLE_BANNER_email = ""
var RECTANGLE_BANNER_updateTYPE = ""
var RECTANGLE_BANNER_appurl = ""
var RECTANGLE_BANNER_prompttext = ""
var RECTANGLE_BANNER_version = ""
var RECTANGLE_BANNER_moreurl = ""
var RECTANGLE_BANNER_src = ""
var RECTANGLE_BANNER_providers =  [AdsProvider]()


// FULL_ADS

let TYPE_FULL_ADS = "full_ads"
var FULL_ADS_clicklink = ""
var FULL_ADS_start_date = ""
var FULL_ADS_nevigation = ""
var FULL_ADS_call_native = ""
var FULL_ADS_rateapptext = ""
var FULL_ADS_rateurl = ""
var FULL_ADS_email = ""
var FULL_ADS_updateTYPE = ""
var FULL_ADS_appurl = ""
var FULL_ADS_prompttext = ""
var FULL_ADS_version = ""
var FULL_ADS_moreurl = ""
var FULL_ADS_src = ""
var FULL_ADS_providers =  [AdsProvider]()

// LAUNCH_FULL_ADS
let TYPE_LAUNCH_FULL_ADS = "launch_full_ads"
var LAUNCH_FULL_ADS_clicklink = ""
var LAUNCH_FULL_ADS_start_date = ""
var LAUNCH_FULL_ADS_nevigation = ""
var LAUNCH_FULL_ADS_call_native = ""
var LAUNCH_FULL_ADS_rateapptext = ""
var LAUNCH_FULL_ADS_rateurl = ""
var LAUNCH_FULL_ADS_email = ""
var LAUNCH_FULL_ADS_updateTYPE = ""
var LAUNCH_FULL_ADS_appurl = ""
var LAUNCH_FULL_ADS_prompttext = ""
var LAUNCH_FULL_ADS_version = ""
var LAUNCH_FULL_ADS_moreurl = ""
var LAUNCH_FULL_ADS_src = ""
var LAUNCH_FULL_ADS_providers =  [AdsProvider]()


// EXIT_FULL_ADS
let TYPE_EXIT_FULL_ADS = "exit_full_ads"
var EXIT_FULL_ADS_clicklink = ""
var EXIT_FULL_ADS_start_date = ""
var EXIT_FULL_ADS_nevigation = ""
var EXIT_FULL_ADS_call_native = ""
var EXIT_FULL_ADS_rateapptext = ""
var EXIT_FULL_ADS_rateurl = ""
var EXIT_FULL_ADS_email = ""
var EXIT_FULL_ADS_updateTYPE = ""
var EXIT_FULL_ADS_appurl = ""
var EXIT_FULL_ADS_prompttext = ""
var EXIT_FULL_ADS_version = ""
var EXIT_FULL_ADS_moreurl = ""
var EXIT_FULL_ADS_src = ""
var EXIT_SHOW_AD_ON_EXIT_PROMPT = ""
var EXIT_SHOW_NATIVE_AD_ON_EXIT_PROMPT = ""
var EXIT_FULL_ADS_providers =  [AdsProvider]()

//TYPE NATIVE MEDIUM

let TYPE_NATIVE_MEDIUM = "native_medium"
var NATIVE_MEDIUM_clicklink = ""
var NATIVE_MEDIUM_start_date = ""
var NATIVE_MEDIUM_nevigation = ""
var NATIVE_MEDIUM_call_native = ""
var NATIVE_MEDIUM_rateapptext = ""
var NATIVE_MEDIUM_rateurl = ""
var NATIVE_MEDIUM_email = ""
var NATIVE_MEDIUM_updateTYPE = ""
var NATIVE_MEDIUM_appurl = ""
var NATIVE_MEDIUM_prompttext = ""
var NATIVE_MEDIUM_version = ""
var NATIVE_MEDIUM_moreurl = ""
var NATIVE_MEDIUM_src = ""
var NATIVE_MEDIUM_providers = [AdsProvider]()


//TYPE NATIVE LARGE

let TYPE_NATIVE_LARGE = "native_large"
var NATIVE_LARGE_clicklink = ""
var NATIVE_LARGE_start_date = ""
var NATIVE_LARGE_nevigation = ""
var NATIVE_LARGE_call_native = ""
var NATIVE_LARGE_rateapptext = ""
var NATIVE_LARGE_rateurl = ""
var NATIVE_LARGE_email = ""
var NATIVE_LARGE_updateTYPE = ""
var NATIVE_LARGE_appurl = ""
var NATIVE_LARGE_prompttext = ""
var NATIVE_LARGE_version = ""
var NATIVE_LARGE_moreurl = ""
var NATIVE_LARGE_src = ""
var NATIVE_LARGE_providers = [AdsProvider]()


//Type RATE APP

let TYPE_RATE_APP = "rateapp"
var RATE_APP_ad_id = ""
var RATE_APP_provider_id = ""
var RATE_APP_clicklink = ""
var RATE_APP_start_date = ""
var RATE_APP_nevigation = ""
var RATE_APP_call_native = ""
var RATE_APP_rateapptext = ""
var RATE_APP_rateurl = ""
var RATE_APP_email = ""
var RATE_APP_updateTYPE = ""
var RATE_APP_appurl = ""
var RATE_APP_prompttext = ""
var RATE_APP_version = ""
var RATE_APP_moreurl = ""
var RATE_APP_src = ""
var RATE_APP_BG_COLOR = ""
var RATE_APP_HEADER_TEXT = ""
var RATE_APP_TEXT_COLOR = ""


//TYPE_FEEDBACK

let TYPE_FEEDBACK = "feedback"
var FEEDBACK_ad_id = ""
var FEEDBACK_provider_id = ""
var FEEDBACK_clicklink = ""
var FEEDBACK_start_date = ""
var FEEDBACK_nevigation = ""
var FEEDBACK_call_native = ""
var FEEDBACK_rateapptext = ""
var FEEDBACK_rateurl = ""
var FEEDBACK_email = ""
var FEEDBACK_updateTYPE = ""
var FEEDBACK_appurl = ""
var FEEDBACK_prompttext = ""
var FEEDBACK_version = ""
var FEEDBACK_moreurl = ""


//TYPE_UPDATES
let TYPE_UPDATES = "updates"
var UPDATES_ad_id = ""
var UPDATES_provider_id = ""
var UPDATES_clicklink = ""
var UPDATES_start_date = ""
var UPDATES_nevigation = ""
var UPDATES_call_native = ""
var UPDATES_rateapptext = ""
var UPDATES_rateurl = ""
var UPDATES_email = ""
var UPDATES_updateTYPE = ""
var UPDATES_appurl = ""
var UPDATES_prompttext = ""
var UPDATES_version = ""
var UPDATES_moreurl = ""

//TYPE_MORE_APPS
let TYPE_MORE_APPS = "moreapp"
var MOREAPP_ad_id = ""
var MOREAPP_provider_id = ""
var MOREAPP_clicklink = ""
var MOREAPP_start_date = ""
var MOREAPP_nevigation = ""
var MOREAPP_call_native = ""
var MOREAPP_rateapptext = ""
var MOREAPP_rateurl = ""
var MOREAPP_email = ""
var MOREAPP_updateTYPE = ""
var MOREAPP_appurl = ""
var MOREAPP_prompttext = ""
var MOREAPP_version = ""
var MOREAPP_moreurl = ""


// TYPE_ETC
let TYPE_ETC = "etc"
var ETC_1 = ""
var ETC_2 = ""
var ETC_3 = ""
var ETC_4 = ""
var ETC_5 = ""

//TYPE_SHARE
let TYPE_SHARE = "shareapp"
public var SHARE_TEXT = ""
public var SHARE_URL = ""

//TYPE_ADMOB_STATIC
let TYPE_ADMOB_STATIC = "admob_static"
var ADMOB_NATIVE_MEDIUM_ID_STATIC = ""
var ADMOB_BANNER_ID_STATIC = ""
var ADMOB_FULL_ID_STATIC = ""
var ADMOB_NATIVE_LARGE_ID_STATIC = ""
var ADMOB_BANNER_ID_LARGE_STATIC = ""
var ADMOB_BANNER_ID_RECTANGLE_STATIC = ""


//TYPE_REMOVE_ADS
let TYPE_REMOVE_ADS = "removeads"
var REMOVE_ADS_DESCRIPTION = ""
var REMOVE_ADS_BGCOLOR = ""
var REMOVE_ADS_TEXTCOLOR = ""




//TYPE_ABOUT_DETAILS
let TYPE_ABOUT_DETAILS = "aboutdetails"
var ABOUTDETAIL_DESCRIPTION = ""
var ABOUTDETAIL_OURAPP = ""
var ABOUTDETAIL_WEBSITELINK = ""
public var ABOUTDETAIL_PRIVACYPOLICY = ""
public var ABOUTDETAIL_TERM_AND_COND = ""
var ABOUTDETAIL_FACEBOOK = ""
var ABOUTDETAIL_INSTA = ""
var ABOUTDETAIL_TWITTER = ""
var ABOUTDETAIL_FAQ = ""


//TYPE_EXIT_NON_REPEAT

let TYPE_EXIT_NON_REPEAT = "exitnonrepeat"
var EXIT_NON_REPEAT_COUNT = [NonRepeatCount]()


//TYPE_EXIT_REPEAT
let TYPE_EXIT_REPEAT = "exitrepeat"
var EXIT_REPEAT_RATE = ""
var EXIT_REPEAT_EXIT = ""
var EXIT_REPEAT_FULL_ADS = ""
var EXIT_REPEAT_REMOVEADS = ""


//TYPE_LAUNCH_NON_REPEAT
let TYPE_LAUNCH_NON_REPEAT = "launch_nonrepeat"
var LAUNCH_NON_REPEAT_COUNT = [LaunchNonRepeatCount]()


//TYPE_LAUNCH_REPEAT
let TYPE_LAUNCH_REPEAT = "launch_repeat"
var LAUNCH_REPEAT_RATE = ""
var LAUNCH_REPEAT_EXIT = ""
var LAUNCH_REPEAT_FULL_ADS = ""
var LAUNCH_REPEAT_REMOVEADS = ""


//TYPE_INAPP_BILLING
let TYPE_INAPP_BILLING = "inapp_billing"
var INAPP_PUBLIC_KEY = ""

public var Billing_Free = "free";
public var Billing_Pro = "pro";
public var Billing_Weekly = "weekly";
public var Billing_Monthly = "monthly";
public var Billing_Quarterly = "quarterly";
public var Billing_HalfYear = "halfYear";
public var Billing_Yearly = "yearly";


public var  IS_PRO = false, IS_WEEKLY = false, IS_MONTHLY = false, IS_QUARTERLY = false, IS_HALFYEARLY = false, IS_YEARLY = false,IS_FREE = false

func showSharePrompt(_ self:UIViewController,url:String,text:String){
    let alert = UIAlertController(title: "Invite!", message: "To share files, both two devices must have the SHAREall app installed on it. By tapping on \"Send Link\" you can invite your friends to use SHAREall.", preferredStyle: UIAlertController.Style.alert)
    
    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
        self.dismiss(animated: true, completion: nil)
    }))
    alert.addAction(UIAlertAction(title: "Send Link",
                                  style: UIAlertAction.Style.default,
                                  handler: {(_: UIAlertAction!) in
        //Sign out action
        
        shareAppsUrl(self,url:url, text:text)
        
        
        
    }))
    self.present(alert, animated: true, completion: nil)
}


func showFeedbackPrompt(_ self:UIViewController){
    let alert = UIAlertController(title: "Alert!", message: "Send Feedback", preferredStyle: UIAlertController.Style.alert)
    
    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
        self.dismiss(animated: true, completion: nil)
    }))
    alert.addAction(UIAlertAction(title: "ok",
                                  style: UIAlertAction.Style.default,
                                  handler: {(_: UIAlertAction!) in
        //Sign out action
        
        self.sendFeedback()
        
        
        
    }))
    self.present(alert, animated: true, completion: nil)
}


func checkForceUpdatePrompt(_ self:UIViewController){
    let alert = UIAlertController(title: "Alert!", message: "Check Force Update", preferredStyle: UIAlertController.Style.alert)
    
    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
        self.dismiss(animated: true, completion: nil)
    }))
    alert.addAction(UIAlertAction(title: "ok",
                                  style: UIAlertAction.Style.default,
                                  handler: {(_: UIAlertAction!) in
        //Sign out action
        checkForForceUpdates(self)
        
        
        
        
    }))
    self.present(alert, animated: true, completion: nil)
}

public func shareAppsUrl(_ self:UIViewController,url:String,text:String){
    var sharingItems = [Any]()
    sharingItems.append(text)
    sharingItems.append(url)
    let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
    activityViewController.completionWithItemsHandler = { (activityType, isSuccess, arrAny, error) in
        
    }
        if let avc = activityViewController.popoverPresentationController {
            avc.sourceView = self.view
            avc.sourceRect = CGRect(x: self.view.bounds.minX + self.view.frame.width/2, y: self.view.bounds.minY,width: 0,height: 0)
            
        }
    self.present(activityViewController, animated: true, completion: nil)
    
}



func socialShare(sender: UIViewController, sView: UIView, sharingText: String?, sharingImage: UIImage?, sharingURL: String? = nil, completion: ((UIActivity.ActivityType?, Bool, [Any]?, Error?) -> ())? = nil) {
    var sharingItems = [Any]()
    
    if let text = sharingText {
        sharingItems.append(text)
    }
    if let image = sharingImage {
        sharingItems.append(image)
    }
    if let url = sharingURL {
        sharingItems.append(url)
    }
    let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
    activityViewController.completionWithItemsHandler = { (activityType, isSuccess, arrAny, error) in
        completion?(activityType, isSuccess, arrAny, error)
    }
    if let avc = activityViewController.popoverPresentationController {
        avc.sourceView = sView
    }
    sender.present(activityViewController, animated: true, completion: nil)
}

public func moreAppurl(){
    
    let moreurl = NSURL(string:MOREAPP_moreurl)! as URL
    UIApplication.shared.open(moreurl, options: [:], completionHandler: nil)
    
}

extension UIViewController : MFMailComposeViewControllerDelegate {
    
    func configuredMailComposeViewController(recipients : [String]?, subject :
                                             String, body : String, isHtml : Bool = false,
                                             images : [UIImage]?) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // IMPORTANT
        
        mailComposerVC.setToRecipients(recipients)
        mailComposerVC.setSubject(subject)
        mailComposerVC.setMessageBody(body, isHTML: isHtml)
        
        return mailComposerVC
    }
    
    
    public func sendFeedback(){
        let toRecipients = [FEEDBACK_email]
        let subject = "Feedback"
        let body = "\(MyConstant.kAppName) <br>Device Brand: \(String().getDeviceModel())<br>DeviceName: \(String().getDeviceName()) <br>Device Version: \(UIDevice.current.systemVersion)"
        let mail = configuredMailComposeViewController(recipients: toRecipients, subject: subject, body: body, isHtml: true, images: nil)
        presentMailComposeViewController(mailComposeViewController: mail)
    }
    
    
    func presentMailComposeViewController(mailComposeViewController :
                                          MFMailComposeViewController) {
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController,
                         animated: true, completion: nil)
        } else {
            let sendMailErrorAlert = UIAlertController.init(title: "Error",
                                                            message: "Unable to send email. Please check your email " +
                                                            "settings and try again.", preferredStyle: .alert)
            sendMailErrorAlert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: { _ in
                
                
            }))
            //Sign out action
            
            self.present(sendMailErrorAlert, animated: true,
                         completion: nil)
        }
    }
    
    public func mailComposeController(controller: MFMailComposeViewController,
                                      didFinishWith result: MFMailComposeResult,
                                      error: Error?) {
        switch (result) {
        case .cancelled:
            self.dismiss(animated: true, completion: nil)
        case .sent:
            self.dismiss(animated: true, completion: nil)
        case .failed:
            self.dismiss(animated: true, completion: {
                let sendMailErrorAlert = UIAlertController.init(title: "Failed",
                                                                message: "Unable to send email. Please check your email " +
                                                                "settings and try again.", preferredStyle: .alert)
                sendMailErrorAlert.addAction(UIAlertAction.init(title: "OK",
                                                                style: .default, handler: nil))
                self.present(sendMailErrorAlert,
                             animated: true, completion: nil)
            })
        default:
            break;
        }
    }
    
    func versionText () -> String {
        let bundleVersionKey = "CFBundleShortVersionString"
        let buildVersionKey = "CFBundleVersion"
        
        if let version = Bundle.main.object(forInfoDictionaryKey: bundleVersionKey) {
            if let build = Bundle.main.object(forInfoDictionaryKey: buildVersionKey) {
                let version = "Version \(version) - Build \(build)"
                return version
            }
        }
        
        return ""
    }
}



func checkForNormalUpdates(_ self:UIViewController){
    
    if (UPDATES_updateTYPE == IS_NORMAL_UPDATE) {
        
        if String().getAppVersionInfo() != UPDATES_version {
            openNormalupdateAlert(self,UPDATES_prompttext, false);
        }
    }
    
}


func checkForForceUpdates(_ self:UIViewController){
    
    if (UPDATES_updateTYPE == IS_FORCE_UPDATE) {
        
        if String().getAppVersionInfo() != UPDATES_version {
            openNormalupdateAlert(self,UPDATES_prompttext, true);
        }
    }
    
}


func openNormalupdateAlert(_ self: UIViewController,_ updatePromptText: String,_ is_force:Bool){
    let alert = UIAlertController(title: "Update App", message: "", preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "UPDATE NOW", style: .default, handler: { action in
        UIApplication.shared.open(URL(string: "\(UPDATES_appurl)")!)
        if is_force{
            self.dismiss(animated: true, completion: nil)
        }
    }))
    
    alert.addAction(UIAlertAction(title: "NO THANKS!", style: .cancel, handler:{ action in
        
        if is_force {
            self.dismiss(animated: true, completion: nil)
        }
    }))
    self.present(alert, animated: true)
}


public func hasPurchased() -> Bool  {
    
    return UserDefaults.standard.bool(forKey: WEEKLY_PURCHASED) || UserDefaults.standard.bool(forKey: MONTHLY_PURCHASED) || UserDefaults.standard.bool(forKey: QUATERLY_PURCHASED) || UserDefaults.standard.bool(forKey: HALF_YEARLY_PURCHASED) || UserDefaults.standard.bool(forKey: HALF_YEARLY_PURCHASED) || UserDefaults.standard.bool(forKey: YEARLY_PURCHASED) ||
    UserDefaults.standard.bool(forKey: PRO_PURCHASED)
    
}

public  func hasPurchasedWeekly()   -> Bool{
    return UserDefaults.standard.bool(forKey: WEEKLY_PURCHASED)
}

public  func hasPurchasedMonthly() -> Bool{
    
    return UserDefaults.standard.bool(forKey: MONTHLY_PURCHASED)
}

public func hasPurchasedQuarterly() -> Bool{
    
    return UserDefaults.standard.bool(forKey: QUATERLY_PURCHASED)
}

public func  hasPurchasedHalfYearly()-> Bool {
    
    return UserDefaults.standard.bool(forKey: HALF_YEARLY_PURCHASED)
}

public  func  hasPurchasedYearly() -> Bool{
    
    return UserDefaults.standard.bool(forKey: YEARLY_PURCHASED)
}

public func  hasPurchasedPro() -> Bool{
    
    return UserDefaults.standard.bool(forKey: PRO_PURCHASED)
}



