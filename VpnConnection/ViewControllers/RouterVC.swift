//
//  RouterVC.swift
//  WiFiProvider
//
//  Created by gautam  on 16/05/23.
//

import UIKit
import MASegmentedControl

class RouterVC: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var searchData:UITextField!
    @IBOutlet weak var searchButton:UIButton!
    @IBOutlet weak var closeButton:UIButton!
    @IBOutlet weak var searchView:UIView!
    @IBOutlet weak var premiumView:UIView!
    @IBOutlet weak var premiumViewDialog:UIView!
    @IBOutlet weak var backBtn:UIButton!
    @IBOutlet weak var btnWidth:NSLayoutConstraint!
     var isFrom = Bool()
    enum TabIndex : Int {
           case firstChildTab = 0
           case secondChildTab = 1
       }

       @IBOutlet weak var segmentedControl: TabySegmentedControl!
       @IBOutlet weak var contentView: UIView!
       
       var currentViewController: UIViewController?
       lazy var firstChildTabVC: UIViewController? = {
           let firstChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "PasswordHintVC")
           as! PasswordHintVC
           return firstChildTabVC
       }()
       lazy var secondChildTabVC : UIViewController? = {
           let secondChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "RouterHintVC") as! RouterHintVC
           
           return secondChildTabVC
       }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.borderWidth = 1
        searchView.backgroundColor = hexStringColor(hex: "#27292C")
        searchView.borderColor = hexStringColor(hex:"#OD323437")
        searchData.delegate = self
        premiumViewDialog.borderWidth = 1
        premiumViewDialog.borderColor = .white
        segmentedControl.initUI()
        segmentedControl.selectedSegmentIndex = TabIndex.firstChildTab.rawValue
        displayCurrentTab(TabIndex.firstChildTab.rawValue)
        if hasPurchased(){
            premiumView.isHidden = true
            
        }else{
            premiumView.isHidden = false
        }
       
        if isFrom{
           
            hideUnhide(isShow: false,value: 40)
        }else{
           
            hideUnhide(isShow: true,value: 0)

        }
        
    }
    func hideUnhide(isShow:Bool,value:Int){
        backBtn.isHidden = isShow
        btnWidth.constant = CGFloat(value)
    }
    
    
    @IBAction func goPremium(_ sender:UIButton){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PurchaseVC") as! PurchaseVC
        navigationController?.pushViewController(vc, animated: true)
        showFullAds(viewController: self, isForce: false)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let searchText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
               // searchNotes(textData: searchText)
        SearchController.instanceHelper.searchData(searchDarta: searchText)
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           if let currentViewController = currentViewController {
               currentViewController.viewWillDisappear(animated)
           }
       }
       
       // MARK: - Switching Tabs Functions
       @IBAction func switchTabs(_ sender: UISegmentedControl) {
           self.currentViewController!.view.removeFromSuperview()
           self.currentViewController!.removeFromParent()
           
           displayCurrentTab(sender.selectedSegmentIndex)
       }
       
       func displayCurrentTab(_ tabIndex: Int){
           if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
               
               self.addChild(vc)
               vc.didMove(toParent: self)
               
               vc.view.frame = self.contentView.bounds
               self.contentView.addSubview(vc.view)
               self.currentViewController = vc
           }
       }
       
       func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
           var vc: UIViewController?
           switch index {
           case TabIndex.firstChildTab.rawValue :
               vc = firstChildTabVC
           case TabIndex.secondChildTab.rawValue :
               vc = secondChildTabVC
           default:
           return nil
           }
       
           return vc
       }
    
    @IBAction func back(_ sender:UIButton){
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func openSearch(_ sender:UIButton){
        searchData.becomeFirstResponder()
        hideUnhideView(isSearch: false, isSearchBtn: true, isCloseBtn: false)
    }
    
    @IBAction func closeSearch(_ sender:UIButton){
        searchData.resignFirstResponder()
        searchData.text = ""
        hideUnhideView(isSearch: true, isSearchBtn: false, isCloseBtn: true)
       
    }
    
    func hideUnhideView(isSearch:Bool,isSearchBtn:Bool,isCloseBtn:Bool){
        searchView.isHidden = isSearch
        searchButton.isHidden = isSearchBtn
        closeButton.isHidden = isCloseBtn
    }
}
