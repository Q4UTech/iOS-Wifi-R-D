//
//  PremiumViewModel.swift
//  Q4U_VPNAPP
//
//  Created by Deepti Chawla on 26/05/21.
//

import Foundation
import StoreKit

class PremiumViewModel{
   // var products: [SKProduct] = []

    func premiumList(completion:@escaping (_ productList:[SKProduct]?,_ status : Bool ) -> Void) {
      
        // DispatchQueue.global(qos: .userInitiated).async {
          //  DispatchQueue.main.async {
             print("checkProducts")
     
            RazeFaceProducts.store.requestProducts{ success, products in
                
                print("checkProducts111")
                if success {
                    print("checkProducts222")
                    if products!.count > 0{
                        completion(products!.reversed(),true)
                    }else{
                        completion(nil,false)
                    }
                }else{
                    print("checkProducts333")
                    completion(nil,false)
                }
            }
      //  }
   //  }
    }
  
    
}
