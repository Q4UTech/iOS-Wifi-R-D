//
//  LanguageSelectionListener.swift
//  Q4U-PhoneSwtich
//
//  Created by Deepti Chawla on 14/02/22.
//

import Foundation

protocol LanguageSelectionDelegate: AnyObject {
    /// SwiftyAd did open
    
    func languageSelection(name:String,code:String)
    
}
class LanguageSelectionListener: NSObject{
    var itemdelegates: LanguageSelectionDelegate?
    
    class var instanceHelper: LanguageSelectionListener {
        struct Static {
            static let instance = LanguageSelectionListener()
        }
        return Static.instance
    }
    
    func languageSelection(name:String,code:String){

        itemdelegates?.languageSelection(name:name,code:code)
    }
}
