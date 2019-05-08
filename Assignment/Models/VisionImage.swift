//
//  VisionImage.swift
//  Assignment
//
//  Created by Ellen Wang on 2019/2/19.
//  Copyright © 2019 ellen. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct VisionImage {
    let image: UIImage
    
    init(image: UIImage) {
        image.imageOrientation == .up
            self.image = image
       }
}


