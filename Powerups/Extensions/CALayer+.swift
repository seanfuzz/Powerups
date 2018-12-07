//
// Created by Andrew Grosner on 9/11/18.
// Copyright (c) 2018 Fuzz. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    func applySketchShadow(
            color: UIColor = .black,
            alpha: Float = 0.1,
            x: CGFloat = 0,
            y: CGFloat = 1,
            blur: CGFloat = 4,
            spread: CGFloat = 0) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        let dx = -spread
        let rect = bounds.insetBy(dx: dx, dy: dx)
        shadowPath = UIBezierPath(rect: rect).cgPath
    }
}