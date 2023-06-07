//
//  GeneralExtension.swift
//  App Engine
//
//  Created by Quantum4U1 on 10/02/20.
//  Copyright © 2020 Pulkit Babbar. All rights reserved.
//

import UIKit
import AVFoundation
extension UIImageView {
    
    public func loadGif(name: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(name: name)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
func getCurrentTime() -> UInt64{
    return Date.init().currentTimeMillis()
}
extension Date {
    
    static func getCurrentDate() -> String {
        
        let dateFormatter = DateFormatter()
        
        // dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: Date())
        
    }
    
    static func getCurrentTime() -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "HH:mm:ss"
        // dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: Date())
    }
    
    
    func currentTimeMillis() -> UInt64 {
        return UInt64(self.timeIntervalSince1970 * 1000)
    }
    
    
    
    
}
extension UIViewController {
    //MARK:- Add ToolBar
    
    func  addToolBar(name:String, tag : NSInteger, textFieldTag : NSInteger) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: self.view.frame.size.height - 46, width: Window_Width, height: 46)
        if name == "next" {
            let nextButton = UIBarButtonItem(title: name, style: UIBarButtonItem.Style.plain, target: self, action: #selector(nextBarButtonAction(_:)))
            nextButton.tag = textFieldTag
            toolbarItems = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),nextButton]

        }else{
            let doneButton = UIBarButtonItem(title: name, style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneBarButtonAction(_:)))
            toolbarItems = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),doneButton]
        }
       
        toolbar.sizeToFit()
        toolbar.backgroundColor = UIColor.darkGray
        toolbar.setItems(toolbarItems, animated: false)
        return toolbar
    }
    
    @IBAction func nextBarButtonAction(_ sender: UIButton)
    {
        let kTextField = getViewWithTag(sender.tag + 1, view: self.view) as? UITextField
        kTextField?.becomeFirstResponder()
    }
    
    @IBAction func doneBarButtonAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
    }
    
}

extension UIView
{
    //Shadow Effect
    func dropShadowWithBlackColor()
    {
        self.layer.shadowColor    = UIColor.black.cgColor
        self.layer.shadowOpacity  = 0.6
        self.layer.shadowRadius   = 7;
        self.layer.masksToBounds  = false
        self.layer.shadowOffset   = CGSize(width: 1.0, height: 1.0)
    }
}

extension UIImage {
    
    public class func gif(data: Data) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gif(url: String) -> UIImage? {
        // Validate URL
        guard let bundleURL = URL(string: url) else {
            return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            return nil
        }
        
        return gif(data: imageData)
    }
    
    public class func gif(name: String) -> UIImage? {
        // Check for existance of gif
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            return nil
        }
        
        return gif(data: imageData)
    }
    
    internal class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        if CFDictionaryGetValueIfPresent(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque(), gifPropertiesPointer) == false {
            return delay
        }
        
        let gifProperties:CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
        
        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as? Double ?? 0
        
        if delay < 0.1 {
            delay = 0.1 // Make sure they're not too fast
        }
        
        return delay
    }
    
    internal class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        // Check if one of them is nil
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        // Swap for modulo
        if a! < b! {
            let c = a
            a = b
            b = c
        }
        
        // Get greatest common divisor
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b! // Found it
            } else {
                a = b
                b = rest
            }
        }
    }
    
    internal class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    internal class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        // Fill arrays
        for i in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            // At it's delay in cs
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        // Calculate full duration
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        // Get frames
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        // Heyhey
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        
        return animation
    }
    
}


// MARK:- Array Extensions

extension Array {
    func contains<T>(_ obj: T) -> Bool where T : Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
}

// MARK:- Dictionary Extensions

extension Dictionary {
    
    
    func validatedValue(_ key: Key, expected: AnyObject) -> AnyObject {
        
        // checking if in case object is nil
        
        if let object = self[key] as? AnyObject{
            
            // added helper to check if in case we are getting number from server but we want a string from it
            if object is NSNumber && expected is String {
                
                //logInfo("case we are getting number from server but we want a string from it")
                
                return "\(object)" as AnyObject
            }
                
                // checking if object is of desired class
            else if (object.isKind(of: expected.classForCoder) == false) {
                //logInfo("case // checking if object is of desired class....not")
                
                return expected
            }
                // checking if in case object if of string type and we are getting nil inside quotes
            else if object is String {
                if ((object as! String == "null") || (object as! String == "<null>") || (object as! String == "(null)")) {
                    //logInfo("null string")
                    return "" as AnyObject
                }
            }
            return object
        }
        else {
            
            if expected is String || expected as! String == "" {
                return "" as AnyObject
            }
            return expected
        }
    }
}

// MARK:- UIView Extensions
extension UIView {
   
    func shadow(_ color:UIColor) {
        self.layer.shadowColor = color.cgColor;
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 1
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
    }
    
    func setNormalRoundedShadow(_ color:UIColor) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 1
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
    }
    
    func setBorder(_ color:UIColor, borderWidth:CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
        self.clipsToBounds = true
    }
    
    func vibrate() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.02
        animation.repeatCount = 2
        animation.speed = 0.5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 2.0, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 2.0, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
    
    func shake() {
        self.transform = CGAffineTransform(translationX: 5, y: 5)
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1.0, options: UIView.AnimationOptions(), animations: { () -> Void in
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    func setTapperTriangleShape(_ color:UIColor) {
        // Build a triangular path
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0,y: 0))
        path.addLine(to: CGPoint(x: 40,y: 40))
        path.addLine(to: CGPoint(x: 0,y: 100))
        path.addLine(to: CGPoint(x: 0,y: 0))
        
        // Create a CAShapeLayer with this triangular path
        let mask = CAShapeLayer()
        mask.frame = self.bounds
        mask.path = path.cgPath
        
        // Mask the view's layer with this shape
        self.layer.mask = mask
        
        self.backgroundColor = color
        
        // Transform the view for tapper shape
       // self.transform = CGAffineTransform(rotationAngle: CGFloat(270) * CGFloat(M_PI_2) / 180.0)
    }
}


// MARK:- Int/Float/Double Extensions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

extension Int {
    func format(_ f: String) -> String {
        return NSString(format: "%\(f)d" as NSString, self) as String
    }
}

extension Double {
    func format(_ f: String) -> String {
        return NSString(format: "%\(f)f" as NSString, self) as String
    }
}

extension Float {
    func format(_ f: String) -> String {
        return NSString(format: "%\(f)f" as NSString, self) as String
    }
}




extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
}

extension Date {
    
    func dateString(_ format: String = "MMM-dd-YYYY, hh:mm a") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    func dateByAddingYears(_ dYears: Int) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.year = dYears
        
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}

extension Collection where Iterator.Element == [String:Any] {
    func toJSONString(options: JSONSerialization.WritingOptions = .prettyPrinted) -> String {
        if let arr = self as? [[String:AnyObject]],
            let dat = try? JSONSerialization.data(withJSONObject: arr, options: options),
            let str = String(data: dat, encoding: String.Encoding.utf8) {
            return str
        }
        return "[]"
    }
}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Avenir-Heavy", size: 15)! , .foregroundColor : appColor]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Avenir-Medium", size: 13)!]
        let normal = NSAttributedString(string: text, attributes: attrs)
        append(normal)
        
        return self
    }
}

extension Notification.Name {
    static let notificationSocketOnline = Notification.Name("notificationSocketOnline")
    static let notificationRoomConnect = Notification.Name("notificationRoomConnect")
    static let notificationSendMessage = Notification.Name("notificationSendMessage")
    static let notificationSocketTyping = Notification.Name("notificationSocketTyping")
    static let notificationSocketConnected = Notification.Name("notificationSocketConnected")
    static let notificationRecieverAcknowledge = Notification.Name("RecieverAcknowledge")
    static let notificationLocataionSettingUpdated = Notification.Name("locationSettingUpdated")
    static let notificationCheckInUserNotify = Notification.Name("checkInUserListUpdated")
    static let notificationNewMessageCount = Notification.Name("newMessageCount")
    static let notificationResetMessageCount = Notification.Name("resetMessageCount")
}

extension UIApplication {
  static func topViewController(_ base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = (base as? UITabBarController) , let selected = tab.selectedViewController {
            return topViewController(selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}


//extension Date {
//
//    static func getCurrentDate() -> String {
//
//        let dateFormatter = DateFormatter()
//
//        // dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
//        dateFormatter.dateFormat = "dd/MM/yyyy"
//        return dateFormatter.string(from: Date())
//
//    }
//
//    static func getCurrentTime() -> String {
//
//        let dateFormatter = DateFormatter()
//
//        dateFormatter.dateFormat = "HH:mm:ss"
//        // dateFormatter.dateFormat = "dd/MM/yyyy"
//        return dateFormatter.string(from: Date())
//    }
//
//
//    func currentTimeMillis() -> UInt64 {
//        return UInt64(self.timeIntervalSince1970 * 1000)
//    }
//
//
//
//
//}
