//
// Created by Andrew Grosner on 2018-09-28.
// Copyright (c) 2018 Fuzz. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    func roundedCorners(corners: CACornerMask, cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = corners
        clipsToBounds = true
    }

}
