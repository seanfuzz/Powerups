//
//  EphemeralObserver.swift
//  Powerups
//
//  Created by Sean Orelli on 3/7/19.
//  Copyright © 2019 Sean Orelli. All rights reserved.
//

import Foundation


class Listener<T>
{
    weak var channel:Channel<T>? = nil
    
    var index: Int
    var update: Closure<T>?
    var complete: Closure<Error?>?
    
    init(channel: Channel<T>, index: Int, update: Closure<T>?, complete: Closure<Error?>?)
    {
        self.channel    = channel
        self.index      = index
        self.update     = update
        self.complete   = complete
    }
    
    func stop()
    {
        channel?.remove(observer: self)
    }
    
}
