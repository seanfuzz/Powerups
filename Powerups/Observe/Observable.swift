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
class Observable<T>: Channel<T>
{
    init(_ value:T, _ name:String? = nil, _ output:((O<T>, T) -> Void)? = nil)
    {
        self.value = value
    }
    
    var value:T { didSet { output(self, value) } }
    
    @discardableResult
    func observe(update: Closure<T>? = nil) -> Observable<T>
    {
        return Observable<T>(value)
    }
    
    func observe(start:Closure<T>? = { s in }, update: Closure<T>? = nil, complete: Closure<Error?>? = nil) -> Observer<T>?
    {
        guard !finished else { return nil }
        
        let observer = Observer(channel: self,
                                index: listeners.count,
                                update: update,
                                complete: complete )
        
        listeners.append(observer)
        
        return observer
        
    }
    
    static func << (left: Observable<T>, right: T)
    {
        left.value = right
    }
    static func << (left: Observable<T>, right: Observable<T>)
    {
        left.value = right.value
    }
}
