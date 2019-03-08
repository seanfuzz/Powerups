//
//  DevController.swift
//  Powerups
//
//  Created by Sean Orelli on 2/26/19.
//  Copyright © 2019 Sean Orelli. All rights reserved.
//

import UIKit

class Student
{
    let score = O<Int>(0)
}

class DevController: Controller {

    var bag:O<Int>? = nil

    
    let printSum = sum >>> { print($0) }

    func incrFirst<A>( _ pair: (Int, A)) -> (Int, A){
        return (increment(pair.0), pair.1)
    }
    
    //apply a function to the first element of a tuple
    func first<A, B, C>(_ f: @escaping (A) -> C) -> ((A,B)) -> (C, B)
    {
        return { pair in (f(pair.0), pair.1) }
    }
    
    //apply a function to the second element of a tuple
    func second<A,B,C>(_ f: @escaping (B) -> C ) -> ((A, B)) -> (A, C)
    {
        return {pair in (pair.0, f(pair.1)) }
    }
    
 
    
    func composition()
    {
        let pair:(Int, String) = (42, "Swift")
        //        print(incrFirst(pair))
        
        let p = pair
            |> first(increment)
            |> first(String.init)
        print(p)
        
        let p2 = pair
            |> first(increment)
            |> first(String.init)
            |> second { $0 + "!"}
        print(p2)
        
        
        let p3 = pair
            |> first(increment)
            |> first(String.init)
            |> second { $0.uppercased()}
        print(p3)
        
        //        let p4:(String, String) = pair
        //            |> first(increment)
        //            |> first(String.init)
        //            |> second(zurry(flip(String.uppercased)))
        //
        //        print(p4)
        
//        let test = (1) + (4)
//        //        print(test)
//        print(" ")
//        let f: ((Int,Int)) -> Int = { a in
//            print(a.0)
//            print(a.1)
//            return 0
//        }
        
       // f((7,8))
        /*
         let f = flip(String.uppercased)
         print(f)
         print(String.uppercased)
         */
        //        zurry(f)
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let message = ~"Hello World"

        message << "button!"
        
        view.o_isUserInteractionEnabled.observe(){ b in }
        
        let label = UILabel(frame: .zero)
        view.addSubview(label)
        label.pin(top: 100, width:120, height:64)
        label.backgroundColor = .lightGray
        message >> label.o_text

        
        let button = UIButton(type: .custom)
        view.addSubview(button)
        button.pin(width:120, height:64)
        button.titleLabel?.text = "button"
        button.setTitle("button", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.borderColor = .black
        button.borderWidth = 1
        
        message >> button.o_title
        
        
//        let m = ~[1,2,3]
//
//        m.output =
//        {
//            $0->>
//        }

        let c = Channel<Int>()
        c.listen
        {
            print($0)
        }
        
        c.output =
        {
            $0.broadcast($1)
        }
        
        c << 1
        c << 2
        c << 3
        
        
        let r = Observable<Int>(4)
        
        r << 8
        r << 9
        
        r.observe
        {
            print($0)
        }
        
        r << 4
        r << 5
        r << 6
        
    }
    
    func strings0()
    {
       let t = O<String>("0")//
        
        t.filter({ i in return true})
        .observe{ v in
            print(v)
        }
        
        t << "A"
    }
    func strings1()
    {
        let t = O<String>("1")//
        
        t.replay(3)
        .filter({ i in return true})
        .observe{ v in
            print(v)
        }

       t << "A"
    }
    
    func strings2()
    {
        let t = O<String>("2")//
        
        t.filter({ i in return true})
        .replay(3)
        .observe{ v in
            print(v)
        }
        
       t << "A"
    }

    func strings_()
    {
        
        let thing = O<String>("Q")
        thing.replay(3).filter({ v in
            return v != "B"
        }).observe()
        { s in
            print(": \(s)")
        }

//        thing.replay(3).observe(true)
//        { s in
//            print(": \(s)")
//        }

        thing << "A"
        thing << "B"
        thing << "C"
    }
    
    func integers()
    {
        let thing = O<Int>(0)
        thing.observe() { v in
            print(v)
        }
        
        
        /*
        let _ = thing.replay(3).observe(true)
        { v in
            
            print("     \(v)")
        }
        thing << 2
         */

    }
    
    
}
