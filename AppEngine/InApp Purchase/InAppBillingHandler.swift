//
//  InAppBillingHandler.swift
//  AppEngine
//
//  Created by Deepti Chawla on 20/05/21.
//

import Foundation
import UIKit

class InAppBillingHandler : NSObject,InAppBillingListenersProtocol{
    func inAppPurchaseSuccess(productID: String, expiryDate: String, latest_receipt: String,fromStart:Bool) {
        setPurchaseData(productId:productID)
    }
    
//    static var shared: InAppBillingHandler = {
//         return SmartCleaner.InAppBillingHandler()
//    }()
    var inAppBillingManager = InAppBillingManager()
    var  mIsPremium = false
    var  mSubscribedToWeekly = false, mSubscribedToMonthly = false, mSubscribedToQuarterly = false, mSubscribedToHalfYearly = false, mSubscribedToYearly = false;
    var target = UIViewController()
    
    func InAppBillingHandler(target : UIViewController) {
        self.target = target
        InAppBillingListeners.adsInstanceHelper.delegates = self
    }
    
    func initializeBilling(){
        let mBillingList = BILLING_DETAILS
        print("mBillingLIst\(mBillingList)")
        if  mBillingList.count > 0 {
            for billingitems in mBillingList{
                if billingitems.billing_type == Billing_Pro {
                    inAppBillingManager.initBilling(type: INAPP, productID: billingitems.product_id, fromStart: true)
                }
                if billingitems.billing_type == Billing_Weekly{
                    inAppBillingManager.initBilling(type: SUBS, productID: billingitems.product_id, fromStart: true)

                }
                if  billingitems.billing_type == Billing_Monthly {
                    inAppBillingManager.initBilling(type: SUBS, productID: billingitems.product_id, fromStart: true)

                }
                if billingitems.billing_type == Billing_Quarterly {
                    inAppBillingManager.initBilling(type: SUBS, productID: billingitems.product_id, fromStart: true)
                }
                if billingitems.billing_type == Billing_HalfYear {
                       inAppBillingManager.initBilling(type: SUBS, productID: billingitems.product_id, fromStart: true)

                }
                if billingitems.billing_type == Billing_Yearly {
                    inAppBillingManager.initBilling(type: SUBS, productID: billingitems.product_id, fromStart: true)


                }
            }
        }
        
    }
    

    
    func inAppPurchaseFailed() {
        print("INAPPPUrchase ResponseFailed")
        setExpirePurchaseData()
    }
    
    
    func setPurchaseData(productId : String) {
        for b in BILLING_DETAILS {
           
            switch (b.billing_type) {
                case Billing_Pro:
                    if productId == b.product_id{
                        mIsPremium = true
                        UserDefaults.standard.set(mIsPremium, forKey: PRO_PURCHASED)
                        IS_PRO = UserDefaults.standard.bool(forKey: PRO_PURCHASED)
                    }
                    break
                
            case Billing_Free:
                if productId == b.product_id{
                    mIsPremium = true
                    UserDefaults.standard.set(mIsPremium, forKey: FREE_PURCHASED)
                    IS_FREE = UserDefaults.standard.bool(forKey: FREE_PURCHASED)
                }
                break

                case Billing_Weekly:
                    if productId == b.product_id  {
                        mSubscribedToWeekly = true

                        UserDefaults.standard.set(mSubscribedToWeekly, forKey: WEEKLY_PURCHASED)
                        IS_WEEKLY = UserDefaults.standard.bool(forKey: WEEKLY_PURCHASED)
                    }
                    break

                case Billing_Monthly:
                     if productId == b.product_id {
                        mSubscribedToMonthly = true;
                        UserDefaults.standard.set(mSubscribedToMonthly, forKey: MONTHLY_PURCHASED)
                        IS_MONTHLY = UserDefaults.standard.bool(forKey: MONTHLY_PURCHASED)
                        
                    }
                    break

                case Billing_Quarterly:
                    if productId == b.product_id {
                        mSubscribedToQuarterly = true;
                        UserDefaults.standard.set(mSubscribedToQuarterly, forKey: QUATERLY_PURCHASED)
                        IS_QUARTERLY = UserDefaults.standard.bool(forKey: QUATERLY_PURCHASED)
                        
                    }
                    break

                case Billing_HalfYear:
                    if productId == b.product_id {
                        mSubscribedToHalfYearly = true;
                        UserDefaults.standard.set(mSubscribedToHalfYearly, forKey: HALF_YEARLY_PURCHASED)
                        IS_HALFYEARLY = UserDefaults.standard.bool(forKey: HALF_YEARLY_PURCHASED)
                      
                    }
                    break;

                case Billing_Yearly:
                    if productId == b.product_id {
                        mSubscribedToYearly = true;
                        UserDefaults.standard.set(mSubscribedToYearly, forKey: YEARLY_PURCHASED)
                        IS_YEARLY = UserDefaults.standard.bool(forKey: YEARLY_PURCHASED)
                    }
                    break;
                default:
                    break;
            }
        }
    }
    
    
 func setExpirePurchaseData() {
    for b in BILLING_DETAILS {
            switch (b.billing_type) {
                case Billing_Pro:
                    mIsPremium = false;
                    UserDefaults.standard.set(mIsPremium, forKey: PRO_PURCHASED)
                    IS_PRO = UserDefaults.standard.bool(forKey: PRO_PURCHASED)

                    break;
            case Billing_Free:
                mIsPremium = false;
                UserDefaults.standard.set(mIsPremium, forKey: FREE_PURCHASED)
                IS_FREE = UserDefaults.standard.bool(forKey: FREE_PURCHASED)

                break;

                case Billing_Weekly:
                    mSubscribedToWeekly = false;
                    UserDefaults.standard.set(mSubscribedToWeekly, forKey: WEEKLY_PURCHASED)
                    IS_WEEKLY = UserDefaults.standard.bool(forKey: WEEKLY_PURCHASED)

                    break;

                case Billing_Monthly:
                    mSubscribedToMonthly = false;
                    UserDefaults.standard.set(mSubscribedToMonthly, forKey: MONTHLY_PURCHASED)
                    IS_MONTHLY = UserDefaults.standard.bool(forKey: MONTHLY_PURCHASED)

                    break;

                case Billing_Quarterly:
                    mSubscribedToQuarterly = false;
                    UserDefaults.standard.set(mSubscribedToQuarterly, forKey: QUATERLY_PURCHASED)
                    IS_QUARTERLY = UserDefaults.standard.bool(forKey: QUATERLY_PURCHASED)
                    

                    break;

                case Billing_HalfYear:
                    mSubscribedToHalfYearly = false;
                    UserDefaults.standard.set(mSubscribedToHalfYearly, forKey: HALF_YEARLY_PURCHASED)
                    IS_HALFYEARLY = UserDefaults.standard.bool(forKey: HALF_YEARLY_PURCHASED)

                    break;

                case Billing_Yearly:
                    mSubscribedToYearly = false;
                    UserDefaults.standard.set(mSubscribedToYearly, forKey: YEARLY_PURCHASED)
                    IS_YEARLY = UserDefaults.standard.bool(forKey: YEARLY_PURCHASED)
                    break;

                default:
                    break;
            }
        }
    }
    
}
