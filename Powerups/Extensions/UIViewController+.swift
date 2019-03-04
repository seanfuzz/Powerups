//
//  UIViewController+.swift
//  Powerups
//
//  Created by Sean Orelli on 11/29/18.
//  Copyright © 2018 Sean Orelli. All rights reserved.
//

import UIKit

extension UIViewController {
    func addChildAndView(controller: UIViewController){
        addChild(controller)
        view.addSubview(controller.view)
    }
    
    // MARK: Helper Methods for Error Presentation
    func presentErrorAlert(withTitle title: String = "Unexpected Failure", message: String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alertController, animated: true)
    }
    
    func presentError(_ error: NSError)
    {
        self.presentErrorAlert(withTitle: "Failed with error \(error.code)", message: error.localizedDescription)
    }
    
}
