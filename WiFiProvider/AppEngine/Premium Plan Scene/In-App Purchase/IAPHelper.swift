//
//  IAPHelper.swift
//  CustomGallery
//
//  Created by Pulkit Babbar on 27/07/20.
//  Copyright © 2020 Pavle Pesic. All rights reserved.
//

import StoreKit
import UIKit
import Alamofire
import FirebaseAnalytics
import KRProgressHUD

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void

var alertController = UIAlertController(title: nil, message: "Please wait\n\n", preferredStyle: .alert)

extension Notification.Name {
    static let IAPHelperPurchaseNotification = Notification.Name("IAPHelperPurchaseNotification")
}

var currentActiveService = false
open class IAPHelper: NSObject  {
    var recieptArray = [PurchaseReceiptResponse]()
    private var productIdentifiers: Set<ProductIdentifier>
    private var purchasedProductIdentifiers: Set<ProductIdentifier> = []
    private var productsRequest: SKProductsRequest?
    var inAppBillingManager = InAppBillingManager()
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    var iCloudAvailability: Bool {
      return FileManager.default.ubiquityIdentityToken != nil
    }
    public init(productIds: Set<ProductIdentifier>) {
        productIdentifiers = productIds
       
        for productIdentifier in productIds {
            let purchased = UserDefaults.standard.bool(forKey: productIdentifier)
            if purchased {
                purchasedProductIdentifiers.insert(productIdentifier)
                print("Previously purchased: \(productIdentifier)")
            } else {
                
            }
        }
        super.init()
        SKPaymentQueue.default().add(self)
    }
}

// MARK: - StoreKit API

extension IAPHelper {
    
    public func requestProducts(_ completionHandler: @escaping ProductsRequestCompletionHandler) {
        productsRequest?.cancel()
        print("request Products")
       
        for item in BILLING_DETAILS{
            self.productIdentifiers.insert(item.product_id)
        }
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest!.delegate = self
        productsRequest!.start()
        
        productsRequestCompletionHandler = completionHandler
    }
    
    public func buyProduct(_ product: SKProduct) {
     
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
        INAPPPurchaseComplete.instanceHelper.inAppPurchasedStatus(status:false, productID: "")
    }
    
    public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
        
        return purchasedProductIdentifiers.contains(productIdentifier)
    }
    
    public class func canMakePayments() -> Bool {
       
        return SKPaymentQueue.canMakePayments()
    }
    
    public func restorePurchases(fromStart:Bool) {
        SKPaymentQueue.default().restoreCompletedTransactions()
        
        inAppBillingManager.initBilling(type: SUBS, productID: "", fromStart: fromStart)
        
    }
}

// MARK: - SKProductsRequestDelegate

extension IAPHelper: SKProductsRequestDelegate {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if !response.products.isEmpty{
            var products = response.products
            products.sort(by: { (p0, p1) -> Bool in
                return p0.price.floatValue < p1.price.floatValue
            })
            productsRequestCompletionHandler?(true, products)
           
            
            for p in products {
                print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
            }
        }else{
            productsRequestCompletionHandler?(false, nil)
            
        }
        clearRequestAndHandler()
    }

    public func request(_ request: SKRequest, didFailWithError error: Error) {
        productsRequestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }
    
    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
    
    
}

// MARK: - SKPaymentTransactionObserver

extension IAPHelper: SKPaymentTransactionObserver {
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred:
                INAPPPurchaseComplete.instanceHelper.inAppPurchasedStatus(status:false, productID: transaction.payment.productIdentifier)
                break
            
            case .purchasing:
                INAPPPurchaseComplete.instanceHelper.inAppPurchasedStatus(status:false, productID: transaction.payment.productIdentifier)
                break
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
      
        let parameter = ["inAppPurchaseIDComplete": transaction.payment.productIdentifier,"InAppPaymentSuccess":"Success"]
        Analytics.logEvent("AN_INAPP_PURCHASE", parameters: parameter)
        print("SplashVC.fromSplash\(SplashVC.fromSplash)")
        if SplashVC.fromSplash{
            inAppBillingManager.initBilling(type: SUBS, productID: "", fromStart: true)
            INAPPPurchaseComplete.instanceHelper.inAppPurchasedStatus(status:false, productID: "")
        }else{
            SplashVC.fromSplash = true
//            if isProductPurchased(transaction.payment.productIdentifier){
//                INAPPPurchaseComplete.instanceHelper.inAppPurchasedStatus(status:true, productID: transaction.payment.productIdentifier)
//            }else {
//                INAPPPurchaseComplete.instanceHelper.inAppPurchasedStatus(status:false, productID: transaction.payment.productIdentifier)
//            }
            inAppBillingManager.initBilling(type: SUBS, productID: "", fromStart: false)
        }

    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        deliverPurchaseNotificationFor(identifier: productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
        inAppBillingManager.initBilling(type: SUBS, productID: "", fromStart: true)
        INAPPPurchaseComplete.instanceHelper.inAppPurchasedStatus(status:false, productID: productIdentifier)
    }
     
    private func fail(transaction: SKPaymentTransaction) {
        if let transactionError = transaction.error as NSError?,
        let localizedDescription = transaction.error?.localizedDescription,
           transactionError.code != SKError.paymentCancelled.rawValue {
        }
        SKPaymentQueue.default().finishTransaction(transaction)
        KRProgressHUD.dismiss()
        let parameter = ["inAppPurchaseIDFailed": transaction.payment.productIdentifier,"InAppPaymentFailed":transaction.error?.localizedDescription]
        Analytics.logEvent("AN_INAPP_PURCHASE", parameters: parameter)
        INAPPPurchaseComplete.instanceHelper.inAppPurchasedStatus(status:false, productID: "")
    }
    
    public func requestDidFinish(_ request: SKRequest) {
        print("finsishss")
    }
    
    private func deliverPurchaseNotificationFor(identifier: String?) {
     //  print("Check Deleiver")
        guard let identifier = identifier else { return }
        purchasedProductIdentifiers.insert(identifier)
        UserDefaults.standard.set(true, forKey: identifier)
        NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: identifier)
    }
}
