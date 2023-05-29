//
//  MyConstants.swift
//  WiFiProvider
//
//  Created by gautam  on 12/05/23.
//

import Foundation

class MyConstant {
    static let SPEED_LIST = "SPEED_LIST"
    static let PERMISSION_GRANTED = "PERMISSION_GRANTED"
    struct data {
//        let USER_TYPE = "USER_TYPE"
//        let USER_DATA = "USER_DATA"
//        let FCM_TOKEN = "FCM_TOKEN"
//        let REQVALUE = "REQ_VALUE"
//        public let DEVICE_TOKEN = "DEVICE_TOKEN"
//        public  let LAUNCH_COUNT = "LAUNCH_COUNT"
//        let VERSION_STATUS = "VERSION_STATUS"
//        let VERSION_DEFAULT = "VERSION_DEFAULT"
//        let SERVER_DEFAULT_VALUE = "SERVER_DEFAULT_VALUE"
//        let LOAD_DATA_POSITION = "LOAD_DATA_POSITION"
//        let MASTER_RESPONSE_VALUE = "MASTER_RESPONSE_VALUE"
//        let FULLAD_LOAD_DATA_POSITION = "FULLAD_LOAD_DATA_POSITION"
//        let CACHE_FULLAD = "CACHE_FULLAD"
//        let FULLSERVICECOUNT = "FULLSERVICECOUNT"
//        let NATIVE_LOAD_POSITION = "NATIVE_LOAD_POSITION"
//        let NATIVE_MEDIUM_LOAD_POSITION = "NATIVE_MEDIUM_LOAD_POSITION"
//        let OPEN_ADS_COUNT = "OPEN_ADS_COUNT"
       
        
        
        // Test Device ID
        let iPhone7 = "657ed368a47171a8ebda98978384406d"
        let iPhoneXR_DC = "d8ff501fc335b28d22df76f37526dade"
        let iPhone8 = "f5f195f8d959d0c6fec752b73a766e95"
        let iPhone7_PB = "8a256e315ac50be53f19441689b59d22"
        let iPhone7_OFFICE_2 = "103c041a2c1013042fc6c567c599c5d1"
        
    }

    // INAPP PURCHASE
    let SECRET_KEY = "de4d32f2d0bf48e6a168e9499c84b439"
    let kSandboxRecieptURL = "https://sandbox.itunes.apple.com/verifyReceipt"
    let kLiveRecieptURL = "https://buy.itunes.apple.com/verifyReceipt"

    public let WEEKLY_PURCHASED = "WEEKLY_PURCHASED"
    public let MONTHLY_PURCHASED = "MONTHLY_PURCHASED"
    public let YEARLY_PURCHASED = "YEARLY_PURCHASED"
    public let HALF_YEARLY_PURCHASED = "HALF_YEARLY_PURCHASED"
    public let QUATERLY_PURCHASED = "QUATERLY_PURCHASED"
    public let PRO_PURCHASED = "PRO_PURCHASED"
    public let FREE_PURCHASED = "FREE_PURCHASED"
    public let SUBS =  "SUBS"
    public let INAPP =  "INAPP"
    let APPLE_LANGUAGE = "AppleLanguage"
    public let ISFIRSTTIME = "ISFIRSTTIME"

     static let kAppName = "WifiProvider"
     static let ROUTER_IP = "ROUTER_IP"
    let kEnglish = "English"
    let kHindi = "Hindi"
    let kFrench = "French"
    let kGerman = "German"
    let kThai = "Thai"
    let kPortuguese = "Portuguese"
    let kSpanish = "Spanish"
    let kTurkish = "Turkish"
    let kItalian = "Italian"
    let kArabic = "Arabic"
    let kDutch = "Dutch"
    let kPrimaryLanguage = "Primary Language"
    let kBack = "Back"
    let kwantExit = "Do You want to Exit?"
    let kRelaunch = "Please Relaunch the app to see changes"
    let kExit = "Exit"
    let kExitApp = "Exit App"
    let kAlert = "Alert!"
    let kCancel = "Cancel"
    let kHi = "hi"
    let kDe = "de"
    let kFr  = "fr"
    let kEs = "es"
    let kIt = "it"
    let kTr = "tr"
    let kSa = "sa"
    let kAr = "ar"
    let kNl = "nl"
    let kPT = "pt-PT"
    let kTh  = "th"
    let kIN = "IN"
    let kUS = "US"
    let kPt = "pt"
    let kEn = "en"
    let kRelaunchApp = "kRelaunchApp"

    //MARK: Localisation Constants
    let NAME_KEY="NAME_KEY"
    let SELECTED="SELECTED"


    struct constants {
      
        static let kLangauage = "Change Language"
        static let kMain = "Main"
        static let kImageURL = "https://quantum4you.com/speedtest/assets/speedtest/test.gif"
        static let kUPLOADURL = "https://quantum4you.com/speedtest/assets/speedtest/test.gif"
        static let kFormat = "%.2f"
        static let kMBPS = "MB/s"
        static let kTitle = "title"
        static let kIcon = "icon"
        static let kRateUs = "Rate App"
        static let kMoreApps = "More Apps"
        static let kShareApp = "Share App"
        static let kFeedback = "Feedback"
        static let kAboutUs = "About us"
        static let kExitApp = "Exit App"
        static let kAlert = "Alert!"
        static let kCancel = "Cancel"
        static let kwantExit = "Do You want to Exit?"
        static let kYourStatus = "Your Status"
        static let kConnect = "Connect"
        static let kDisConnect = "Disconnect"
        static let kNotConnected = "Not Connected"
        static let kZeroKB = "0 KB"
        static let kHOSTURL = "https://backend.northghost.com"
        static let kCarrierID = "qua_q4u_vpn"
        static let kUltraVPNConnected = "Secure VPN CONNECTED"
        static let kUltraVPNDisConnected = "Secure VPN DISCONNECTED"
        static let kUpload = "Upload"
        static let kDownload = "Download"
        static let kVPN = "VPN"
        static let kSpeed = "Speed"
        static let kPremium = "Premium"
        static let kPleaseWait = "Please wait while we are processing your request"
        static let kDefault = "default"
        static let kExit = "Exit"
        static let kPrimaryLanguage = "Primary Language"
        static let kBack = "Back"
        static let kWithfreeVerison = "Connected with Free VPN"
        static let kDailyLimitOver = "Daily limit is over"
        static let kDelete = "Delete"
        static let kRelaunch = "Please Relaunch the app to see changes"
        static let kProServers = "Connected with Pro servers"
        // Localisation Constants
        static let kEnglish = "English"
        static let kHindi = "Hindi"
        static let kFrench = "French"
        static let kGerman = "German"
        static let kThai = "Thai"
        static let kPortuguese = "Portuguese"
        static let kSpanish = "Spanish"
        static let kTurkish = "Turkish"
        static let kItalian = "Italian"
        static let kArabic = "Arabic"
        static let kDutch = "Dutch"
        static let APPLE_LANGUAGE = "AppleLanguage"
        static let kCheckInternet = "Please check Internet Connection"
        static let kPerWeek = "Per week"
        static let kPerMonth = "Per month"
        static let kPerYear = "Per year"
        static let kFree = "free"
        static let kPro = "pro"
        static let kMonthly = "Monthly"
        static let kWeekly = "Weekly"
        static let kYearly = "Yearly"
        static let kNoInternet  = "No Internet Connection"
        static let kOK = "OK"
        static let kWantDisConnect = "Are you sure want to disconnect?"
        static let kCOnnectingVPN = "Connecting Country to"
    }
    
    
    struct keyName {
        static let kDashboard = "DashboardViewController"
        static let kSplashVC = "SplashVC"
        static let kConnectionVC = "ConnectionDetailVC"
        static let kMenuCell = "MenuCell"
        static let kCountryVC = "CountryVC"
        static let kCountryCell = "CountryTableViewCell"
        static let kMain = "Main"
        static let kMenuVC = "MenuVC"
        static let kPremiumCell = "PremiumCell"
        static let kVPNVC = "VPNViewController"
        static let kSpeedTestVC = "SpeedTestVC"
        static let kPremiumVC = "PurchaseVC"
        static let kTransparentFullAdLaunchVC = "TransparentFullAdLaunchVC"
        static let kAboutUs = "AboutUsVC"
        static let kLanguagesListVC = "LanguagesListVC"
        static let kLanguageCell = "LanguageCell1"
        static let kRelaunchApp = "Please Relaunch the app to see changes"
        static let kIdLanguageCell = "idLanguageCell"
        static let kOnboardVc = "OnboardVC"
    }
    
    struct imageName {
        static let kRateUs = "rate_us.png"
        static let kMoreApps = "more-apps.png"
        static let kShare = "share.png"
        static let kFeedback = "feedback.png"
        static let kAbout = "about.png"
        static let kExit = "exit.png"
        static let kRunningAnimation = "running_animation"
        static let kSplashAnimation  = "splash_animation"
        static let kConnected = "connected"
        static let kDisConnected = "disConnected"
        static let kVPNUnSelectedIcon = "vpn_unselected"
        static let kVPNSelectedIcon = "vpn_white"
        static let kSpeedTestUnselected  = "speedtest_unselected"
        static let kSpeedTestSelected  = "speed_selected"
        static let kPremiumUnSelected = "premium_unselected"
        static let kPremiumSelected = "premium_selected"
        static let kLanguage = "language"
        static let kShape = "Shape"
    }
    
    
    struct constant{
        static let kHOSTURL = "https://backend.northghost.com"
        //        static let kCarrierID = "qua_fastvpnios"
        // static let kFreeCarrierID = "qua_fastvpnios"
        //                static let kFreeCarrierID = "qua_q4u_vpn"
      //  static let kPaidCarrierID = "qua_fastvpn"
        static let kPaidCarrierID = "qua_iosfastvpn"
        static let VPNCONNECTED = "VPNCONNECTED"
        static let CONNECTION_START_TIME = "CONNECTION_START_TIME"
        static let kExtensionBundleID = "com.quantum4u.vpnApp.neprovider"
        static let kGroupID  = "group.com.quantum.whoisonmywifi.wifimap.wifiscan.wifidetector.wifihacker.password"
        static let kProfileName = "Secure VPN"
        static let kNotificationIdentifier =  "com.quantum4u.vpnApp.neprovider.CategorizatioProcessor.notificationRequestIdentifier"
        static let SECRET_KEY = "3be4b75210544d5db5c4822a6389ec58"
        static let kSandboxRecieptURL = "https://sandbox.itunes.apple.com/verifyReceipt"
        static let kLiveRecieptURL = "https://buy.itunes.apple.com/verifyReceipt"
    }
    
    struct  colors {
        static let kSkyColor = "#98ABFF"
    }
    
    struct  languageCode {
        static let kEn = "en"
        static let kHi = "hi"
        static let kDe = "de"
        static let kFr  = "fr"
        static let kEs = "es"
        static let kIt = "it"
        static let kTr = "tr"
        static let kSa = "sa"
        static let kAr = "ar"
        static let kNl = "nl"
        static let kPT = "pt-PT"
        static let kTh  = "th"
        static let kIN = "IN"
        static let kUS = "US"
        static let kPt = "pt"
    }

}

