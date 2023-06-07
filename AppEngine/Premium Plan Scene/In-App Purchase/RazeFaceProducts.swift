//
//  RazeFaceProducts.swift

//
//  Created by Pulkit Babbar on 27/07/20.
//  Copyright © 2020 Pavle Pesic. All rights reserved.
//

import Foundation

public struct RazeFaceProducts {
    public static let removeAdsID = "com.reactioncam.removeads"
    public static let monthlyProductID = "com.pro.monthlysub"
    public static let quarterlyProductID = "com.quantum.reactioncam.3month"
    public static let yearlyProductID = "com.pro.yearlysub"
    
    private static let productIdentifiers: Set<ProductIdentifier> = [""]
    
    public static let store = IAPHelper(productIds: RazeFaceProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
  return productIdentifier.components(separatedBy: ".").last
}

