//
//  Operators.swift
//  Powerups
//
//  Created by Sean Orelli on 3/4/19.
//  Copyright © 2019 Sean Orelli. All rights reserved.
//

import Foundation


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
infix operator << //assign
infix operator >> //bind
infix operator ++ //combine

infix operator ->> //broadcast
infix operator <-> //Entangle

postfix operator ->> //broadcast

prefix operator ~ //as observable
//prefix operator • //as observable
//prefix operator ∆
//¡ ™ £ ¢ ∞ § ¶ •• ª º // Option number combos
extension String
{
    static prefix func ~ (o:String) -> O<String> { return o.observable }
    var observable: O<String> { return O<String>(self) }
}
extension Int
{
    static prefix func ~ (o:Int) -> O<Int> { return o.observable }
    var observable:O<Int> { return O<Int>(self) }
}
extension Double
{
    static prefix func ~ (o:Double) -> O<Double> { return o.observable }
    var observable:O<Double> { return O<Double>(self) }
}
extension Float
{
    static prefix func ~ (o:Float) -> O<Float> { return o.observable }
    var observable:O<Float> { return O<Float>(self) }
}
extension Array
{
    static prefix func ~ (o:Array) -> O<Array> { return o.observable }
    var observable:O<Array> { return O<Array>(self) }
}
extension Dictionary
{
    static prefix func ~ (o:Dictionary) -> O<Dictionary> { return o.observable }
    var observable:O<Dictionary> { return O<Dictionary>(self) }
}




extension Observable
{
    static postfix func ->> (o:O<T>) { o.broadcast(o.value) }

    static func ->> (left: O<T>, right: T)
    {
        left.broadcast(right)        
    }

//    //assign
//    static func << (left: O<T>, right: T)
//    {
//        left.value = right
//    }
//
//    //push
//    static func << (left: O<T>, right: O<T>)
//    {
//        left.value = right.value
//    }
    
    //bind
    @discardableResult
    static func >> (left: O<T>, right: O<T>) -> O<T>
    {
        right.value = left.value            // sets the current value
        left.observe { right.value = $0 }   // sets future values
        return right
    }
    
    //entangle
    static func <-> (left: O<T>, right: O<T>)
    {
        // This should infinite loop
        // Can we write this another way?
        // left >> right
        // right >> left
    }

    
}
/*________________________
 
        Link
________________________*/
extension Observable
{
    // Create a new Observable that is bound to the current instance
    // use this to chain operators of the same type
    func link(_ name: String = "Link", _ closure: @escaping (O<T>, T) -> Void) -> O<T>
    {
        return self >> O<T>(value, name, closure)
    }
    

    // Can this be expressed as a filter?
    func throttle(_ duration: Double = 1.0) -> O<T>
    {
        var time = Date()
        return link("Throttle")
        {
            let now = Date()
            if now.timeIntervalSince(time) > duration
            {
                time = now
                $0.broadcast($1)
            }
        }
        
    }

    //can this be exrepsesed as a filter
    func skip(_ count:Int = 1) -> O<T>
    {
        var index = 0
        
        return link("Skip")
        {
            if index > count
            {
                $0.broadcast($1)
            }
            index = index + 1
        }
    }
    
    //can this be expressed as a filter
    func take(_ count:Int = 1) -> O<T>
    {
        var index = 0
        return link("Take")
        {
            if index < count
            {
                $0.broadcast($1)
            }else
            {
                $0.close()
            }
            index = index + 1
        }
    }
    
    
    func filter(_ f: @escaping Fun<T,Bool>) -> O<T>
    {
        return link("Filtered")
        {
            if f($1)
            {
                $0 ->> $1
            }
        }
    }
    
    //this is repeat
    func replay(_ times:Int = 1) -> O<T>
    {
        return link("Replay")
        {
            for _ in 0..<times { $0.broadcast($1) }
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
//    public func scan<A>(into seed: A, accumulator: @escaping (inout A, E) throws -> ())
//        -> Observable<A> {
//            return Scan(source: self.asObservable(), seed: seed, accumulator: accumulator)
//    }

    
//    public func reduce<A, R>(_ seed: A, accumulator: @escaping (A, E) throws -> A, mapResult: @escaping (A) throws -> R)
//        -> Observable<R> {
//            return Reduce(source: self.asObservable(), seed: seed, accumulator: accumulator, mapResult: mapResult)
//    }
    
    //TODO
    func reduce<A, R>(_ seed: A, accumulator: @escaping (A, T)  -> A, mapResult: @escaping (A)  -> R ) -> Observable<R>
    {
        var total = accumulator(seed, value)
        let out = O<R>(mapResult(total))
        observe(){
            total = accumulator(total, $0)
            out << mapResult(total)
        }
        return out
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
            /*
            if let p = prev
            {
                if p != $1
                {
                    $0.broadcast($1)
                }
            }else
            {
                $0.broadcast($1)
            }*/
            if prev != $1 {
                $0.broadcast($1)
            }
            prev = $1
        }
    }
}

