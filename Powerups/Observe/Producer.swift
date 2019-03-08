//
//  Particle.swift
//  Powerups
//
//  Created by Sean Orelli on 3/8/19.
//  Copyright © 2019 Sean Orelli. All rights reserved.
//

import Foundation


/*

 */
class Consumer<T>
{
    weak var producer: Producer<T>? = nil
    
    var index: Int
    var complete: Closure<Error?>?
    
    init(particle: Producer<T>, index: Int, complete: Closure<Error?>? = nil)
    {
        self.producer = particle
        self.index = index
    }
    
    func close()
    {
        producer?.remove(self)
    }

    deinit { close() }
}

class Producer<T>
{
    var consumers = [Consumer<T>]()
    var finished: Bool = false
    
    func subscribe(complete: Closure<Error?>?) -> Consumer<T>?
    {
        guard !finished else { return nil }
        
        let consumer = Consumer(particle: self, index: consumers.count, complete: complete )
        
        consumers.append(consumer)
        
        return consumer
    }

    func removeAllConsumers()
    {
        let tmp = consumers
        tmp.forEach { remove($0) }
    }
    
    func remove(_ consumer: Consumer<T>)
    {
        _ = consumers.remove(at: consumer.index)
        for i in 0..<consumers.count
        {
            consumers[i].index = i
        }
    }

    deinit { close() }
    
    func close(_ error:Error? = nil)
    {
        // Should these be in the same loop?
        // Seems more predicatble if we
        // deallocate after completing
        // and mark finished inbetween
        consumers.forEach{ $0.complete?(error) }
        finished = true
        consumers.forEach{ remove($0) }
    }

}
