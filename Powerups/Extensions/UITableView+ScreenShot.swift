//
// Created by Andrew Grosner on 2018-10-10.
// Copyright (c) 2018 Fuzz. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func screenshot() -> UIImage {

        var image = UIImage();
        UIGraphicsBeginImageContextWithOptions(contentSize, false, UIScreen.main.scale)

        // save initial values
        let savedContentOffset = contentOffset;
        let savedFrame = frame;
        let savedBackgroundColor = backgroundColor

        // reset offset to top left point
        contentOffset = CGPoint(x: 0, y: 0);
        // set frame to content size
        frame = CGRect(x: 0, y: 0, width: self.contentSize.width, height:
        contentSize.height);
        // remove background
        backgroundColor = UIColor.clear

        // make temp view with scroll view content size
        // a workaround for issue when image on ipad was drawn incorrectly
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: self.contentSize.width, height: contentSize.height));

        // save superview
        let tempSuperView = superview
        // remove scrollView from old superview
        removeFromSuperview()
        // and add to tempView
        tempView.addSubview(self)

        // render view
        // drawViewHierarchyInRect not working correctly
        tempView.layer.render(in: UIGraphicsGetCurrentContext()!)
        // and get image
        image = UIGraphicsGetImageFromCurrentImageContext()!;

        // and return everything back
        tempView.subviews[0].removeFromSuperview()
        tempSuperView?.addSubview(self)

        // restore saved settings
        self.contentOffset = savedContentOffset;
        self.frame = savedFrame;
        self.backgroundColor = savedBackgroundColor

        UIGraphicsEndImageContext();

        return image
    }
}