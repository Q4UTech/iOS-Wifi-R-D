//////
//////  GCMRequest.swift
//////  CustomGallery
//////
//////  Created by Deepti Chawla on 14/07/20.
//////  Copyright © 2020 Pavle Pesic. All rights reserved.
//////
////
//import Foundation
//import UIKit
//import Firebase
//
//
////
////var countryName = String()
////var appVersion = String()
////var appOsVersion = String()
////var appDeviceVersion = String()
////func doTopicRequest(_ viewController:UIViewController ){
////            if appVersion.getAppVersionInfo() != UserDefaults.standard.string(forKey: KEY_TOPIC_APP_VER)
////                           || !UserDefaults.standard.bool(forKey: REGISTER_ALL_TOPICS)  {
////                         createTopics(viewController)
////                   }
////
////
////}
////
////var topics = [String]()
////var allsubscribeTopic = [String]()
////var version = String()
////var context = UIViewController()
////func createTopics(_ viewController:UIViewController) {
////    context = viewController
////    let  country = countryName.getCountryNameInfo()
////    version = "AV_" + appVersion.getAppVersionInfo()
////    let  osVersion = "OS_" + appOsVersion.getOSInfo()
////    let  deviceVersion = "DV_" + appDeviceVersion.getDeviceName()
////    var  date = "DT_" + getDateofLos_Angeles()
////    let  month = "DT_" + getMonthofLos_Angeles()
////    print("Countryshshshshss\(country)   \(version) \(osVersion) \(deviceVersion) \(date) \(month)")
////
////    if (!validateJavaDate(strDate: getDateofLos_Angeles())) {
////        date = "DT_" + getDate(CLong(Date().timeIntervalSince1970))
////
////    }
////
////    topics.append("all")
////    topics.append(country)
////    topics.append(version)
////    topics.append(osVersion)
////    topics.append(deviceVersion)
////    topics.append(date)
////    topics.append(month)
////
////    // UserDefaults.standard.set(false, forKey: "allsubscribeTopic")
////    if (!UserDefaults.standard.bool(forKey:ALL_SUBSCRIBE_TOPICS)) {
////        for i in 0..<topics.count {
////            subscribeToTopic(topicName: topics[i])
////        }
////
////    }
////    else if (version != UserDefaults.standard.string(forKey: KEY_TOPIC_APP_VER)) {
////
////        unSubscribeToTopic(topicName: UserDefaults.standard.string(forKey: KEY_TOPIC_APP_VER)!,currentVersion: version)
////
////    } else {
////
////        if (!UserDefaults.standard.bool(forKey: REGISTER_ALL_TOPICS)){
////              doFCMTopicRequest(topics)
////        }
////
////    }
////}
////
////
////func  subscribeToTopic(topicName:String) {
////
////    Messaging.messaging().subscribe(toTopic: topicName) { error in
////        allsubscribeTopic.append(topicName)
////        if (topics.count == allsubscribeTopic.count) {
////
////            doFCMTopicRequest(allsubscribeTopic)
////
////            UserDefaults.standard.set(true, forKey: ALL_SUBSCRIBE_TOPICS)
////
////            UserDefaults.standard.set(version, forKey:KEY_TOPIC_APP_VER)
////        }
////    }
////
////}
////
////func unSubscribeToTopic(topicName:String,currentVersion:String) {
////
////    Messaging.messaging().unsubscribe(fromTopic: topicName) { error in
////        print("unsubscribeTopic \(topicName)")
////
////
////
////        Messaging.messaging().subscribe(toTopic: currentVersion) { error in
////
////            doFCMTopicRequest(allsubscribeTopic)
////
////        }
////
////    }
////}
////
////
////
////    //var  app_topics = [String]()
////    var  app_topics:NSMutableArray = NSMutableArray()
////    //
////
////    func doFCMTopicRequest(_ subscibeTopics:[String]){
////
////        print("subscribeTopics\(subscibeTopics) \(generateUniqueId())")
////
////        var params = [String:Any]()
////
////
////        for i in 0..<subscibeTopics.count {
////
////            print("subscibeTopics\(subscibeTopics)")
////
////            let prod: NSMutableDictionary = NSMutableDictionary()
////            let trimmedString = subscibeTopics[i].trimmingCharacters(in: .whitespaces)
////            prod.setValue(trimmedString,forKey: "topicName")
////
////            app_topics.add(prod)
////        }
////
////        print("app_topics\(app_topics)")
////
////
////        params = ["app_id": APP_ID, "country": countryname.getCountryNameInfo(), "screen": screenHeight.getScreenHeightResolution(), "launchcount": UserDefaults.standard.integer(forKey: LAUNCH_COUNT), "version": appVersionInfo.getAppVersionInfo(), "osversion": osVersion.getOSInfo(), "dversion": systemversion.getDeviceName(), "os": "2", "unique_id": generateUniqueId(),"app_topics": app_topics]
////
////        print("topicParams\(params)")
////        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed)
////        let jsonString1 = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
////        let encodedString = hexadecimal.encrypt(text:jsonString1)
////        var parametr = [String:String]()
////        parametr = ["data":encodedString!]
////        print("TopiccodedString\(parametr)")
////        ServiceHelper.sharedInstanceHelper.createPostRequest(method: .post, showHud: true, params: parametr, apiName: topicApi) { (result, error) in
////
////            print("TopicfcmResulttt\(result)")
////
////            if result != nil {
////                let decryptString = decryptvalue.decrypt(hexString:result! as! String)
////
////                let dict1 = dictnry.convertToDictionary(text: decryptString!)
////
////                let code = dict1!["status"] as! String
////                if(code == "0"){
////
////
////                    UserDefaults.standard.set(true, forKey: REGISTER_ALL_TOPICS)
////                    UserDefaults.standard.set(version, forKey: KEY_TOPIC_APP_VER)
////
////
////                        let pushData = dict1!["pushData"] as! [String:Any]
////
////                    let reqValue = pushData["reqvalue"] as! String
////                    print("PUshData\(pushData) \(reqValue)")
////                    if (reqValue != "" && reqValue.contains("#")){
////                        let reqValueArr = reqValue.split(separator: "#")
////                        let reqvalue = reqValueArr[0]
////                        let ifdelay = reqValueArr[1]
////                        let delaytime = reqValueArr[2]
////                        if (ifdelay != "" && ifdelay == "yes"){
////                            UserDefaults.standard.set(reqValue, forKey: KEY_OnBoard_NOTI_ID)
////                            setFCMAlarm(delayTime:delaytime)
////                        }
////                    }
////
////
////                }
////            }else{
////                UserDefaults.standard.set(false, forKey: REGISTER_ALL_TOPICS)
////            }
////
////
////        }
////
////}
////
////var counter = 1200
////  var counter1 = 5
////  var timer1 : Timer?
////
////func setFCMAlarm(delayTime:Substring){
////
////         counter = 1200
////          timer1 = Timer.scheduledTimer(timeInterval: 1.0, target: context, selector: #selector(updateTimer), userInfo: nil, repeats: true)
////
////
////}
////
////
////
////    func updateTimer() {
////       print(counter)
////       if counter != 0 {
////           counter -= 1
////       } else {
////           if let timer1 = self.timer {
////               timer1.invalidate()
////               self.timer1 = nil
////               print("Dismissed")
////
////           }
////       }
////   }
////
////
////
