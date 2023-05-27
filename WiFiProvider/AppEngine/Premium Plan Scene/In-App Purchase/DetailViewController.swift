//
//  DetailViewController.swift
//  CustomGallery
//
//  Created by Pulkit Babbar on 27/07/20.
//  Copyright © 2020 Pavle Pesic. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView?
  
  var image: UIImage? {
    didSet {
      configureView()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }
  
  func configureView() {
    imageView?.image = image
  }
}

