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
 // Support for cold observables
 Temp is both temperature and tempo
 This represents the hot / cold paradigm
 but also works as a throttle
 hot == 0.0 , cold == Infinity
 1.0 == 1 second throttle

 infinite? cant close observabl;e
_____________________________________________*/
typealias O = Observable



class Observable<T>
{

    typealias ObservableOutput = (Observable<T>) -> ()
    
    var name = "Observable"
    
    var observers = [Observer<T>]()
    
    var value:T { didSet { output(self, value) } }
    
    var output: ((O<T>, T)->()) = { $0 ->> $1 }
    
    var finished: Bool = false
    
    init(_ val:T, _ name:String? = nil, _ output:((O<T>, T)->Void)? = nil)
    {
        value = val
        if let n = name { self.name = n }
        if let p = output { self.output = p }
    }
    
    deinit { close() }
    
    @discardableResult
    func observe(_ update: Closure<T>? = nil) -> Observer<T>?
    {
        return observe(start:nil, update: update, end:nil)
    }
    @discardableResult
    func observe(start: Closure<T>? = nil,
                 update: Closure<T>? = nil,
                 end: Closure<Error?>? = nil) -> Observer<T>?
    {
        guard !finished else { return nil }
        
        let observer = Observer(observable: self,
                                index: observers.count,
                                start: start,
                                update: update,
                                end: end )
        
        observers.append(observer)
        
        observer.start?(value)
        
        return observer
    }
    
    func broadcast(_ val:T? = nil)
    {
        guard !finished else { return }
        let v = val ?? value
        observers.forEach{ $0.update?(v) }
    }
    
    func close(_ error:Error? = nil)
    {
        // Should these be in the same loop?
        // Seems more predicatble if we
        // deallocate after completing
        // and mark finished inbetween
        observers.forEach{ $0.end?(error) }
        finished = true
        observers.forEach{ remove(observer: $0) }
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
 
    
    /*
     var tempo = 0.0
     var lasttime: Date? = nil
     
     func freeze()
     {
     tempo = Double.infinity
     observers.forEach{ $0.pause?(value) }
     }
     
     func thaw(_ t:Double = 0.0)
     {
     tempo = t
     observers.forEach{ $0.resume?(value) }
     }*/

}



