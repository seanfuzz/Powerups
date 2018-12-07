//
//  Closure.swift
//  Powerups
//
//  Created by Sean Orelli on 11/30/18.
//  Copyright © 2018 Sean Orelli. All rights reserved.
//

import UIKit

typealias Closure = ()->()
typealias NotificationClosure = (Notification)->()
typealias ClosureToBool = ()->(Bool)
typealias ClosureWithString = (String)->()


func backgroundQueue(closure:@escaping Closure) {
    DispatchQueue.global(qos: .default).async(execute: closure)
}

func mainQueue(closure:@escaping Closure) {
    DispatchQueue.main.async(execute: closure)
}

func delay(_ seconds: Double, closure:@escaping Closure) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: closure)
}
