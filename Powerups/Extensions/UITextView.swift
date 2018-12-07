//
//  UITextView.swift
//  Powerups
//
//  Created by Sean Orelli on 11/29/18.
//  Copyright © 2018 Sean Orelli. All rights reserved.
//

import UIKit

extension UITextView {
    
    // Does this work?
    // Maybe not in cells?
    func centerVertically() {
        var topCorrect = (bounds.size.height - contentSize.height * zoomScale) / 2.0
        topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect
        contentInset.top = topCorrect
    }
    
    //override
    override func design() {
        //super.design()
        backgroundColor = UIColor.clear
        font = UIFont.boldSystemFont(ofSize: 24)
        textColor = UIColor.cellTextColor
    }
}
