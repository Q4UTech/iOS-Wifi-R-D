//
//  CountrySelectionList.swift
//  Q4U_VPNAPP
//
//  Created by Deepti Chawla on 12/05/21.
//

import Foundation


protocol CountrySelectionListDelegate: class {
    /// SwiftyAd did open
    
    func countrySelection(countrySelection: String,fileLocation:String)
    
}


class CountrySelectionList : NSObject {
    
    var itemdelegates: CountrySelectionListDelegate?
    class var instanceHelper: CountrySelectionList {
        struct Static {
            static let instance = CountrySelectionList()
        }
        return Static.instance
    }
    
    func checkConnectionState(countrySelection:String,fileLocation:String){

        itemdelegates?.countrySelection(countrySelection: countrySelection, fileLocation: fileLocation)
    }
    
    
}
