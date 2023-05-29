//
//  PurchaseCell.swift
//  Q4U-CAM SCANNER
//
//  Created by Pulkit Babbar on 16/08/21.
//

import UIKit

class PurchaseCell: UITableViewCell {

    @IBOutlet weak var dividerLabel: UILabel!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var selectedPlanImg: UIImageView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var memberLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
