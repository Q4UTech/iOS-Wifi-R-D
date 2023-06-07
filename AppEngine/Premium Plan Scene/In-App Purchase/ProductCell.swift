//
//  ProductCell.swift
//  CustomGallery
//
//  Created by Pulkit Babbar on 27/07/20.
//

import UIKit
import StoreKit

class ProductCell: UITableViewCell {
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    static let priceFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    
    formatter.formatterBehavior = .behavior10_4
    formatter.numberStyle = .currency
    
    return formatter
  }()
  
  var buyButtonHandler: ((_ product: SKProduct) -> Void)?
    var view: UIView?
  
  var product: SKProduct? {
    didSet {
      guard let product = product else { return }
        if #available(iOS 11.2, *) {
            print("SubscriptionPeriod",product.subscriptionPeriod?.numberOfUnits ,product.subscriptionPeriod?.unit ,product)
        } else {
            // Fallback on earlier versions
        }
      titleLabel?.text = product.localizedTitle
       
      if RazeFaceProducts.store.isProductPurchased(product.productIdentifier) {
//        accessoryType = .checkmark
        accessoryView = nil
        priceLabel?.text = "Payment successful, Please relaunched the app to apply purchase."
        priceLabel.font = priceLabel.font.withSize(15)
        
      } else if IAPHelper.canMakePayments() {
        ProductCell.priceFormatter.locale = product.priceLocale
        priceLabel?.text = ProductCell.priceFormatter.string(from: product.price)

        accessoryType = .none
//        accessoryView = self.newBuyButton()
      } else {
        priceLabel?.text = "Not available"
      }
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    titleLabel?.text = ""
    priceLabel?.text = ""
    accessoryView = nil
  }
  
//  func newBuyButton() -> UIButton {
////    let button = UIButton(type: .system)
////    button.setTitleColor(tintColor, for: .normal)
////    button.setTitle("Buy", for: .normal)
////    button.addTarget(self, action: #selector(ProductCell.buyButtonTapped(_:)), for: .touchUpInside)
////    button.sizeToFit()
//
////    return button
//  }
  
  @objc func buyButtonTapped(_ sender: AnyObject) {
    buyButtonHandler?(product!)
  }
}
