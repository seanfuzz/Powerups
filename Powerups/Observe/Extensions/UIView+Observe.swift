//
//  UIView+Observe.swift
//  Powerups
//
//  Created by Sean Orelli on 3/4/19.
//  Copyright © 2019 Sean Orelli. All rights reserved.
//

import UIKit

extension UIView
{
    /// Bindable sink for `hidden` property.
    var o_isHidden: O<Bool>
    {
        return associatedObserver("o_isHidden", isHidden )
        { [unowned self] in self.isHidden = $0 }
    }
    
    var o_alpha: O<CGFloat>
    {
        return associatedObserver("o_alpha", alpha )
        { [unowned self] in self.alpha = $0 }
    }
    
    var o_isUserInteractionEnabled: O<Bool>
    {
        return associatedObserver("o_isUserInteractionEnabled", isUserInteractionEnabled )
        { [unowned self] in self.isUserInteractionEnabled = $0 }
    }
}

//-----------------------------------
//-----------------------------------
/*
extension UIView
{
    
    class UIViewObservables
    {
        let isHidden = O<Bool>(false)
        let alpha = O<CGFloat>(1)
        let isUserInteractionEnabled = O<Bool>(true)

        required init(_ view: UIView)
        {
            isHidden << view.isHidden
            alpha << view.alpha
            isUserInteractionEnabled << view.isUserInteractionEnabled
        }
    }
    
    func getObservables<T: UIViewObservables>() -> T
    {
        if let o:T = associatedValue("observables")
        {
            return o
        }
        let o = T(self)
        associatedObjects["observables"] = o
        return o
    }
    
    var o: UIViewObservables
    {
        return getObservables()
    }

//    var observables: UIViewObservables
//    {
//        return getObservables()
//    }
//
  
}
*/
