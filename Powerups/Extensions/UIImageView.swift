//
//  UIImageView.swift
//  Powerups
//
//  Created by Sean Orelli on 12/6/18.
//  Copyright © 2018 Sean Orelli. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setImage(imageURL: URL) {
        backgroundQueue {
            let imageViewSize = self.bounds.size
            let downsampledImage = UIImage.downsample(imageAt: imageURL, to: imageViewSize, scale: UIScreen.main.scale)
            mainQueue {
                self.image = downsampledImage
            }
        }
    }
    
}
