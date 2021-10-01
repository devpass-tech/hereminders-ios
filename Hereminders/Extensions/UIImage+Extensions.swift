//
//  UIImage+Extensions.swift
//  Hereminders
//
//  Created by Bruna Drago on 28/09/21.
//  Copyright © 2021 Rodrigo Borges. All rights reserved.
//

import UIKit

extension UIImage {
    
    func resizeImage(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        return resizedImage
    }
}
