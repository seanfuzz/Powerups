//
//  UIAlertController.swift
//
//  Created by Sean Orelli on 8/28/18.
//  Copyright © 2018 Fuzz. All rights reserved.

import UIKit



extension UIAlertController {
	static func alert(title: String?) {
		mainQueue {
			let window = UIApplication.shared.windows[0]

			if let controller = window.rootViewController {

				let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
				let action = UIAlertAction(title: "Ok", style: .default) { (action) in
					controller.dismiss(animated: true, completion:nil)
				}
				alert.addAction(action)
				controller.present(alert, animated: true, completion: nil)
			}
		}
	}

    static func alertWithField(title: String?, completion: @escaping Closure<String>) {
        mainQueue {
            let window = UIApplication.shared.windows[0]
            
            if let controller = window.rootViewController {

                var textField:UITextField?
                let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                    
                    if let field = textField{
                        completion(field.text ?? "?")
                    }
                    controller.dismiss(animated: true, completion:nil)
                }
                alert.addAction(action)

                alert.addTextField(configurationHandler: { (field) in
                    textField = field
                })
                controller.present(alert, animated: true, completion: nil)
            }
        }
    }

}
