//
//  imageCache.swift
//  Bridges
//
//  Created by Erik Waterham on 01/11/2016.
//  Copyright © 2016 TL. All rights reserved.
//

import UIKit

class ImageObject {
    var photo     : UIImage
    var pictogram : UIImage
    
    init( photo: UIImage) {
        self.photo     = photo
        self.pictogram = photo.resizedImageWithinRect(rectSize: CGSize(width: 50, height: 40))
    }

}
