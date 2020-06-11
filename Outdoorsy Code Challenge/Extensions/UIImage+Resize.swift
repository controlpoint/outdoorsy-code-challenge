//
//  UIImage+Resize.swift
//  Outdoorsy Code Challenge
//
//  Created by Alonzo Wilkins on 6/10/20.
//  Copyright © 2020 Anchor Point. All rights reserved.
//

import UIKit

extension UIImage {
    
    func ofSize(_ size: CGSize) -> UIImage? {
        
        let rect = CGRect(origin: .zero, size: size)
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        
        self.draw(in: rect)
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resultImage
    }

}
