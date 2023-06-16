//
//  DataModelR.swift
//  Q4U_VPNAPP
//
//  Created by Poornima on 20/10/22.
//

import Foundation
import UIKit

func  doCategoryApiRequest(completion:@escaping ( _ categoryListResponse: [DataModel],_ error:String?) -> Void){
//    DispatchQueue.global(qos: .background).async {
      
            NetworkManagers.sharedInstanceHelper.getCategory(networkListner:{
                (response:CountryList?,error:String?)  in
                if response != nil{
                    print("responseee\(response)")
                    CountryDataVM.shared.setCategoryModel(currentDayModel: response)
                   print("response?.countries\(response?.countries)")
                    completion((response?.countries ?? []),"")
                }else{
                    completion([DataModel].init(),error)
                }
            })
       
//    }
}

