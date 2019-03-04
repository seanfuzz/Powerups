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
        return associatedObserver("otitle", titleLabel?.text ?? "")
        { [unowned self] in self.setTitle($0, for: .normal) }
    }
    
    var o_touchUp:O<Void>
    {
        if associatedObjects["o_tap"] == nil
        {
            self.touchUp =
            { [unowned self] in
                self.o_touchUp << ()
            }
        }
        
        return associatedObserver("o_tap", ())
        { _ in }//self.setTitle($0, for: .normal) }

    }
}

//------------------------------------------------------------
//------------------------------------------------------------
/*
extension UIButton
{

    struct UIButtonObservables
    {
        let title = O<String>("")
        
        init(_ button:UIButton)
        {
            title << (button.title ?? "")
        }
    }
    
    var obs: UIButtonObservables
    {
        return observables
    }
    
    var observables: UIButtonObservables
    {
        if let o:UIButtonObservables = associatedValue("observables")
        {
            return o
        }
        let o = UIButtonObservables(self)
        associatedObjects["observables"] = o
        return o
    }
    
}
 */
