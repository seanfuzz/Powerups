//
//  UILabel+Observe.swift
//  Powerups
//
//  Created by Sean Orelli on 3/4/19.
//  Copyright © 2019 Sean Orelli. All rights reserved.
//

import UIKit


extension UILabel
{
    var o_text:O<String>
    {
        return associatedObserver("o_text", text ?? "")
        { [unowned self] in self.text = $0 }
    }
    

}
