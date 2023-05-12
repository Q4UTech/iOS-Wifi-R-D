//
//  MenuVC.swift
//  WiFiProvider
//
//  Created by gautam  on 28/04/23.
//

import UIKit
enum MenuType: Int {
    case home
    case camera
    case settings
}
protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}
class MenuVC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var profileClickButton: UIButton!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var overLayButton: UIButton!
    @IBOutlet weak var menuTable: UITableView!
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    @IBOutlet  var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    var arrayMenuList = [Dictionary<String,String>]()
    var didTapMenuType: ((MenuType) -> Void)?
    var btnMenu : UIButton!
    var name = String()
    
    var delegate : SlideMenuDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
       
        setupMainCardView()
        setupBlurView()
       
//        self.userName.text = UserDefaults.standard.value(forKey: PROFILE_NAME) as! String
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        menuTable.tableFooterView = UIView()
      
    }
    
    func setupMainCardView() {
           
        baseView.addGradientWithColor1( color: UIColorFromHex(rgbValue: 0x56ADF2,alpha: 0.8), color1: UIColorFromHex(rgbValue: 0x0064FE,alpha: 0.8),view: baseView
        )
        
    }
    
    func setupBlurView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = baseView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.addSubview(blurEffectView)
        blurView.alpha = 0.8
    }
    

    @IBAction func profileClickButtonAction(_ sender: Any) {
//        let valCheck = UserDefaults.standard.bool(forKey: ALREADY_LOGIN)
//        if valCheck{
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC
          //  vc!.menuType = "menuType"
            self.navigationController?.pushViewController(vc!, animated: true)
//        }
//        else {
//
//            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
//            vc!.controllerType = "shareLinkType"
//            self.navigationController?.pushViewController(vc!, animated: true)
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arrayMenuList.removeAll()
        updateMenu()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        btnMenu.tag = 0
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
    }
    
    @IBAction func ortderTrackButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func goToLoginButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func overLayButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func onCloseMenuClick(_ button:UIButton!){
        btnMenu.tag = 0
        
        if (self.delegate != nil) {
            var index = Int32(button.tag)
            if(button == self.btnCloseMenuOverlay){
                index = -1
            }
            
            if(index > 0){
                if(arrayMenuList[Int(index)]["title"]! == "Exit App"){
                    delegate?.slideMenuItemSelectedAtIndex(9)
                }else{
                    delegate?.slideMenuItemSelectedAtIndex(index)
                }
            }else{
                delegate?.slideMenuItemSelectedAtIndex(index)
            }
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
    }
    
    func updateMenu(){
     
        arrayMenuList.append(["title":"Language", "icon":"language.png"])
       // arrayMenuList.append(["title":"Logout".localiz(), "icon":"logoutIcon.png"])
        arrayMenuList.append(["title":"Rate App", "icon":"rateApp.png"])
        arrayMenuList.append(["title":"Set Icon", "icon":"icon_option.png"])
        
        arrayMenuList.append(["title":"More Apps", "icon":"moreIcon.png"])
        arrayMenuList.append(["title":"Share App", "icon":"shareApp"])
        arrayMenuList.append(["title":"Feedback", "icon":"feedbackIcon.png"])
        arrayMenuList.append(["title":"About us", "icon":"aboutUs.png"])
      
        
        arrayMenuList.append(["title":"Exit App", "icon":"exitIcon.png"])
        menuTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "MenuListCell")!
        menuTable.rowHeight = 80
        let lblTitle : UILabel = cell.contentView.viewWithTag(101) as! UILabel
        let imgIcon : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        
        imgIcon.image = UIImage(named: arrayMenuList[indexPath.row]["icon"]!)
        lblTitle.text = arrayMenuList[indexPath.row]["title"]!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.tag = indexPath.row
        self.onCloseMenuClick(btn)
    }




}
