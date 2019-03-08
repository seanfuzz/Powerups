//
//  Observer.swift
//  Powerups
//
//  Created by Sean Orelli on 3/4/19.
//  Copyright © 2019 Sean Orelli. All rights reserved.
//

import Foundation

protocol ObserverType {
    associatedtype T
    var index:Int { get set }
    var start: Closure<T>? { get }
    var update: Closure<T>? { get }
    var end: Closure<Error?>? { get }
}

class _Observer<T>:ObserverType
{
    weak var observable:_Observable<T>? = nil
    
    var index: Int
    
    var start: Closure<T>?
    var update: Closure<T>?
    var end: Closure<Error?>?

    //start / stop
    //begin / end
    
    //var pause: Closure<T>?
    //var resume: Closure<T>?

    init(observable: _Observable<T>, index: Int, start: Closure<T>?, update:  Closure<T>?, end: Closure<Error?>?)
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
