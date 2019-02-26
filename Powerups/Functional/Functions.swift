//
//  Functions.swift
//  Galileo
//
//  Created by Sean Orelli on 2/25/19.
//  Copyright © 2019 Sean Orelli. All rights reserved.
//

import Foundation

let sum = reduce(0) { (r, i)  in r + i }


///---------------------------------------
func increment(_ x: Int) -> Int {
    return x + 1
}

func square(_ x: Int) -> Int {
    return x * x
}

func compute(_ x: Int) -> Int {
    let c =  x * x + 1
    print("computed: \(c)")
    return c
}
func computeAndPrint(_ x: Int) -> (Int, [String]) {
    let c =  x * x + 1
    return (c, ["Computed: \(c)"])
}

func greet( _ name: String, _ date:Date = Date()) -> String {
    let seconds = Int(date.timeIntervalSince1970) % 60
    return "Hello \(name)! It's \(seconds) secods past the minute"
}

func greet2(at date: Date) -> Fun<String,String> {
    return { name in
        let seconds = Int(date.timeIntervalSince1970) % 60
        return "Hello \(name)! It's \(seconds) seconds past the minute."
    }
}

func greetWithEffect(_ name: String) -> String {
    return greet(name)
}

func upperCased(string: String) -> String {
    return string.uppercased()
}
