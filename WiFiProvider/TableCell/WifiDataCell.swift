//
//  WifiDataCell.swift
//  WiFiProvider
//
//  Created by gautam  on 18/05/23.
//

import UIKit

class WifiDataCell: UITableViewCell {
    @IBOutlet weak var bestName:UILabel!
    @IBOutlet weak var bestTypes:UIImageView!
    @IBOutlet weak var ipAddress:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
