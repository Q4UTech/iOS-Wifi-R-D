//
//  CountryTableViewCell.swift
//  WiFiProvider
//
//  Created by gautam  on 16/05/23.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    @IBOutlet weak var selectedButton: UIButton!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var countryFlagImage: UIImageView!
    @IBOutlet weak var countrybgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
       
        
        super.setSelected(selected, animated: animated)
    }
    
    func setIcon(iconName:String){
        if #available(iOS 13.0, *) {
            selectedButton.setImage(UIImage(systemName:iconName), for: .normal)
        } else {
            
        }
    }

}

