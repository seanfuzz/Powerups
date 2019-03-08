//
//  Ephemeral.swift
//  Powerups
//
//  Created by Sean Orelli on 3/7/19.
//  Copyright © 2019 Sean Orelli. All rights reserved.
//

import Foundation

/*________________________
 
        Channel
________________________*/
class Channel<T>
{
    var listeners = [Listener<T>]()
    var finished: Bool = false
    var name = "Channel"
    deinit { close() }

    typealias C = Channel
    
    typealias ChannelOutput = (Channel<T>, T) -> Void
    
    var output: ChannelOutput = { $0 ->> $1 }
    
    init(_ name:String? = nil, _ output:ChannelOutput? = nil)
    {
        if let n = name { self.name = n }
        if let p = output { self.output = p }
    }
    
    @discardableResult
    func listen(_ update: Closure<T>? = nil) -> Listener<T>?
    {
        return listen(update: update, complete:nil)
    }
    
    @discardableResult
    func listen(update: Closure<T>? = nil, complete: Closure<Error?>? = nil) -> Listener<T>?
    {
        guard !finished else { return nil }
        
        let listener = Listener(channel: self,
                                index: listeners.count,
                                update: update,
                                complete: complete )
        
        listeners.append(listener)
        
        return listener
    }
    
    func broadcast(_ val:T)
    {
        guard !finished else { return }
        listeners.forEach{ $0.update?(val) }
    }
    
    func close(_ error:Error? = nil)
    {
        // Should these be in the same loop?
        // Seems more predicatble if we
        // deallocate after completing
        // and mark finished inbetween
        listeners.forEach{ $0.complete?(error) }
        finished = true
        listeners.forEach{ remove(observer: $0) }
    }
    
    func removeAllListeners()
    {
        let tmp = listeners
        tmp.forEach { remove(observer: $0) }
    }
    
    func remove(observer: Listener<T>)
    {
        _ = listeners.remove(at: observer.index)
        for i in 0..<listeners.count
        {
            listeners[i].index = i
        }
    }
    
    static func << (left: Channel<T>, right: T)
    {
        left.output(left, right)
    }
    
    static func ->> (left: Channel<T>, right: T)
    {
        left.broadcast(right)
    }
    
    @discardableResult
    static func >> (left: Channel<T>, right: Channel<T>) -> Channel<T>
    {
        left.listen{ right.output(right, $0) }
        return right
    }
    
    func link(_ name: String = "Link", _ closure: @escaping (Channel<T>, T) -> Void) -> Channel<T>
    {
        return self >> Channel<T>(name, closure)
    }
    
    func filter(_ f: @escaping Fun<T,Bool>) -> Channel<T>
    {
        return link("Filtered")
        {
            if f($1)
            {
                $0 ->> $1
            }
        }
    }
    
    func map<U>(_ f: @escaping Fun<T,U>) -> Channel<U>
    {
        let out = Channel<U>()
        out.name = "Map"
        listen{ out << f($0) }
        return out
    }
    
    func reduce<A, R>(_ seed: A, accumulator: @escaping (A, T)  -> A, mapResult: @escaping (A)  -> R ) -> Channel<R>
    {
        var total = seed
        let out = Channel<R>()
        listen
        {
            total = accumulator(total, $0)
            out << mapResult(total)
        }
        return out
    }

}

