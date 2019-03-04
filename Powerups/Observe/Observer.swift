//
//  Observer.swift
//  Powerups
//
//  Created by Sean Orelli on 3/4/19.
//  Copyright © 2019 Sean Orelli. All rights reserved.
//

import Foundation

class Observer<T>
{
    weak var observable:O<T>?
    
    var index: Int
    
    var start: Closure<T>?
    var update: Closure<T>?
    var end: Closure<Error?>?
    
    init(observable: O<T>, index: Int, start: Closure<T>?, update:  Closure<T>?, end: Closure<Error?>?)
    {
        self.observable = observable
        self.index = index
        self.start = start
        self.update = update
        self.end = end
    }
    
    func stop()
    {
        observable?.remove(observer: self)
    }
    
}
