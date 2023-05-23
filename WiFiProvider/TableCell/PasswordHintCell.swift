//
//  PasswordHintCell.swift
//  WiFiProvider
//
//  Created by gautam  on 23/05/23.
//

import UIKit

class PasswordHintCell: UITableViewCell {
    @IBOutlet weak var brand:UILabel!
    @IBOutlet weak var type:UILabel!
    @IBOutlet weak var username:UILabel!
    @IBOutlet weak var password:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
