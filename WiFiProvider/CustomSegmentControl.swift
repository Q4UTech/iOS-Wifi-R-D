//
//  CustomSegmentControl.swift
//  WiFiProvider
//
//  Created by gautam  on 16/05/23.
//

import Foundation
import UIKit

class CustomSegmentedControl: UISegmentedControl {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateSelectedSegmentBorder()
    }
    
    func updateSelectedSegmentBorder() {
        // Remove any existing border layers
//        layer.sublayers?.filter { $0.name == "segmentBorderLayer" }.forEach { $0.removeFromSuperlayer() }
//
//        // Create a new border layer for the selected segment
//        let borderLayer = CALayer()
//        borderLayer.name = "segmentBorderLayer"
//        borderLayer.backgroundColor = UIColor.red.cgColor // Customize the border color as desired
//        borderLayer.frame = CGRect(x: 0, y: bounds.height - 2, width: bounds.width / CGFloat(numberOfSegments), height: 2)
//        layer.addSublayer(borderLayer)
        layer.sublayers?.filter { $0.name == "segmentBorderLayer" }.forEach { $0.removeFromSuperlayer() }

                // Create a new border layer for the selected segment
                if let selectedSegmentLayer = layer.sublayers?[selectedSegmentIndex] {
                    let borderLayer = CALayer()
                    borderLayer.name = "segmentBorderLayer"
                    borderLayer.backgroundColor = UIColor.red.cgColor // Customize the border color as desired
                    borderLayer.frame = CGRect(x: selectedSegmentLayer.frame.origin.x, y: bounds.height - 2, width: selectedSegmentLayer.frame.width, height: 2)
                    layer.addSublayer(borderLayer)
                }
    }
}
