//
//  OInt.swift
//  Galileo
//
//  Created by Sean Orelli on 2/23/19.
//  Copyright © 2019 Sean Orelli. All rights reserved.
//

import Foundation

infix operator << //assign
infix operator >> //bind
infix operator ++ //combine
//infix operator + //add 

typealias OInt = O<Int>
typealias OString = O<String>
typealias ODouble = O<Double>
typealias OBool = O<Bool>

typealias SInt = S<Int>
typealias SString = S<String>
typealias SDouble = S<Double>
typealias SBool = S<Bool>

/*_____________________________________________
 
                Reactive
 _____________________________________________*/
class R<T>:O<T>
{
    private var reactors    = [(Closure<T>,Closure<Error>,Block)]()
    
    func react(_ depth: Int = 0,
               onNext:@escaping Closure<T>,
               onError:@escaping Closure<Error>,
               onComplete:@escaping Block){
        
        reactors.append((onNext, onError, onComplete))
        
        
    }

    func onNext(_ val:T) {
        reactors.forEach { (next, _, _ ) in next(val) }
    }

    func error(_ error:Error? = nil) {
        reactors.forEach { (_, e, _ ) in if let er = error { e(er) } }
    }

    func close() {
        reactors.forEach { (_, _, c ) in c() }
        reactors.removeAll()

    }

}

/*_____________________________________________
 
                Subscribable
 _____________________________________________*/
class S<T>:O<T>
{
    typealias ClosureWithSubscription = ([T], Bool, Error?)->()

    private var subscribers = [ClosureWithSubscription]()
    override func publish() {
        super.publish()
        subscribers.forEach{$0(values, false, nil)}
    }
    
    func close(_ error:Error? = nil) {
        subscribers.forEach{$0(values, true, error)}
        subscribers.removeAll()
    }
    
    
    func subscribe(_ depth: Int = 0, closure:@escaping ClosureWithSubscription)
    {
        subscribers.append(closure)
        for i in 0...depth {
            if i < values.count {
                closure(values, false, nil)
            }
        }
        
        //
        if depth > max { max = depth }
    }

}

/*_____________________________________________
 
                Observable
_____________________________________________*/
class O<T>
{
    typealias ClosureWithValues = ([T])->()
    private var observers = [ClosureWithValues]()
    
    internal var values = [T]()
    internal var max = 1
    
    /*
    func dispose(by bag: inout Bag<T>){
        bag.append(self)
    }
    */
    
    var value:T? = nil
    {
        didSet
        {
            if let v = value
            {
                setNewValue(v)
            }
        }
    }
    
    init(_ val:T? = nil ){
        value = val
        setNewValue(val)
    }
    
    private func setNewValue(_ val:T?){
        if let v = val {
            values.append(v)
            if values.count > max {                
                values.remove(at: 0)
            }
            publish()
        }
    }

    func publish()
    {
        values.forEach { (val) in
            observers.forEach {
                $0([val])
            }
        }
        
    }
    
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
            right.value = v[0]
        }
    }
    
    //combine interleaved? concat?
    static func ++ (left: O<T>, right: O<T>) -> O<(T,T)>
    {
        let o = O<(T,T)>()
        //  o.valueA = left.value
        //  o.valueB = right.value
        //  left.subscribe { v in o.valueA = v }
        //  right.subscribe { v in o.valueB = v }
        return o
    }
    
    
    func observe(_ depth: Int = 0, _ distinct: Bool = false, closure:@escaping ClosureWithValues)
    {
        observers.append(closure)
        for i in 0...depth {
            if i < values.count {
                closure(values)
            }
        }
        
        if depth > max { max = depth }
    }
    
}


//Combine string observables
extension Array where Element == O<String> {
    
    
    func combine(a:O<String>, b:O<String>) -> O<(String, String)>
    {
        
        let combo =  O<(String, String)>()
        
        a.observe { (strings) in
            combo.value = (strings[0], b.value ?? "")
        }
        
        b.observe { (strings) in
            combo.value = (a.value ?? "", strings[0])
        }
        
        return combo
    }
}

/*
 extension O where T==String {
 static func +=(left: O<T>, right: T) { left.value = (left.value ?? "" ) + right }
 }
 extension O where T==Int {
 static func +=(left: O<T>, right: T) { left.value = (left.value ?? 0 ) + right }
 static func -=(left: O<T>, right: T) { left.value = (left.value ?? 0 ) - right }
 }
 extension O where T==Float {
 static func +=(left: O<T>, right: T) { left.value = (left.value ?? 0 ) + right }
 static func -=(left: O<T>, right: T) { left.value = (left.value ?? 0 ) - right }
 }
 extension O where T==Double {
 static func +=(left: O<T>, right: T) { left.value = (left.value ?? 0 ) + right }
 static func -=(left: O<T>, right: T) { left.value = (left.value ?? 0 ) - right }
 }
 
 extension O where T==Float {
 static func +=(left: O<T>, right: Int) { left.value = (left.value ?? 0 ) + right }
 static func -=(left: O<T>, right: Int) { left.value = (left.value ?? 0 ) - right }
 }
 
 */
