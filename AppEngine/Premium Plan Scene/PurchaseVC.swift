//
//  PurchaseVC.swift
//  Q4U-CAM SCANNER
//
//  Created by Pulkit Babbar on 16/08/21.
//

import UIKit

import StoreKit
import KRProgressHUD

class PurchaseVC: UIViewController,UITableViewDelegate,UITableViewDataSource,InAppBillingListenersProtocol,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var tabelViewheight: NSLayoutConstraint!
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var purchaseViewSubtitleLabel: UILabel!
    @IBOutlet weak var purchaseViewImageView: UIImageView!
    
    @IBOutlet weak var purchaseViewTitleLabel: UILabel!
    @IBOutlet weak var goPremiumView: UIView!
    @IBOutlet weak var adsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var adsView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var navTitleLabel: UILabel!
    
    var backType = String()
    var products: [SKProduct] = []
    var currentlyActiveSubscription = String()
    var inAppBillingManager = InAppBillingManager()
    var mBillingList = [Billing]()
    var alreadyPurchased = Bool()
    var premiumViewModel = PremiumViewModel()
    var fromMoreTool = false
    var fromfaceCam = false
    var fulladstatus = Bool()
    var fulladstype = String()
    var value = String()
    var type = String()
    var isReload = false
    var selectedIndex:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if fromfaceCam {
            continueButton.isHidden = true
            backButton.isHidden = false
        }
        else {
            if fromMoreTool == true {
                continueButton.isHidden = true
                backButton.isHidden = false
            }
            else {
               // continueButton.isHidden = false
              //  backButton.isHidden = true
            }
        }
        initalSetups()
       // bannerAd()
        KRProgressHUD.showOn(self).show()
        localizeStrings()
        if #available(iOS 13.0, *) {
            UIApplication.shared.statusBarStyle = .lightContent
        }
        UserDefaults.standard.set(true, forKey: FIRST_TIME_ONPURCHASE)
    }
    
    func localizeStrings() {
      //  navTitleLabel.text! = "VIP Access"
        
    }
    
    func initalSetups() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
     //   bannerAd()
        SplashVC.fromSplash = true
        RazeFaceProducts.store.restorePurchases(fromStart: true)
        InAppBillingListeners.adsInstanceHelper.delegates = self
        reload()
    }
    
    func setPremiumUI(status:Bool){
        // self.goPremiumView.isHidden = status
        
    }
    
    func showAlert(){
        if fromMoreTool == true {
            let alert = UIAlertController(title: "Alert!", message: "No Internet Connection!", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok",
                                          style: UIAlertAction.Style.default,
                                          handler: {(_: UIAlertAction!) in
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: false)
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func tableViewReload(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getFirebaseTrackScreen(PURCHASE_SCREEN)
    }
    
//    func bannerAd(){
////        BaseClass.init().bannerAds(target: self, adsView: adsView, adsHeightConstraint: adsViewHeightConstraint)
//        getBannerAd(self, adsView, adsViewHeightConstraint)
//    }
    
    @IBAction func restoreButtonAction(_ sender: Any) {
        if !alreadyPurchased{
            self.view.makeToast("You have not subscribed yet. Please subscribe first", point: CGPoint(x:view.center.x, y: view.frame.maxY - 70), title: "", image: nil, completion: nil)
            RazeFaceProducts.store.restorePurchases(fromStart:false)
        }else{
            self.view.makeToast("Already Purchased", point: CGPoint(x:view.center.x, y: view.frame.maxY - 70), title: "", image: nil, completion: nil)
        }
    }
    
//    @IBAction func continueButtonAction(_ sender: Any) {
//        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier:"OnBoardingScreenVC") as? OnBoardingScreenVC
//                self.navigationController?.pushViewController(vc!, animated: true)
//    }
    @IBAction func privacyButtonAction(_ sender: Any) {
        BaseClass.init().privacyPolicy()
    }

    @IBAction func termOfUseButtonAction(_ sender: Any) {
        BaseClass.init().termsCondition()
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        if fromfaceCam {
            var viewControllers = navigationController?.viewControllers
            viewControllers?.removeLast(2) //here 2 views to pop index numbers of views
            navigationController?.setViewControllers(viewControllers!, animated: true)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func reload(){
        
        if ServiceHelper.sharedInstanceHelper.isConnectedToNetwork(){
            
            premiumViewModel.premiumList(completion: {
                productList,status   in
                DispatchQueue.main.async {
                    if status {
                        
                        print("productListCount\(productList) \(BILLING_DETAILS.count)")
                        
                        
                        guard var productList = productList else {
                            self.goTobackPage()
                            return
                        }
                        
                        
                        
                        print("productList\(productList.count)")
                        if productList.count > 0 &&  BILLING_DETAILS.count > 0 {
                            self.setPremiumUI(status: false)
                            print("cuurentlySubscrption\(self.currentlyActiveSubscription)")
                            if self.currentlyActiveSubscription == RazeFaceProducts.removeAdsID {
                                
                                for item in BILLING_DETAILS{
                                    
                                    if item.product_id != RazeFaceProducts.removeAdsID{
                                        self.mBillingList.append(item)
                                    }
                                }
                                for item in productList{
                                    
                                    if item.productIdentifier.description == RazeFaceProducts.removeAdsID{
                                        self.products.append(item)
                                        
                                    }
                                }
                                
                            }else{
                                // BILLING_DETAILS.remove(at: 0)
                                print("productList111\(BILLING_DETAILS.count)")
                                
                                for item in BILLING_DETAILS{
                                    print("item.product_offer_sub_text\(item.product_offer_sub_text)")
                                    if item.product_id != RazeFaceProducts.removeAdsID{
                                        self.mBillingList.append(item)
                                    }
                                }
                                
                                for item in productList{
                                    print("itemProcuts\(item.productIdentifier.description)")
                                    if item.productIdentifier.description != RazeFaceProducts.removeAdsID{
                                        self.products.append(item)
                                        
                                    }
                                }
                            }
                            print("self.mBillingList\(self.mBillingList.count)")
                            self.mBillingList.sort(by: { (p0, p1) -> Bool in
                                return p0.product_price < p1.product_price
                            })
                            
                            
                            self.products.reverse()
                            self.tableViewReload()
                            KRProgressHUD.dismiss()
                        }
                    }else{
                        
                        self.goTobackPage()
                        
                        //                        self.navigationController?.popViewController(animated: false)
                        KRProgressHUD.dismiss()
                    }
                    
                    
                    
                    
                }
            })
        }else{
            //            goTobackPage()
            showAlert()
            KRProgressHUD.dismiss()
            
        }
    }
    
    func goTobackPage(){
        if fromMoreTool == true {
            self.navigationController?.popViewController(animated: false)
            
        }else{
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
    }
    
    
    //MARK: Table view DataSource & Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if products.count > 0 && mBillingList.count > 0{
            if products.count == 1{
                if products.count == mBillingList.count {
                    tableView.isHidden = false
                    tabelViewheight.constant = 120
                    return products.count
                }else{
                    return 0
                }
            }else{
                if products.count == mBillingList.count {
                    tableView.isHidden = false
                 //   tabelViewheight.constant = 280
                    return products.count
                }else{
                    return 0
                }
            }
        }else{
            tableView.isHidden = true
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        if currentlyActiveSubscription ==  RazeFaceProducts.removeAdsID {
        //            if(indexPath.row == 0){
        //                return 90
        //                }else{
        //                    return 0
        //                }
        //        }
        //        else {
        //
        //
        //        }
        
        return 70
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PurchaseCell", for: indexPath) as! PurchaseCell
     //   cell.dividerLabel.isHidden = true
        
        cell.detailView.layer.borderWidth = 1
        cell.detailView.layer.borderColor = hexStringColor(hex: "#BBB8B5").cgColor
        cell.detailView.clipsToBounds = true
        cell.detailView.layer.cornerRadius = 12.0
        
        let product = products[indexPath.row]
        
        if product.productIdentifier.description == RazeFaceProducts.removeAdsID {
            cell.selectedPlanImg!.image = UIImage(named: "Removeads")


        } else if product.productIdentifier.description == RazeFaceProducts.yearlyProductID {
            
        } else if product.productIdentifier.description == RazeFaceProducts.monthlyProductID {
           

        }
        else  {
           
        }
        
        
        cell.detailView.clipsToBounds = true
        cell.detailView.layer.cornerRadius = 12.0
       // cell.priceView.layer.cornerRadius = 12.0
       // tableView.isEmptyRowsHidden = true
        
        
//        if #available(iOS 13.0, *) {
//            cell.priceView.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.1)
//        } else {
//            // Fallback on earlier versions
//        }
//        cell.priceView.layer.shadowOffset = CGSize(width: 5, height: 0);
//        cell.priceView.layer.shadowOpacity = 1;
//        cell.priceView.layer.shadowRadius = 1.0;
//
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = bgColorView
        if mBillingList.count > 0 {
            let billingProduct = mBillingList[indexPath.row]
            
            print("product.productIdentifier.description\(product.productIdentifier.description) \(billingProduct.product_id)")
            if product.productIdentifier.description == billingProduct.product_id{
                print("checkid\(billingProduct.details_description)")
                cell.titleLabel.text? = billingProduct.product_offer_text
                cell.subtitleLabel.text? =  billingProduct.product_offer_sub_text
                ProductCell.priceFormatter.locale = product.priceLocale
                cell.priceLabel.text? = ProductCell.priceFormatter.string(from: product.price)!
              //  purchaseViewSubtitleLabel.text! = billingProduct.details_description
            }else{
                print("product.localizedTitle\(product.localizedTitle)")
                cell.titleLabel.text? = product.localizedTitle
                cell.subtitleLabel.text? = product.localizedDescription
                ProductCell.priceFormatter.locale = product.priceLocale
                cell.priceLabel.text? = ProductCell.priceFormatter.string(from: product.price)!
            }
        }else{
            cell.titleLabel.text? = product.localizedTitle
            cell.subtitleLabel.text? = product.localizedDescription
            ProductCell.priceFormatter.locale = product.priceLocale
            cell.priceLabel.text? = ProductCell.priceFormatter.string(from: product.price)!
        }
        if currentlyActiveSubscription == product.productIdentifier.description{
            //            continueButton.setTitle("Continue", for: .normal)
            cell.detailView.backgroundColor = hexStringColor(hex: "0D2A44")
            cell.titleLabel.textColor = UIColor.white
            cell.memberLabel.textColor = UIColor.white
            cell.priceLabel.textColor = hexStringColor(hex: "359FFF")
            cell.isUserInteractionEnabled = true
            cell.dividerLabel.isHidden = false
            self.purchaseViewTitleLabel.textColor = hexStringColor(hex: "FF4E59")
            
            self.purchaseViewImageView.image = UIImage(named: "redCrownIcon")
            self.purchaseViewTitleLabel.text! = "Wow ! You are a premium user"
            
            
            
            if currentlyActiveSubscription == RazeFaceProducts.monthlyProductID {
                cell.subtitleLabel.textColor = hexStringColor(hex: "FFFFFF").withAlphaComponent(0.7)
                
            } else  if currentlyActiveSubscription == "com.quantum.phoneswitch.quarterly" {
                
                
                cell.subtitleLabel.textColor = hexStringColor(hex: "FFFFFF").withAlphaComponent(0.7)
                
            }
            else {
                
                cell.subtitleLabel.textColor = hexStringColor(hex: "FFFFFF").withAlphaComponent(0.7)
                
            }
            
            adsView.isHidden = true
            adsViewHeightConstraint.constant = 0
            //                        continueButton.setTitle("Continue", for: .normal)
            let myNormalAttributedTitle = NSAttributedString(string: "Continue",
                                                             attributes: [NSAttributedString.Key.underlineStyle : 1])
            
            
            continueButton.setAttributedTitle(myNormalAttributedTitle, for: .normal)
            
        }else{
            if !alreadyPurchased{
                cell.isUserInteractionEnabled = true
                cell.detailView.backgroundColor = hexStringColor(hex: "191C20")
                cell.titleLabel.textColor = UIColor.white
              //  cell.memberLabel.textColor = UIColor.black
                cell.priceLabel.textColor = UIColor.white
                cell.subtitleLabel.textColor = UIColor.white
            }else{
                cell.isUserInteractionEnabled = false
                cell.detailView.backgroundColor = hexStringColor(hex: "191C20")
                cell.titleLabel.textColor = UIColor.white
              //  cell.memberLabel.textColor = UIColor.black
                cell.priceLabel.textColor = UIColor.white
                cell.subtitleLabel.textColor = UIColor.white
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isReload = true
        
        
        let product = products[(indexPath as NSIndexPath).row]
        
        if currentlyActiveSubscription == product.productIdentifier{
            
            let url = URL(string: "itms-apps://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/DirectAction/manageSubscriptions")
            if #available(iOS 10, *){
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url!)
            }
            
        }else{
            SplashVC.fromSplash = false
            if !alreadyPurchased{
                RazeFaceProducts.store.buyProduct(product)
                print("product.productIdentifier\(product.productIdentifier)")
                self.view.makeToast("Please Wait...", point: CGPoint(x:self.view.center.x, y: self.view.frame.maxY - 100), title: "", image: nil, completion: nil)
                tableView.reloadData()
                
            }else{
                
            }
        }
    }
    
    func setPurchaseData(productId : String,expiryDate:String,fromStart:Bool) {
        for b in BILLING_DETAILS {
            
            switch (b.billing_type) {
            case Billing_Pro:
                if productId == b.product_id{
                    setPurchaseText(status:true,productId,expiryDate, checkstatus: fromStart)
                    UserDefaults.standard.set(true, forKey: PRO_PURCHASED)
                    IS_PRO = UserDefaults.standard.bool(forKey: PRO_PURCHASED)
                }
                break
                
            case Billing_Free:
                if productId == b.product_id{
                    setPurchaseText(status:true,productId,expiryDate, checkstatus: fromStart)
                    UserDefaults.standard.set(true, forKey: FREE_PURCHASED)
                    IS_FREE = UserDefaults.standard.bool(forKey: FREE_PURCHASED)
                }
                break
                
            case Billing_Weekly:
                if productId == b.product_id  {
                    setPurchaseText(status:true,productId,expiryDate,checkstatus: fromStart)
                    UserDefaults.standard.set(true, forKey: WEEKLY_PURCHASED)
                    IS_WEEKLY = UserDefaults.standard.bool(forKey: WEEKLY_PURCHASED)
                }
                break
                
            case Billing_Monthly:
                if productId == b.product_id {
                    setPurchaseText(status:true,productId,expiryDate,checkstatus: fromStart)
                    UserDefaults.standard.set(true, forKey: MONTHLY_PURCHASED)
                    IS_MONTHLY = UserDefaults.standard.bool(forKey: MONTHLY_PURCHASED)
                    
                }
                break
                
            case Billing_Quarterly:
                if productId == b.product_id {
                    setPurchaseText(status:true,productId,expiryDate,checkstatus: fromStart)
                    UserDefaults.standard.set(true, forKey: QUATERLY_PURCHASED)
                    IS_QUARTERLY = UserDefaults.standard.bool(forKey: QUATERLY_PURCHASED)
                }
                break
                
            case Billing_HalfYear:
                if productId == b.product_id {
                    setPurchaseText(status:true,productId,expiryDate,checkstatus: fromStart)
                    UserDefaults.standard.set(true, forKey: HALF_YEARLY_PURCHASED)
                    IS_HALFYEARLY = UserDefaults.standard.bool(forKey: HALF_YEARLY_PURCHASED)
                    
                }
                break;
                
            case Billing_Yearly:
                if productId == b.product_id {
                    setPurchaseText(status:true,productId,expiryDate,checkstatus: fromStart)
                    UserDefaults.standard.set(true, forKey: YEARLY_PURCHASED)
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
                
                UserDefaults.standard.set(false, forKey: PRO_PURCHASED)
                IS_PRO = UserDefaults.standard.bool(forKey: PRO_PURCHASED)
                
                break;
            case Billing_Free:
                
                UserDefaults.standard.set(false, forKey: FREE_PURCHASED)
                IS_FREE = UserDefaults.standard.bool(forKey: FREE_PURCHASED)
                
                break;
                
            case Billing_Weekly:
                
                UserDefaults.standard.set(false, forKey: WEEKLY_PURCHASED)
                IS_WEEKLY = UserDefaults.standard.bool(forKey: WEEKLY_PURCHASED)
                
                break;
                
            case Billing_Monthly:
                
                UserDefaults.standard.set(false, forKey: MONTHLY_PURCHASED)
                IS_MONTHLY = UserDefaults.standard.bool(forKey: MONTHLY_PURCHASED)
                
                break;
                
            case Billing_Quarterly:
                
                UserDefaults.standard.set(false, forKey: QUATERLY_PURCHASED)
                IS_QUARTERLY = UserDefaults.standard.bool(forKey: QUATERLY_PURCHASED)
                
                break;
                
            case Billing_HalfYear:
                
                UserDefaults.standard.set(false, forKey: HALF_YEARLY_PURCHASED)
                IS_HALFYEARLY = UserDefaults.standard.bool(forKey: HALF_YEARLY_PURCHASED)
                
                break;
                
            case Billing_Yearly:
                
                UserDefaults.standard.set(false, forKey: YEARLY_PURCHASED)
                IS_YEARLY = UserDefaults.standard.bool(forKey: YEARLY_PURCHASED)
                break;
                
            default:
                break;
            }
        }
    }
    
    func setPurchaseText(status:Bool,_ productId:String,_ expiryDate:String,checkstatus:Bool){
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async { [self] in
                if status{
                    alreadyPurchased = true
                    if !checkstatus{
                        adsView.isHidden = true
                        adsViewHeightConstraint.constant = 0
                        //                        continueButton.setTitle("Continue", for: .normal)
                        let myNormalAttributedTitle = NSAttributedString(string: "Continue",
                                                                         attributes: [NSAttributedString.Key.underlineStyle : 1])
                        
                        
                        continueButton.setAttributedTitle(myNormalAttributedTitle, for: .normal)
                    }
                    currentlyActiveSubscription = productId
                    tableView.reloadData()
                }else{
                    
                }
            }
        }
    }
    
    func inAppPurchaseSuccess(productID: String, expiryDate: String, latest_receipt: String, fromStart: Bool) {
        print("purchased")
        
        setPurchaseData(productId: productID, expiryDate: expiryDate,fromStart:fromStart)
    }
    
    func inAppPurchaseFailed() {
        print("failed")
        setExpirePurchaseData()
    }
    
}

//extension UITableView {
//
//    @IBInspectable
//    var isEmptyRowsHidden: Bool {
//        get {
//            return tableFooterView != nil
//        }
//        set {
//            if newValue {
//                tableFooterView = UIView(frame: .zero)
//            } else {
//                tableFooterView = nil
//            }
//        }
//    }
//}

