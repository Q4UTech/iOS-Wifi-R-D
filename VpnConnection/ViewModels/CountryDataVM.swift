//
//  CountryDataVM.swift
//  WiFiProvider
//
//  Created by gautam  on 16/05/23.
//

import Foundation

class CountryDataVM {
    
    static let shared = CountryDataVM()
    var categoryList : CountryList?
    
    func setCategoryModel(currentDayModel:CountryList?){
        self.categoryList = currentDayModel
    }
    func getCategoryModel() -> CountryList?{
        return self.categoryList
    }
    
    func getExcercise(completion:@escaping ( _ categoryListResponse: [DataModel],_ error:String?) -> Void){
        doCategoryApiRequest(completion: { categoryListResponse, error in
            if error == "No Internet Connection"{
                completion([DataModel].init(),error)
            }else{
                if categoryListResponse != nil{
                    print("categoryListResponse\(categoryListResponse)")
                    completion(categoryListResponse, "")
                    
                }else{
                    completion([DataModel].init(),error)
                }
            }
            
          
          
        })
        

    }
}
