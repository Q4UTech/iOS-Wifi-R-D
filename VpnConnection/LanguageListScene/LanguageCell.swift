//
//  LanguageCell.swift
//  Q4U_ScreenRecording
//
//  Created by Deepti Chawla on 15/07/21.
//

import UIKit

class LanguageCell: UITableViewCell {

    @IBOutlet weak var languageSelectedButton: UIButton!
    @IBOutlet weak var iconLabel: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
