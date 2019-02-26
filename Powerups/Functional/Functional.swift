//
//  Functional.swift
//  Galileo
//
//  Created by Sean Orelli on 2/24/19.
//  Copyright © 2019 Sean Orelli. All rights reserved.
//

import Foundation

typealias Block         = () -> ()
typealias Closure<In>   = (In) -> ()
typealias Creator<Out>  = () -> (Out)
typealias Fun<In,Out>   = (In) -> Out
typealias IO<Type>      = (inout Type) -> ()
typealias Curry<A,B,C>  = (A) -> (B) -> C

/*________________________________________________
 
 Lifted Collection Functions
 ________________________________________________*/
func forEach<A>(_ f: @escaping Closure<A>) -> Closure<[A]>
{
    return { $0.forEach(f) }
}

func filter<A>(_ f: @escaping Fun<A,Bool>) -> Fun<[A],[A]>
{
    return { $0.filter(f) }
}

func map<A, B>(_ f: @escaping Fun<A,B>) -> Fun<[A],[B]>
{
    return { $0.map(f) }
}

func reduce<A,B>(_ i:B, _ f: @escaping (B,A) -> B ) -> Fun<[A],B>
{
    return { $0.reduce(i, f) }
}

//flatmap
//sorted(by:

/*_____________________________________________
 
 
 _____________________________________________*/
func toInout<A>(_ f: @escaping Fun<A,A>) -> IO<A>
{
    return { a in a = f(a)  }
}

//?????? is thos right?
func fromInout<A>(_ f: @escaping IO<A>) -> Fun<A,A>
{
    return { a in
        var a = a
        f(&a)
        return a
    }
}


/*____________________________________
 
        Function Application
____________________________________*/
precedencegroup FunctionApplication {
    associativity: left
}
infix operator |>: FunctionApplication
func |> <A, B>(a:A, f:Fun<A,B>) -> B { return f(a) }
func |> <A>(a: inout A, f: IO<A>) -> Void { f(&a) }



/*____________________________________
 
        Function Composition
 ____________________________________*/
precedencegroup FunctionComposition {
    associativity: left
    higherThan: EffectComposition
}

infix operator >>>: FunctionComposition

func >>> <A, B, C>(f: @escaping Fun<A,B>, g: @escaping Fun<B,C>) -> Fun<A,C> {
    return { a in g(f(a)) }
}

/*___________________________________
 
        Effect Composition
 
 Does this serve a purpose?
___________________________________*/
precedencegroup EffectComposition {
    associativity: left
    higherThan: FunctionApplication
}

infix operator >=>: EffectComposition

func >=> <A, B, C>(_ f: @escaping Fun<A,(B, [String])>,
                   _ g: @escaping Fun<B,(C, [String])>) -> Fun<A,(C, [String])>{
    
    return { a in
        let (b, logs) = f(a)
        let (c, mlogs) = g(b)
        return (c, logs + mlogs)
    }
}


/*___________________________________
 
    Single Type Composition
___________________________________*/
precedencegroup SingleTypeComposition {
    associativity: left
    higherThan: FunctionApplication
}

infix operator <>: SingleTypeComposition
func <> <A>(f: @escaping Fun<A,A>, g: @escaping Fun<A,A>) -> Fun<A,A>
{
   return f >>> g
}

func <> <A>(f: @escaping IO<A> , g: @escaping IO<A> ) ->  IO<A>
{
    return { a in f(&a); g(&a) }
}

//Any or AnyObject?
func <> <A: Any>(f: @escaping Closure<A> , g: @escaping Closure<A> ) ->  Closure<A>
{
    return { a in f(a); g(a) }
}


/*____________________________________
 
                Curry
 ____________________________________*/
func curry<A, B, C>(_ f: @escaping (A,B) -> C ) -> Curry<A,B,C>
{
    return { a in { b in f(a, b) } }
}
func flip<A,B,C>(_ f: @escaping Curry<A,B,C>) -> Curry<B,A,C>
{
    return { b in { a in f(a)(b) } }
}
func zurry<A>(_ f: Creator<A>) -> A
{
    return f()
}





