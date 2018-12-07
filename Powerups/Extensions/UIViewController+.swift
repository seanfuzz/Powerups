//
//  UIViewController+.swift
//  Powerups
//
//  Created by Sean Orelli on 11/29/18.
//  Copyright © 2018 Sean Orelli. All rights reserved.
//

import UIKit

extension UIViewController {
    func addChildAndView(controller: UIViewController){
        addChild(controller)
        view.addSubview(controller.view)
    }
}
