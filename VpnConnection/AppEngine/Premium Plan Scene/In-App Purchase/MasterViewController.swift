//
//  MasterViewController.swift
//  CustomGallery
//
//  Created by Pulkit Babbar on 27/07/20.
//  Copyright © 2020 Pavle Pesic. All rights reserved.
//

import UIKit
import StoreKit

class MasterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var purchaseNowButton: UIButton!
    @IBOutlet weak var adsTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let showDetailSegueIdentifier = "showDetail"
    var products: [SKProduct] = []
    var counter = 5
    var timer: Timer?
    var alertController = UIAlertController(title: nil, message: "Please wait\n\n", preferredStyle: .alert)
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == showDetailSegueIdentifier {
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return false
            }
            
            let product = products[(indexPath as NSIndexPath).row]
            
            return RazeFaceProducts.store.isProductPurchased(product.productIdentifier)
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showDetailSegueIdentifier {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let product = products[(indexPath as NSIndexPath).row]
            
            if let name = resourceNameForProductIdentifier(product.productIdentifier),
               let detailViewController = segue.destination as? DetailViewController {
                let image = UIImage(named: name)
                detailViewController.image = image
            }
        }
    }
    
    private func startTimer() {
        self.counter = 5
        let spinnerIndicator = UIActivityIndicatorView(style: .whiteLarge)
        spinnerIndicator.center = CGPoint(x: 135.0, y: 65.5)
        spinnerIndicator.color = UIColor.black
        spinnerIndicator.startAnimating()
        
        alertController.view.addSubview(spinnerIndicator)
        self.present(alertController, animated: false, completion: nil)
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    
    //MARK: Update Timer Function
    @objc func updateTimer() {
        print(self.counter)
        if counter != 0 {
            counter -= 1
        } else {
            if let timer = self.timer {
                timer.invalidate()
                self.timer = nil
                alertController.dismiss(animated: true, completion: nil);
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        startTimer()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        //        for billingDetails in BILLING_DETAILS{
        //            if billingDetails.billing_type  == "free"{
        //                let details_description = billingDetails.details_description
        //                adsTitleLabel.text = details_description
        //            }
        //        }
        
        title = "RazeFaces"
        
        //        refreshControl = UIRefreshControl()
        //        refreshControl?.addTarget(self, action: #selector(MasterViewController.reload), for: .valueChanged)
        
        let restoreButton = UIBarButtonItem(title: "Restore",
                                            style: .plain,
                                            target: self,
                                            action: #selector(MasterViewController.restoreTapped(_:)))
        navigationItem.rightBarButtonItem = restoreButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(MasterViewController.handlePurchaseNotification(_:)),
                                               name: .IAPHelperPurchaseNotification,
                                               object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reload()
    }
    @IBAction func purchaseNowAction(_ sender: Any) {
        for product in products {
            //            self.view.makeToast("Please wait till the transaction starts", duration: 5.0, position: .bottom)
            print("productcheck\(product.productIdentifier)")
            if product.productIdentifier == "com.camscanner.3month"{
                RazeFaceProducts.store.buyProduct(product)
            }
            
        }
    }
    
    
    @IBAction func weeklySubscriptionAction(_ sender: Any) {
        for product in products {
            //            self.view.makeToast("Please wait till the transaction starts", duration: 5.0, position: .bottom)
            print("productcheck\(product.productIdentifier)")
            if product.productIdentifier == "com.camscanner.1month"{
                RazeFaceProducts.store.buyProduct(product)
            }
            
            
        }
        
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    @IBAction func restoreButtonAction(_ sender: Any) {
        //        self.view.makeToast("Please wait", duration: 5.0, position: .bottom)
        //        RazeFaceProducts.store.restorePurchases()
        //        NotificationCenter.default.addObserver(self, selector: #selector(MasterViewController.handlePurchaseNotification(_:)),
        //                                               name: .IAPHelperPurchaseNotification,
        //                                               object: nil)
        
        for product in products {
            //            self.view.makeToast("Please wait till the transaction starts", duration: 5.0, position: .bottom)
            print("productcheck\(product.productIdentifier)")
            if product.productIdentifier == "com.camscanner.1year"{
                RazeFaceProducts.store.buyProduct(product)
            }
            
            
        }
        
    }
    
    @objc func reload() {
        products = []
        
        tableView.reloadData()
        
        RazeFaceProducts.store.requestProducts{ [weak self] success, products in
            guard let self = self else { return }
            if success {
                self.products = products!
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                
            }
            
            //            self.refreshControl?.endRefreshing()
        }
    }
    
    @objc func restoreTapped(_ sender: AnyObject) {
        RazeFaceProducts.store.restorePurchases(fromStart: true)
    }
    
    @objc func handlePurchaseNotification(_ notification: Notification) {
        guard
            let productID = notification.object as? String,
            let index = products.index(where: { product -> Bool in
                product.productIdentifier == productID
            })
        else { return }
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)        
    }
}

// MARK: - UITableViewDataSource

extension MasterViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductCell
        
        cell.isUserInteractionEnabled = false
        
        let product = products[(indexPath as NSIndexPath).row]
        cell.product = product
        cell.buyButtonHandler = { product in
            RazeFaceProducts.store.buyProduct(product)
        }
        return cell
    }
}

