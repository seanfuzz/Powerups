//
//  DateController.swift
//  Powerups
//
//  Created by Sean Orelli on 12/10/18.
//  Copyright © 2018 Sean Orelli. All rights reserved.
//

import UIKit

class DateController: ViewController {
    
    var textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(textView)
        textView.pin()
        let date = Date()
        addCopy(text: "\(date.day)")
        addCopy(text: "\(date.month)")
        addCopy(text: "\(date.year)")

    }
    
    func addCopy(text: String){
        textView.text = textView.text + "\n" + text
    }
    
}
