//
//  BTAppUtility.swift
//  App Engine
//
//  Created by Quantum4U1 on 10/02/20.
//  Copyright © 2020 Pulkit Babbar. All rights reserved.
//


import UIKit
import AVFoundation

// MARK: - Short Terms

//let kAppDelegate = UIApplication.shared.delegate as! AppDelegate
let kAppName = "IOS_APP ENGINE"
let Window_Width = UIScreen.main.bounds.size.width
let Window_Height = UIScreen.main.bounds.size.height
let appColor = UIColor(red: 242.0/255.0, green:
               45.0/255.0, blue: 141.0/255.0, alpha: 1.0)



// MARK: - Helper functions

func setFutureDate () -> Date {
    var dateComponent = DateComponents()
    dateComponent.year = 10 //upto 10 years
    let maxDate = Calendar.current.date(byAdding: dateComponent, to: Date())!
    return maxDate
}

func setPastDate () -> Date {
    var dateComponent = DateComponents()
    dateComponent.year = -100 //past 100 years
    let maxDate = Calendar.current.date(byAdding: dateComponent, to: Date())!
    return maxDate
}

func RGBA(_ r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor(red: (r/255.0), green: (g/255.0), blue: (b/255.0), alpha: a)
}



func getViewWithTag(_ tag:NSInteger, view:UIView) -> UIView {
    return view.viewWithTag(tag)!
}

func getStoryboardName() -> String {
    if let langVal = UserDefaults.standard.value(forKey: ""){
        if((langVal as! String) == "2"){
            return "Arabic"
        }else{
            return "English"
        }
    }else{
        return "English"
    }
    
}

func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    label.sizeToFit()
    
    return label.frame.height
}

//func getCurrentViewController() -> UIViewController? {
//    
//    if let rootController = UIApplication.shared.keyWindow?.rootViewController {
//        var currentController: UIViewController! = rootController
//        while( currentController.presentedViewController != nil ) {
//            currentController = currentController.presentedViewController
//        }
//        return currentController
//    }
//    return nil
//    
//}

//MARK: Helper Method

//Convert UIImage to BASE64ENCODEDSTRING
func convertToBase64EncodedString(image : UIImage) -> String
{
    let image = image
    if let imageData = image.jpegData(compressionQuality: 0.5) {
        let dataString = imageData.base64EncodedString(options: .lineLength64Characters)
        return dataString
    }
    return ""
}

func presentAlert(_ titleStr : String?,msgStr : String?,controller : AnyObject?){
    DispatchQueue.main.async(execute: {
        let alert=UIAlertController(title: titleStr, message: msgStr, preferredStyle: UIAlertController.Style.alert);
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil));
        
        //event handler with closure
        controller!.present(alert, animated: true, completion: nil);
    })
}

 func presentAlertWithOptions(_ title: String, message: String,controller : AnyObject, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert, buttons: buttons, tapBlock: tapBlock)
    controller.present(alert, animated: true, completion: nil)

    //        instance.topMostController()?.presentViewController(alert, animated: true, completion: nil)
    return alert
}

private extension UIAlertController {
    
    
    convenience init(title: String?, message: String?, preferredStyle: UIAlertController.Style, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) {
        self.init(title: title, message: message, preferredStyle:preferredStyle)
        var buttonIndex = 0
        for buttonTitle in buttons {
            let action = UIAlertAction(title: buttonTitle, preferredStyle: .default, buttonIndex: buttonIndex, tapBlock: tapBlock)
            buttonIndex += 1
            self.addAction(action)
        }
    }
}

private extension UIAlertAction {
    convenience init(title: String?, preferredStyle: UIAlertAction.Style, buttonIndex:Int, tapBlock:((UIAlertAction,Int) -> Void)?) {
        
        self.init(title: title, style: preferredStyle) {
            (action:UIAlertAction) in
            if let block = tapBlock {
                block(action,buttonIndex)
            }
        }
    }
}

class BTAppUtility: NSObject {

    class  func leftBarButton(_ imageName : NSString,controller : UIViewController) -> UIBarButtonItem {
        let button:UIButton = UIButton.init(type: UIButton.ButtonType.custom)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.setImage(UIImage(named: imageName as String), for: UIControl.State())
        button.addTarget(controller, action: #selector(leftBarButtonAction(_:)), for: UIControl.Event.touchUpInside)
        let leftBarButtonItem:UIBarButtonItem = UIBarButtonItem(customView: button)
        
        return leftBarButtonItem
    }
    
    class  func rightBarButton(_ imageName : NSString,controller : UIViewController) -> UIBarButtonItem {
        let button:UIButton = UIButton.init(type: UIButton.ButtonType.custom)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.setImage(UIImage(named: imageName as String), for: UIControl.State())
        button.addTarget(controller, action: #selector(rightBarButtonAction(_:)), for: UIControl.Event.touchUpInside)
        let leftBarButtonItem:UIBarButtonItem = UIBarButtonItem(customView: button)
        
        return leftBarButtonItem
    }
    
    @objc   func leftBarButtonAction(_ button : UIButton) {
        
    }
    
    @objc   func rightBarButtonAction(_ button : UIButton) {
        
    }
    


}


