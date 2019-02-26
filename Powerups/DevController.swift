//
//  DevController.swift
//  Powerups
//
//  Created by Sean Orelli on 2/26/19.
//  Copyright © 2019 Sean Orelli. All rights reserved.
//

import UIKit


class DevController: ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let printSum = sum >>> { print($0) }
        
        printSum( [1,2,3] )
        print_Sum([1,2,3])
    }
    
    func print_Sum(_ things:[Int]) {
        print(sum(things))
    }
    
}
