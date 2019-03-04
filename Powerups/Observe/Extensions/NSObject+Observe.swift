//
//  NSObject+Observe.swift
//  Powerups
//
//  Created by Sean Orelli on 3/4/19.
//  Copyright © 2019 Sean Orelli. All rights reserved.
//

import UIKit

extension NSObject
{
    func associatedObserver<T>(_ name:String, _ defaultValue:T, _ closure:Closure<T>? = nil ) -> O<T>
    {
        if let tmp:O<T> = associatedValue(name) { return tmp }
        let t = O<T>(defaultValue)
        associatedObjects[name] = t
        if let c = closure { t.observe(update:c) }
        return t
    }
}

