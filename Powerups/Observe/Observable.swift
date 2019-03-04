//
//  OInt.swift
//  Galileo
//
//  Created by Sean Orelli on 2/23/19.
//  Copyright © 2019 Sean Orelli. All rights reserved.
//

import Foundation

/*_____________________________________________
 
                Observable
 
 Does this work with observing optional types?
 can we change value to be a computed property
 on
_____________________________________________*/
typealias O = Observable
class Observable<T>
{
    private var observers = [Observer<T>]()
    internal var finished: Bool = false

    var name = "Observable"
    
    var value:T { didSet{ publish(self) } }

    var publish: Closure<O<T>> =
    { obs in
        obs.broadcast()
    }

    func broadcast(_ val:T? = nil)
    {
        let v = val ?? value

        guard !finished else { return }
        
        observers.forEach
        { (observer) in
            observer.update?(v)
        }
    }

    
    init(_ val:T) { value = val }
    deinit { close() }

    
    @discardableResult
    func observe(start: Closure<T>? = nil, end: Closure<Error?>? = nil, update: Closure<T>? = nil) -> Observer<T>?
    {
        guard !finished else { return nil }
        let observer = Observer(observable: self, index:observers.count, start: start, update: update, end: end )
        observers.append(observer)
        observer.start?(value)
        return observer
    }
    
    
    func close(_ error:Error? = nil)
    {
        // Should these be in the same loop?
        // Seems more predicatble if we
        // deallocate after completing
        // and mark finished inbetween
        observers.forEach
        { (obs) in
            obs.end?(error)
        }
        
        finished = true
        
        observers.forEach
        { (obs) in
            remove(observer: obs)
        }
    }
    

    func removeAllObservers()
    {
        let tmp = observers
        tmp.forEach { remove(observer: $0)}
    }
    
    func remove(observer: Observer<T>)
    {
        _ = observers.remove(at: observer.index)
        for i in 0..<observers.count
        {
            observers[i].index = i
        }
    }
    
}



