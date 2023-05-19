//
//  RouterVC.swift
//  WiFiProvider
//
//  Created by gautam  on 16/05/23.
//

import UIKit
import MASegmentedControl

class RouterVC: UIViewController {
//    func change(to index: Int) {
//       print("index \(index)")
//    }
//
//    //    @IBOutlet weak var adView:UIView!
//    //    @IBOutlet weak var heightConstraint:NSLayoutConstraint!
//    //    @IBOutlet weak var transView:UIView!
//    @IBOutlet weak var interfaceSegmented: CustomSegmentedControl!{
//        didSet{
//            interfaceSegmented.setButtonTitles(buttonTitles: ["Password","Guide"])
//            interfaceSegmented.selectorViewColor = .orange
//            interfaceSegmented.selectorTextColor = .orange
//        }
//
//    }
     
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
        segmentedControl.initUI()
        segmentedControl.selectedSegmentIndex = TabIndex.firstChildTab.rawValue
        displayCurrentTab(TabIndex.firstChildTab.rawValue)
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
}
