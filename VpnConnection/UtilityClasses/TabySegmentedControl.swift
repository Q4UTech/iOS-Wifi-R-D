//
//  TabySegmentControl.swift
//  WiFiProvider
//
//  Created by gautam  on 19/05/23.
//

import Foundation
import UIKit

class TabySegmentedControl: UISegmentedControl {
    
//    func drawRect(){
//        super.drawRect()
//        initUI()
//    }
    
    func initUI(){
        setupBackground()
        setupFonts()
    }
    
    func setupBackground(){
        let backgroundImage = UIImage(named: "trans_3")
        let dividerImage = UIImage(named: "trans_3")
        let backgroundImageSelected = UIImage(named: "two")
        
        self.setBackgroundImage(backgroundImage, for: UIControl.State(), barMetrics: .default)
        self.setBackgroundImage(backgroundImageSelected, for: .highlighted, barMetrics: .default)
        self.setBackgroundImage(backgroundImageSelected, for: .selected, barMetrics: .default)
        
        self.setDividerImage(dividerImage, forLeftSegmentState: UIControl.State(), rightSegmentState: .selected, barMetrics: .default)
        self.setDividerImage(dividerImage, forLeftSegmentState: .selected, rightSegmentState: UIControl.State(), barMetrics: .default)
        self.setDividerImage(dividerImage, forLeftSegmentState: UIControl.State(), rightSegmentState: UIControl.State(), barMetrics: .default)
    }
    
    func setupFonts(){
        let font = UIFont.systemFont(ofSize: 16.0)
        let normalTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: font
        ]
        
        self.setTitleTextAttributes(normalTextAttributes, for: UIControl.State())
        self.setTitleTextAttributes(normalTextAttributes, for: .highlighted)
        self.setTitleTextAttributes(normalTextAttributes, for: .selected)
    }
    
}
