//
//  UnderlineView.swift
//  WiFiProvider
//
//  Created by gautam  on 19/05/23.
//

import Foundation

import UIKit

class UnderlineView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        // Set the initial frame for the underline
        frame = CGRect(x: 0, y: bounds.height - 2, width: bounds.width, height: 2)
        backgroundColor = UIColor.red // Set the color as per your requirement
    }
}
