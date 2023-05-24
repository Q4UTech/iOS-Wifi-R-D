//
//  SearchController.swift
//  WiFiProvider
//
//  Created by gautam  on 24/05/23.
//

import Foundation

protocol SearchDelegate: class {
    /// SwiftyAd did open
    
    func searchData(searchDarta: String)
    
}


class SearchController : NSObject {
    
    var searchdelegate: SearchDelegate?
    class var instanceHelper: SearchController {
        struct Static {
            static let instance = SearchController()
        }
        return Static.instance
    }
    
    func searchData(searchDarta: String){
        searchdelegate?.searchData(searchDarta: searchDarta)
    }

}
