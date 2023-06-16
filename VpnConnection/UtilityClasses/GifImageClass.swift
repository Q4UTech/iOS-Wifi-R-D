//
//  GifImageClass.swift
//  WiFiProvider
//
//  Created by gautam  on 16/05/23.
//

import Foundation
//
//  GifImageClass.swift
//  Q4U_ChargingPlay
//
//  Created by Deepti Chawla on 18/01/21.
//

import Foundation
import UIKit
extension UIImageView {
//    func setGIFImage(name: String, repeatCount: Int = 0 ,durationinSec:TimeInterval) {
//        DispatchQueue.global().async {
//            if let gif = UIImage.makeGIFFromCollection(name: name, repeatCount: repeatCount,durationinSec:durationinSec) {
//                DispatchQueue.main.async {
//                    self.setImage(withGIF: gif)
//                    self.startAnimating()
//                }
//            }
//        }
//    }

    private func setImage(withGIF gif: GIF) {
        animationImages = gif.images
        animationDuration = gif.durationInSec
        animationRepeatCount = gif.repeatCount
    }
}

extension UIImage {
    class func makeGIFFromCollection(name: String, repeatCount: Int = 0,durationinSec:TimeInterval) -> GIF? {
        guard let path = Bundle.main.path(forResource: name, ofType: "gif") else {
            print("Cannot find a path from the file \"\(name)\"")
            return nil
        }

        let url = URL(fileURLWithPath: path)
        let data = try? Data(contentsOf: url)
        guard let d = data else {
            print("Cannot turn image named \"\(name)\" into data")
            return nil
        }

        return makeGIFFromData(data: d, repeatCount: repeatCount,durationinSec: durationinSec)
    }

    class func makeGIFFromData(data: Data, repeatCount: Int = 0,durationinSec:TimeInterval) -> GIF? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("Source for the image does not exist")
            return nil
        }

        let count = CGImageSourceGetCount(source)
        var images = [UIImage]()
        let duration = 0.0

        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let image = UIImage(cgImage: cgImage)
                images.append(image)

              //  let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
//                                                                source: source)
              //  duration += delaySeconds
            }
        }

        return GIF(images: images, durationInSec:durationinSec , repeatCount: repeatCount)
    }


}

class GIF: NSObject {
    let images: [UIImage]
    let durationInSec: TimeInterval
    let repeatCount: Int

    init(images: [UIImage], durationInSec: TimeInterval, repeatCount: Int = 0) {
        self.images = images
        self.durationInSec = durationInSec
        self.repeatCount = repeatCount
    }
}
