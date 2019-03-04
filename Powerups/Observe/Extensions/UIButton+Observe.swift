//
//  UIButton+Observe.swift
//  Powerups
//
//  Created by Sean Orelli on 3/4/19.
//  Copyright © 2019 Sean Orelli. All rights reserved.
//

import UIKit


extension UIButton
{
    var o_title:O<String>
    {
        return associatedObserver("o_title", titleLabel?.text ?? "")
        { [unowned self] in self.setTitle($0, for: .normal) }
    }
    
    var o_touchUp:O<()>
    {
        if associatedObjects["o_touchUp"] == nil
        {
            self.touchUp 
            { [unowned self] in
               self.o_touchUp << ()
            }
        }
        
        return associatedObserver("o_touchUp", ()){ _ in }
    }
    
    
    var o_touchDown:O<()>
    {
        if associatedObjects["o_touchDown"] == nil
        {
            self.touchDown
            { [unowned self] in
                self.o_touchDown << ()
            }
        }
        
        return associatedObserver("o_touchDown", ()){ _ in }
    }

}
