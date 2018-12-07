//
// Created by Andrew Grosner on 2018-10-01.
// Copyright (c) 2018 Fuzz. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {

    func pillYellow() {
        backgroundColor = .papayaLight
        layer.cornerRadius = 12.0
        layer.borderWidth = 0.0
        layer.borderColor = .none
        clipsToBounds = true
        textColor = .white
        font = .captionPillText
    }
    
    override func design() {
        super.design()
        //backgroundColor = UIColor.clear
        font = UIFont.boldSystemFont(ofSize: 24)
        textColor = UIColor.cellTextColor
    }
}

