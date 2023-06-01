//
//  CountrySelectionList.swift
//  Q4U_VPNAPP
//
//  Created by Deepti Chawla on 12/05/21.
//

import Foundation


protocol CountrySelectionListDelegate: class {
    /// SwiftyAd did open
    
    func countrySelection(countryFlag:String,countrySelection: String,fileLocation:String)
    
}


class CountrySelectionList : NSObject {
    
    var itemdelegates: CountrySelectionListDelegate?
    class var instanceHelper: CountrySelectionList {
        struct Static {
            static let instance = CountrySelectionList()
        }
        return Static.instance
    }
    
    func checkConnectionState(countryFlag:String,countrySelection:String,fileLocation:String){

        itemdelegates?.countrySelection(countryFlag: countryFlag, countrySelection: countryFlag, fileLocation: fileLocation)
    }
    
    
}
