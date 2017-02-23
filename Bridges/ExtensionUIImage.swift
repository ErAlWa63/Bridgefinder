//
//  ExtensionUIImage.swift
//  Bridges
//
//  Created by Erik Waterham on 01/11/2016.
//  Copyright © 2016 TL. All rights reserved.
//
import UIKit

extension UIImage {
    func resizedImage(newSize: CGSize) -> UIImage {
        guard self.size != newSize else { return self }
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func resizedImageWithinRect(rectSize: CGSize) -> UIImage {
        let widthFactor = size.width / rectSize.width
        let heightFactor = size.height / rectSize.height
        var resizeFactor = widthFactor
        if size.height > size.width {
            resizeFactor = heightFactor
        }
        return resizedImage(newSize: CGSize(width: size.width/resizeFactor, height: size.height/resizeFactor))
    }
    
}
