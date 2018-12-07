//
// Created by Andrew Grosner on 2018-09-28.
// Copyright (c) 2018 Fuzz. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    
    static var borderWidth: CGFloat {
        if UIColor.darkTheme { return 0 }
        return 1
    }

    func roundedCorners(corners: CACornerMask, cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = corners
        clipsToBounds = true
    }

    var borderColor: UIColor? {
        get{ if let border = layer.borderColor { return UIColor(cgColor: border)} else { return nil } }
        set(c) { layer.borderColor = c?.cgColor }
    }
    
    var borderWidth: CGFloat {
        get{ return layer.borderWidth }
        set(c) { layer.borderWidth = c }
    }
    
    var cornerRadius: CGFloat {
        get{ return layer.cornerRadius }
        set(c) { layer.cornerRadius = c; clipsToBounds = true}
    }
    
    
    @objc func design(){
        stopObserving(notification: "Design")
        observe(notification: "Design", selector:#selector(design))
        subviews.forEach { view in view.design() }
        
        backgroundColor = UIColor.backgroundColor
        //borderWidth = UIView.borderWidth
        //borderColor = .blue
    }
}
