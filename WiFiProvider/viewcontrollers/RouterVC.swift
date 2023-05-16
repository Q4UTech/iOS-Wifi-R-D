//
//  RouterVC.swift
//  WiFiProvider
//
//  Created by gautam  on 16/05/23.
//

import UIKit
import MASegmentedControl

class RouterVC: UIViewController {
    //    @IBOutlet weak var adView:UIView!
    //    @IBOutlet weak var heightConstraint:NSLayoutConstraint!
    //    @IBOutlet weak var transView:UIView!
    @IBOutlet var linearThumbViewSegmentedControl: MASegmentedControl! {
        didSet {
            //Set this booleans to adapt control
            linearThumbViewSegmentedControl.itemsWithText = true
            linearThumbViewSegmentedControl.fillEqually = true
            linearThumbViewSegmentedControl.bottomLineThumbView = true
            
            linearThumbViewSegmentedControl.setSegmentedWith(items: ["Option 1", "Option 2"])
            linearThumbViewSegmentedControl.padding = 2
            linearThumbViewSegmentedControl.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            linearThumbViewSegmentedControl.selectedTextColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            linearThumbViewSegmentedControl.thumbViewColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let segmentedControl = CustomSegmentedControl(items: ["Segment 1", "Segment 2", "Segment 3"])
        segmentedControl.frame = CGRect(x: 50, y: 100, width: 300, height: 40)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        view.addSubview(segmentedControl)
    }
    
    @objc func segmentedControlValueChanged(_ segmentedControl: UISegmentedControl) {
        if let customSegmentedControl = segmentedControl as? CustomSegmentedControl {
            customSegmentedControl.updateSelectedSegmentBorder()
        }
    }
    
    
    
}
