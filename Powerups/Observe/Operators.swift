//
//  Operators.swift
//  Powerups
//
//  Created by Sean Orelli on 3/4/19.
//  Copyright © 2019 Sean Orelli. All rights reserved.
//

import Foundation

infix operator << //assign
infix operator >> //bind
infix operator ++ //combine
//infix operator + //add

// buffer
// filter
// skip
// take
// replay
// interval
// throttle
// flatMap
// distinctUntil
// combineLatest
// scan
// zip
// merge
// concat

// mergeMap
// forkJoin
// pairwise
// switchMap
// debounce

// Unneecessary Operators ?
// just
// from
// startWith
// window

// Excessive features?
// Scheduler

extension Observable
{
    //assign
    static func << (left: O<T>, right: T)
    {
        left.value = right
    }
    
    //push
    static func << (left: O<T>, right: O<T>)
    {
        left.value = right.value
    }
    
    //bind
    static func >> (left: O<T>, right: O<T>)
    {
        right.value = left.value
        left.observe { v in
            right.value = v
        }
    }
    
    // Create a new Observabel that is bound to the current instance
    func link(_ name: String = "Link", _ closure: @escaping (O<T>)->Void) -> Observable<T>
    {
        let o = Observable<T>(value)
        o.name = name
        o.publish = closure
        self >> o
        return o
    }
    
    //TODO
    func reduce<A, R>(_ seed: A, accumulator: @escaping (A, T)  -> A, mapResult: @escaping (A)  -> R ) -> Observable<T>
    {
        return link("Reduce")
        {
            $0.broadcast()
        }
    }
    
    
    func map(_ f: @escaping Fun<T,T>) -> Observable<T>
    {
        return link("Map")
        { obs in
            obs.broadcast( f(obs.value) )
        }
    }
    
    
    func skip(_ count:Int = 1) -> Observable<T>
    {
        var index = 0
        
        return link("Skip")
        { observable in
            if index > count
            {
                observable.broadcast()
            }
            index = index + 1
        }
    }
    
    func take(_ count:Int = 1) -> Observable<T>
    {
        var index = 0
        
        return link("Take")
        { observable in
            if index < count
            {
                observable.broadcast()
            }
            index = index + 1
        }
    }
    
    
    func filter(_ f: @escaping Fun<T,Bool>) -> Observable<T>
    {
        return link("Filtered")
        { obs in
            if f(obs.value)
            {
                obs.broadcast()
            }
        }
    }
    
    func replay(_ times:Int = 1) -> Observable<T>
    {
        return link("Replay")
        { obs in
            for _ in 0..<times { obs.broadcast() }
        }
    }
    
    // Why is this one different?
    // Beacuse we are changing the type
    // You cant bind in this case
    func cache(_ max:Int? = 1) -> Observable<[T]>
    {
        let cachingObserver =  Observable<[T]>([value])
        cachingObserver.name = "Cache"
        observe
            { v in
                var values = cachingObserver.value
                values.append(v)
                if let max = max, max < values.count
                {
                    values.remove(at: 0)
                }
                cachingObserver.value = values
        }
        
        return cachingObserver
    }
    
    
}


