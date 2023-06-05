//
//  LanguageVC.swift
//  Q4U_ScreenRecording
//
//  Created by Deepti Chawla on 15/07/21.
//

import UIKit

class LanguageVC: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    var nameArr =   [MyConstant.constant.kEnglish,MyConstant.constant.kFrench,MyConstant.constant.kDutch,MyConstant.constant.kHindi,MyConstant.constant.kSpanish,MyConstant.constant.kKorean,MyConstant.constant.kArabic, MyConstant.constant.kPortuguese]
      
    var langCode = [MyConstant.languageCode.kEn,MyConstant.languageCode.kFr,MyConstant.languageCode.kNl,MyConstant.languageCode.kHi,MyConstant.languageCode.kEs,MyConstant.languageCode.kKo,MyConstant.languageCode.kAr,MyConstant.languageCode.kPT]
      
      var langCodeArr = [MyConstant.languageCode.kEn,MyConstant.languageCode.kFr,MyConstant.languageCode.kNl,MyConstant.languageCode.kHi,MyConstant.languageCode.kEs,MyConstant.languageCode.kKo,MyConstant.languageCode.kAr,MyConstant.languageCode.kPT]
      
    var flagArr = ["english","french","dutch","hindi","spanish","korean","arabic","portugese"]
    @IBOutlet weak var backButtonAction: UIButton!
    @IBOutlet weak var languageTableView: UITableView!
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    var fulladstatus = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
      //  lightTheme()
        languageTableView.delegate = self
        languageTableView.dataSource = self
        languageTableView.allowsMultipleSelection = false
        languageTableView.showsVerticalScrollIndicator = false
        languageTableView.showsHorizontalScrollIndicator = false
        languageTableView.backgroundColor = UIColor.clear
        languageTableView.isScrollEnabled = true
        languageTableView.separatorStyle = .none
        languageTableView.tableFooterView = UIView(frame: CGRect.zero)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getBannerAd(self, adView, heightConstraint)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
       // self.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"LanguageCell", for: indexPath) as? LanguageCell else { return UITableViewCell() }
        
        let flag = String.emojiFlag(for: langCodeArr[indexPath.row])
        print("flagdata\(flagArr[indexPath.row])")
        var newFlag = ""
        
        
       
        cell.titleLabel.text! = nameArr[indexPath.row]
      
            cell.iconLabel.image = UIImage(named: flagArr[indexPath.row])
            
      
        if  UserDefaults.standard.value(forKey: MyConstant.constant.APPLE_LANGUAGE) as! String == langCode[indexPath.row] {
            cell.languageSelectedButton.setImage(UIImage(named: "selected_icon"), for: .normal)
        }else{
            cell.languageSelectedButton.setImage(UIImage(named: "unselected_icon"), for: .normal)
        }
        
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        LanguageSelectionListener.instanceHelper.languageSelection(name: nameArr[indexPath.row], code: langCode[indexPath.row])
        UserDefaults.standard.set(langCode[indexPath.row], forKey: MyConstant.constant.APPLE_LANGUAGE)
        print("ads called")
       
       //self.dismiss(animated: true, completion: nil)
       navigationController?.popViewController(animated: true)
      // showFullAds(viewController: self, isForce: true)
       
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }

    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        showFullAds(viewController: self, isForce: false)
       // self.dismiss(animated: true, completion: nil)
    }
    
}

extension String {
    
    static func emojiFlag(for countryCode: String) -> String! {
        func isLowercaseASCIIScalar(_ scalar: Unicode.Scalar) -> Bool {
            return scalar.value >= 0x61 && scalar.value <= 0x7A
        }
        
        func regionalIndicatorSymbol(for scalar: Unicode.Scalar) -> Unicode.Scalar {
            precondition(isLowercaseASCIIScalar(scalar))
            
            return Unicode.Scalar(scalar.value + (0x1F1E6 - 0x61))!
        }
        
        let lowercasedCode = countryCode.lowercased()
        guard lowercasedCode.count == 2 else { return nil }
        guard lowercasedCode.unicodeScalars.reduce(true, { accum, scalar in accum && isLowercaseASCIIScalar(scalar) }) else { return nil }
        
        let indicatorSymbols = lowercasedCode.unicodeScalars.map({ regionalIndicatorSymbol(for: $0) })
        return String(indicatorSymbols.map({ Character($0) }))
    }
}
