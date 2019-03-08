//
//  Observer.swift
//  Powerups
//
//  Created by Sean Orelli on 3/7/19.
//  Copyright © 2019 Sean Orelli. All rights reserved.
//

import Foundation

class Observer<T>: Listener<T>
{
    var start: Closure<T>? = nil
}
