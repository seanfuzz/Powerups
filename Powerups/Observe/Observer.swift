//
//  Observer.swift
//  Powerups
//
//  Created by Sean Orelli on 3/4/19.
//  Copyright © 2019 Sean Orelli. All rights reserved.
//

import Foundation

//protocol ObserverType {
//    associatedtype T
//    var index:Int { get set }
//    var start: Closure<T>? { get }
//    var update: Closure<T>? { get }
//    var end: Closure<Error?>? { get }
//}

class Observer<T>//://ObserverType
{
    weak var observable:Observable<T>? = nil
    
    var index: Int
    
    var start: Closure<T>?
    var update: Closure<T>?
    var end: Closure<Error?>?

    init(observable: Observable<T>, index: Int, start: Closure<T>?, update:  Closure<T>?, end: Closure<Error?>?)
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
