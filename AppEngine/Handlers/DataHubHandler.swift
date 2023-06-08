//
//  DataHubHandler.swift
//  App Engine
//
//  Created by Quantum_MAC_7 on 17/03/20.
//  Copyright © 2020 Pulkit Babbar. All rights reserved.
//

import Foundation
import UIKit


var dataArray = [AdsResponse]()
var InHousedataArray = Inhouse()
var typeArray = String()

func parseDecryptMasterData(_ response: [String:Any],_ fetchFromServer:Bool){

    print("MasterResponse:\(response)")
    print("version_request5")
    if response.description.count>100 {
        print("version_request6\(response)")
        if let adresponses = response.validatedValue("adsresponse", expected: [[String:Any]]() as AnyObject) as? [[String:Any]] {

            print("version_request7")
            let obj = AdsResponse()
            dataArray = obj.getAdsResponseData(dataArray: adresponses)
            print("version_request8")
            if adresponses.count>0{
                print("version_request9")
                loadSlaveAdResponse(dataArray,fetchFromServer)
            }
        }
    }
    
}


func loadSlaveAdResponse(_ adresponselist:[AdsResponse],_ fetchFromServer:Bool){
    DispatchQueue.global(qos: .background).async {
        
    
    for i in 0..<adresponselist.count {
        
        print("Navigation:\(adresponselist[i].navigation)")
        if adresponselist[i].type == TYPE_TOP_BANNER {
            print("InfoStartDate:\(adresponselist[i].startdate)")
            
            TOP_BANNER_CLICKLINK = adresponselist[i].clicklink
            TOP_BANNER_STARTDATE = adresponselist[i].startdate
            TOP_BANNER_nevigation = adresponselist[i].navigation
            TOP_BANNER_call_native = adresponselist[i].call_native
            TOP_BANNER_rateapptext = adresponselist[i].rateapptext
            TOP_BANNER_rateurl = adresponselist[i].rateurl
            TOP_BANNER_updateTYPE = adresponselist[i].updatetype
            TOP_BANNER_email = adresponselist[i].email
            TOP_BANNER_appurl = adresponselist[i].appurl
            TOP_BANNER_prompttext = adresponselist[i].promptText
            TOP_BANNER_version = adresponselist[i].version
            TOP_BANNER_moreurl = adresponselist[i].moreurl
            TOP_BANNER_src = adresponselist[i].src
            TOP_BANNER_providers = adresponselist[i].adsprovider
        }
        else if adresponselist[i].type == TYPE_BOTTOM_BANNER {
            print( "BOTTOMBANNER:\(adresponselist[i].startdate)")
            BOTTOM_BANNER_CLICKLINK = adresponselist[i].clicklink
            BOTTOM_BANNER_STARTDATE = adresponselist[i].startdate
            BOTTOM_BANNER_nevigation = adresponselist[i].navigation
            BOTTOM_BANNER_call_native = adresponselist[i].call_native
            BOTTOM_BANNER_rateapptext = adresponselist[i].rateapptext
            BOTTOM_BANNER_rateurl = adresponselist[i].rateurl
            BOTTOM_BANNER_updateTYPE = adresponselist[i].updatetype
            BOTTOM_BANNER_email = adresponselist[i].email
            BOTTOM_BANNER_appurl = adresponselist[i].appurl
            BOTTOM_BANNER_prompttext = adresponselist[i].promptText
            BOTTOM_BANNER_version = adresponselist[i].version
            BOTTOM_BANNER_moreurl = adresponselist[i].moreurl
            BOTTOM_BANNER_src = adresponselist[i].src
            BOTTOM_BANNER_providers = adresponselist[i].adsprovider

        }
        else if adresponselist[i].type == TYPE_BANNER_LARGE {
            LARGE_BANNER_clicklink = adresponselist[i].clicklink
            LARGE_BANNER_start_date = adresponselist[i].startdate
            LARGE_BANNER_nevigation = adresponselist[i].navigation
            LARGE_BANNER_call_native = adresponselist[i].call_native
            LARGE_BANNER_rateapptext = adresponselist[i].rateapptext
            LARGE_BANNER_rateurl = adresponselist[i].rateurl
            LARGE_BANNER_updateTYPE = adresponselist[i].updatetype
            LARGE_BANNER_email = adresponselist[i].email
            LARGE_BANNER_appurl = adresponselist[i].appurl
            LARGE_BANNER_prompttext = adresponselist[i].promptText
            LARGE_BANNER_version = adresponselist[i].version
            LARGE_BANNER_moreurl = adresponselist[i].moreurl
            LARGE_BANNER_src = adresponselist[i].src
            LARGE_BANNER_providers = adresponselist[i].adsprovider
        }
        else if adresponselist[i].type == TYPE_BANNER_RECTANGLE {
            RECTANGLE_BANNER_clicklink = adresponselist[i].clicklink
            RECTANGLE_BANNER_start_date = adresponselist[i].startdate
            RECTANGLE_BANNER_nevigation = adresponselist[i].navigation
            RECTANGLE_BANNER_call_native = adresponselist[i].call_native
            RECTANGLE_BANNER_rateapptext = adresponselist[i].rateapptext
            RECTANGLE_BANNER_rateurl = adresponselist[i].rateurl
            RECTANGLE_BANNER_updateTYPE = adresponselist[i].updatetype
            RECTANGLE_BANNER_email = adresponselist[i].email
            RECTANGLE_BANNER_appurl = adresponselist[i].appurl
            RECTANGLE_BANNER_prompttext = adresponselist[i].promptText
            RECTANGLE_BANNER_version = adresponselist[i].version
            RECTANGLE_BANNER_moreurl = adresponselist[i].moreurl
            RECTANGLE_BANNER_src = adresponselist[i].src
            RECTANGLE_BANNER_providers = adresponselist[i].adsprovider
        }
        else if adresponselist[i].type == TYPE_FULL_ADS {
            FULL_ADS_clicklink = adresponselist[i].clicklink
            FULL_ADS_start_date = adresponselist[i].startdate
            FULL_ADS_nevigation = adresponselist[i].navigation
            FULL_ADS_call_native = adresponselist[i].call_native
            FULL_ADS_rateapptext = adresponselist[i].rateapptext
            FULL_ADS_appurl = adresponselist[i].rateurl
            FULL_ADS_updateTYPE = adresponselist[i].updatetype
            FULL_ADS_email = adresponselist[i].email
            FULL_ADS_appurl = adresponselist[i].appurl
            FULL_ADS_prompttext = adresponselist[i].promptText
            FULL_ADS_version = adresponselist[i].version
            FULL_ADS_moreurl = adresponselist[i].moreurl
            FULL_ADS_src = adresponselist[i].src
            FULL_ADS_providers = adresponselist[i].adsprovider
        }
        
        else if adresponselist[i].type == TYPE_LAUNCH_FULL_ADS {
            print("fetchFromServer\(fetchFromServer)")
//            if !fetchFromServer{
                LAUNCH_FULL_ADS_clicklink = adresponselist[i].clicklink
                LAUNCH_FULL_ADS_start_date = adresponselist[i].startdate
                LAUNCH_FULL_ADS_nevigation = adresponselist[i].navigation
                LAUNCH_FULL_ADS_call_native = adresponselist[i].call_native
                LAUNCH_FULL_ADS_rateapptext = adresponselist[i].rateapptext
                LAUNCH_FULL_ADS_rateurl = adresponselist[i].rateurl
                LAUNCH_FULL_ADS_updateTYPE = adresponselist[i].updatetype
                LAUNCH_FULL_ADS_email = adresponselist[i].email
                LAUNCH_FULL_ADS_appurl = adresponselist[i].appurl
                LAUNCH_FULL_ADS_prompttext = adresponselist[i].promptText
                LAUNCH_FULL_ADS_version = adresponselist[i].version
                LAUNCH_FULL_ADS_moreurl = adresponselist[i].moreurl
                LAUNCH_FULL_ADS_src = adresponselist[i].src
                LAUNCH_FULL_ADS_providers = adresponselist[i].adsprovider
                print("adresponselist[i].adsprovider\(adresponselist[i].adsprovider[0].provider_id) \(adresponselist[i].adsprovider[0].ad_id)")
//            }
        }
        
        else if adresponselist[i].type == TYPE_EXIT_FULL_ADS {
            EXIT_FULL_ADS_clicklink = adresponselist[i].clicklink
            EXIT_FULL_ADS_start_date = adresponselist[i].startdate
            EXIT_FULL_ADS_nevigation = adresponselist[i].navigation
            EXIT_FULL_ADS_call_native = adresponselist[i].call_native
            EXIT_FULL_ADS_rateapptext = adresponselist[i].rateapptext
            EXIT_FULL_ADS_rateurl = adresponselist[i].rateurl
            EXIT_FULL_ADS_updateTYPE = adresponselist[i].updatetype
            EXIT_FULL_ADS_email = adresponselist[i].email
            EXIT_FULL_ADS_appurl = adresponselist[i].appurl
            EXIT_FULL_ADS_prompttext = adresponselist[i].promptText
            EXIT_FULL_ADS_version = adresponselist[i].version
            EXIT_FULL_ADS_moreurl = adresponselist[i].moreurl
            EXIT_FULL_ADS_src = adresponselist[i].src
            EXIT_SHOW_AD_ON_EXIT_PROMPT = adresponselist[i].show_ad_on_exit_prompt
            EXIT_SHOW_NATIVE_AD_ON_EXIT_PROMPT = adresponselist[i].show_native_ad_on_exit_prompt
            EXIT_FULL_ADS_providers = adresponselist[i].adsprovider
        }
        
        else if adresponselist[i].type == TYPE_NATIVE_MEDIUM {
            NATIVE_MEDIUM_clicklink = adresponselist[i].clicklink
            NATIVE_MEDIUM_start_date = adresponselist[i].startdate
            NATIVE_MEDIUM_nevigation = adresponselist[i].navigation
            NATIVE_MEDIUM_call_native = adresponselist[i].call_native
            NATIVE_MEDIUM_rateapptext = adresponselist[i].rateapptext
            NATIVE_MEDIUM_rateurl = adresponselist[i].rateurl
            NATIVE_MEDIUM_updateTYPE = adresponselist[i].updatetype
            NATIVE_MEDIUM_email = adresponselist[i].email
            NATIVE_MEDIUM_appurl = adresponselist[i].appurl
            NATIVE_MEDIUM_prompttext = adresponselist[i].promptText
            NATIVE_MEDIUM_version = adresponselist[i].version
            NATIVE_MEDIUM_moreurl = adresponselist[i].moreurl
            NATIVE_MEDIUM_src = adresponselist[i].src
            NATIVE_MEDIUM_providers = adresponselist[i].adsprovider
        }
        
        else if adresponselist[i].type == TYPE_NATIVE_LARGE {
            NATIVE_LARGE_clicklink = adresponselist[i].clicklink
            NATIVE_LARGE_start_date = adresponselist[i].startdate
            NATIVE_LARGE_nevigation = adresponselist[i].navigation
            NATIVE_LARGE_call_native = adresponselist[i].call_native
            NATIVE_LARGE_rateapptext = adresponselist[i].rateapptext
            NATIVE_LARGE_rateurl = adresponselist[i].rateurl
            NATIVE_LARGE_updateTYPE = adresponselist[i].updatetype
            NATIVE_LARGE_email = adresponselist[i].email
            NATIVE_LARGE_appurl = adresponselist[i].appurl
            NATIVE_LARGE_prompttext = adresponselist[i].promptText
            NATIVE_LARGE_version = adresponselist[i].version
            NATIVE_LARGE_moreurl = adresponselist[i].moreurl
            NATIVE_LARGE_src = adresponselist[i].src
            NATIVE_LARGE_providers = adresponselist[i].adsprovider
        }
        
        else if adresponselist[i].type == TYPE_RATE_APP {
            RATE_APP_ad_id = adresponselist[i].ad_id
            RATE_APP_provider_id = adresponselist[i].provider_id
            RATE_APP_clicklink = adresponselist[i].clicklink
            RATE_APP_start_date = adresponselist[i].startdate
            RATE_APP_nevigation = adresponselist[i].navigation
            RATE_APP_call_native = adresponselist[i].call_native
            RATE_APP_rateapptext = adresponselist[i].rateapptext
            RATE_APP_rateurl = adresponselist[i].rateurl
            RATE_APP_updateTYPE = adresponselist[i].updatetype
            RATE_APP_email = adresponselist[i].email
            RATE_APP_appurl = adresponselist[i].appurl
            RATE_APP_prompttext = adresponselist[i].promptText
            RATE_APP_version = adresponselist[i].version
            RATE_APP_moreurl = adresponselist[i].moreurl
            RATE_APP_src = adresponselist[i].src
            RATE_APP_BG_COLOR = adresponselist[i].bgcolor
            RATE_APP_HEADER_TEXT = adresponselist[i].headertext
            RATE_APP_TEXT_COLOR = adresponselist[i].textcolor
            
        }
        else if adresponselist[i].type == TYPE_FEEDBACK {
            FEEDBACK_ad_id = adresponselist[i].ad_id
            FEEDBACK_provider_id = adresponselist[i].provider_id
            FEEDBACK_clicklink = adresponselist[i].clicklink
            FEEDBACK_start_date = adresponselist[i].startdate
            FEEDBACK_nevigation = adresponselist[i].navigation
            FEEDBACK_call_native = adresponselist[i].call_native
            FEEDBACK_rateapptext = adresponselist[i].rateapptext
            FEEDBACK_rateurl = adresponselist[i].rateurl
            FEEDBACK_updateTYPE = adresponselist[i].updatetype
            FEEDBACK_email = adresponselist[i].email
            FEEDBACK_appurl = adresponselist[i].appurl
            FEEDBACK_prompttext = adresponselist[i].promptText
            FEEDBACK_version = adresponselist[i].version
            FEEDBACK_moreurl = adresponselist[i].moreurl
            
        }
        else if adresponselist[i].type == TYPE_UPDATES {
            UPDATES_ad_id = adresponselist[i].ad_id
            UPDATES_provider_id = adresponselist[i].provider_id
            UPDATES_clicklink = adresponselist[i].clicklink
            UPDATES_start_date = adresponselist[i].startdate
            UPDATES_nevigation = adresponselist[i].navigation
            UPDATES_call_native = adresponselist[i].call_native
            UPDATES_rateapptext = adresponselist[i].rateapptext
            UPDATES_rateurl = adresponselist[i].rateurl
            UPDATES_updateTYPE = adresponselist[i].updatetype
            UPDATES_email = adresponselist[i].email
            UPDATES_appurl = adresponselist[i].appurl
            UPDATES_prompttext = adresponselist[i].promptText
            UPDATES_version = adresponselist[i].version
            UPDATES_moreurl = adresponselist[i].moreurl
            
        }
        else if adresponselist[i].type == TYPE_MORE_APPS {
            MOREAPP_ad_id = adresponselist[i].ad_id
            MOREAPP_provider_id = adresponselist[i].provider_id
            MOREAPP_clicklink = adresponselist[i].clicklink
            MOREAPP_start_date = adresponselist[i].startdate
            MOREAPP_nevigation = adresponselist[i].navigation
            MOREAPP_call_native = adresponselist[i].call_native
            MOREAPP_rateapptext = adresponselist[i].rateapptext
            MOREAPP_rateurl = adresponselist[i].rateurl
            MOREAPP_updateTYPE = adresponselist[i].updatetype
            MOREAPP_email = adresponselist[i].email
            MOREAPP_appurl = adresponselist[i].appurl
            print("adresponselist[i].appurl\(adresponselist[i].appurl)")
            MOREAPP_prompttext = adresponselist[i].promptText
            MOREAPP_version = adresponselist[i].version
            MOREAPP_moreurl = adresponselist[i].moreurl
            
        }
        
        else if adresponselist[i].type == TYPE_ETC {
            ETC_1 = adresponselist[i].etc1
            ETC_2 = adresponselist[i].etc2
            ETC_3 = adresponselist[i].etc3
            ETC_4 = adresponselist[i].etc4
            ETC_5 = adresponselist[i].etc5
            
        }
        
        
        else if adresponselist[i].type == TYPE_SHARE {
            SHARE_TEXT = adresponselist[i].sharetext
            SHARE_URL = adresponselist[i].shareurl
        }
        
        else if adresponselist[i].type == TYPE_ADMOB_STATIC {
            ADMOB_NATIVE_MEDIUM_ID_STATIC = adresponselist[i].admob_native_medium_id
            ADMOB_BANNER_ID_STATIC = adresponselist[i].admob_banner_id
            ADMOB_FULL_ID_STATIC = adresponselist[i].admob_full_id
            ADMOB_NATIVE_LARGE_ID_STATIC = adresponselist[i].admob_native_large_id
            ADMOB_BANNER_ID_LARGE_STATIC = adresponselist[i].admob_bannerlarge_id
            ADMOB_BANNER_ID_RECTANGLE_STATIC = adresponselist[i].admob_bannerrect_id
        }
        else if adresponselist[i].type == TYPE_REMOVE_ADS {
            REMOVE_ADS_DESCRIPTION = adresponselist[i].descript
            REMOVE_ADS_BGCOLOR = adresponselist[i].bgcolor
            REMOVE_ADS_TEXTCOLOR = adresponselist[i].textcolor
            
        }
        
        else if adresponselist[i].type == TYPE_ABOUT_DETAILS {
            ABOUTDETAIL_DESCRIPTION = adresponselist[i].descript
            ABOUTDETAIL_OURAPP = adresponselist[i].ourapp
            ABOUTDETAIL_WEBSITELINK = adresponselist[i].websitelink
            ABOUTDETAIL_PRIVACYPOLICY = adresponselist[i].ppolicy
            ABOUTDETAIL_TERM_AND_COND = adresponselist[i].tandc
            ABOUTDETAIL_FACEBOOK = adresponselist[i].facebook
            ABOUTDETAIL_INSTA = adresponselist[i].instagram
            ABOUTDETAIL_TWITTER = adresponselist[i].twitter
            ABOUTDETAIL_FAQ = adresponselist[i].faq
            
        }
        else if adresponselist[i].type == TYPE_EXIT_NON_REPEAT {
            EXIT_NON_REPEAT_COUNT = adresponselist[i].counts
            
        }
        else if adresponselist[i].type == TYPE_EXIT_REPEAT {
            //EXIT_NON_REPEAT_COUNT = adresponselist[i].counts
            EXIT_REPEAT_RATE = adresponselist[i].rate
            EXIT_REPEAT_EXIT = adresponselist[i].exit
            EXIT_REPEAT_FULL_ADS = adresponselist[i].full
            EXIT_REPEAT_REMOVEADS = adresponselist[i].removeads
            
            
        }
        
        else if adresponselist[i].type == TYPE_LAUNCH_NON_REPEAT {
            LAUNCH_NON_REPEAT_COUNT = adresponselist[i].launchCount
            
        }
        
        
        else if adresponselist[i].type == TYPE_LAUNCH_REPEAT {
            LAUNCH_REPEAT_RATE = adresponselist[i].launch_rate
            LAUNCH_REPEAT_EXIT = adresponselist[i].launch_exit
            LAUNCH_REPEAT_FULL_ADS = adresponselist[i].launch_full
            print("LAUNCH_REPEAT_FULL_ADS\(LAUNCH_REPEAT_FULL_ADS)  \(adresponselist[i].launch_full)")
            LAUNCH_REPEAT_REMOVEADS = adresponselist[i].launch_removeads
            
        }
        else if adresponselist[i].type == TYPE_INAPP_BILLING {
            INAPP_PUBLIC_KEY = adresponselist[i].public_key
            print("adresponselist[i].inAppPurchase\(adresponselist[i].inAppPurchase)")
            BILLING_DETAILS = adresponselist[i].inAppPurchase
            //                print("BillingDetails\(adresponselist[i].inAppPurchase[0].details_description)")
        }
    }
        SplashBannerListener.adsInstanceHelper.SplashBannerStatus(true)
        
        if !fetchFromServer{
            onParseDefaultValueListener.adsInstanceHelper.parseCompleted()
        }
        
    }
    
}

func parseInHouseResponse(_ response:AnyObject,viewController:UIViewController){
    print("InhouseResponse\(response)")
    if response != nil{
        let decryptString = decryptvalue.decrypt(hexString:response as! String)
        
        parseDecryptInHouse(decryptString!,viewController: viewController)
    }
}

func parseDecryptInHouse(_ decrpytResponse:String,viewController:UIViewController){
    DispatchQueue.global(qos: .background).async {
        DispatchQueue.main.async {
            let dict1 = dictnry.convertToDictionary(text: decrpytResponse)
            print("DecryptInHOuseRespone:\(decrpytResponse)")
            let code = dict1!["status"] as! String
            if(code == "0"){
                let inhouseResponse = dict1!.validatedValue("inhouseresponse", expected: [String:Any]() as AnyObject) as! [String:Any]
                print("InhouseResponse:\(inhouseResponse)")
                
                let obj = Inhouse()
                InHousedataArray = obj.getInHouseData(dataArray: inhouseResponse)
                print("InHouseArray:\(InHousedataArray.campType)")
                
                InHouseHelper.inHouseInstanceHelper.onInhouseDownload(inHouse: InHousedataArray, viewController: viewController)
                
            }
        }
    }
    
}


