//
//  Observable.swift
//  Powerups
//
//  Created by Sean Orelli on 3/7/19.
//  Copyright © 2019 Sean Orelli. All rights reserved.
//

import Foundation


/*________________________
 

 ________________________*/
class StateChannel<T>: Channel<T>
{
    init(_ value:T, _ name:String? = nil, _ output:((O<T>, T) -> Void)? = nil)
    {
        self.value = value
    }
    
    var value:T { didSet { output(self, value) } }
    
    @discardableResult
    func listen(update: Closure<T>? = nil) -> StateChannel<T>
    {
        return StateChannel<T>(value)
    }
    
    func listen(start:Closure<T>? = { s in }, update: Closure<T>? = nil, complete: Closure<Error?>? = nil) -> StateListener<T>?
    {
        guard !finished else { return nil }
        
        let observer = StateListener(channel: self,
                                index: listeners.count,
                                update: update,
                                complete: complete )
        
        listeners.append(observer)
        
        return observer
        
    }
    
    static func << (left: StateChannel<T>, right: T)
    {
        left.value = right
    }
    static func << (left: StateChannel<T>, right: StateChannel<T>)
    {
        left.value = right.value
    }
}
