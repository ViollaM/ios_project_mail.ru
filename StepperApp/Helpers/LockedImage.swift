//
//  LockedImage.swift
//  StepperApp
//
//  Created by Ruben Egikian on 11.12.2021.
//

import Foundation
import UIKit

extension UIImage {
    func mergeWith(topImage: UIImage) -> UIImage {
        let bottomImage = self
        let width = bottomImage.size.width
        let height = bottomImage.size.height
        UIGraphicsBeginImageContext(size)
        let areaSize = CGRect(x: 0, y: 0, width: width, height: height)
        let centerAreaSize = CGRect(x: width/4, y: height/4, width: width/2, height: height/2)
        bottomImage.draw(in: areaSize, blendMode: .darken, alpha: 0.1)
        topImage.draw(in: centerAreaSize, blendMode: .normal, alpha: 1.0)
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return mergedImage
    }
}
