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
// replay
// interval
// combineLatest
// scan
// zip
// merge
// concat

// mergeMap
// forkJoin
// pairwise
// switchMap

// Unneecessary Operators ?
// just
// from
// startWith
// window
// debounce 

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
        right.value = left.value            // sets the current value
        left.observe { right.value = $0 }   // sets future values
    }
    
}
/*________________________
 
        Link
________________________*/
extension Observable
{
    // Create a new Observable that is bound to the current instance
    // use this to chain operators of the same type
    func link(_ name: String = "Link", _ closure: @escaping (O<T>)->Void) -> Observable<T>
    {
        let o = Observable<T>(value)
        o.name = name
        o.publish = closure
        self >> o
        return o
    }
    

    // Can this be expressed as a filter?
    func throttle(_ duration: Double = 1.0) -> Observable<T>
    {

        var time = Date()
        return link("Throttle")
        {
            let now = Date()
            if now.timeIntervalSince(time) > duration
            {
                time = now
                $0.broadcast()
            }
        }
        
        
    }

    //can this be exrepsesed as a filter
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
    
    //can this be expressed as a filter
    func take(_ count:Int = 1) -> Observable<T>
    {
        var index = 0
        return link("Take")
        { observable in
            if index < count
            {
                observable.broadcast()
            }else
            {
                observable.close()
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
    
    //this is repeat
    func replay(_ times:Int = 1) -> Observable<T>
    {
        return link("Replay")
        { obs in
            for _ in 0..<times { obs.broadcast() }
        }
    }
    
    
    
}

/*_____________________________________________
 
                Transform
 _____________________________________________*/
extension Observable
{
    //    func transform<U>(_ name: String = "Transform", _ f: @escaping (T)->U) -> Observable<U>
    //    {
    //        let o = O<U>(f(value))
    //        o.name = name
    //        observe{
    //            o << f($0)
    //        }
    //        return o
    //    }
    
    // Is this a transform?
    func cache(_ max:Int? = 1) -> Observable<[T]>
    {
        let cachingObserver =  Observable<[T]>([value])
        cachingObserver.name = "Cache"
        observe
        {
            var values = cachingObserver.value
            values.append($0)
            if let max = max, max < values.count
            {
                values.remove(at: 0)
            }
            cachingObserver.value = values
        }
        
        return cachingObserver
    }

    func map<U>(_ f: @escaping Fun<T,U>) -> Observable<U>
    {
        let initial = f(value)
        let out = Observable<U>(initial)
        out.name = "Map"
        observe{ out << f($0) }
        return out
    }
    
    func flatmap<U>(_ f: @escaping Fun<T,O<U>>) -> Observable<U>
    {
        let initial = f(value).value
        let out = Observable<U>(initial)
        out.name = "Flatmap"
        observe{ f($0) >> out }
        return out
    }
    
    //TODO
    func reduce<A, R>(_ seed: A, accumulator: @escaping (A, T)  -> A, mapResult: @escaping (A)  -> R ) -> Observable<T>
    {
        return link("Reduce")
        {
            $0.broadcast()
        }
    }
}

/*_____________________________________________
 
_____________________________________________*/
extension Observable where T: Equatable
{
    func distinct() ->  Observable<T>
    {
        var prev:T? = nil
        return link("Distinct Until")
        {
            if let p = prev
            {
                if p != $0.value
                {
                    $0.broadcast()
                }
            }else
            {
                $0.broadcast()
            }
            prev = $0.value
        }
    }
}

