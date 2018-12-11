//
//  NSObject+.swift
//  Powerups
//
//  Created by Sean Orelli on 11/29/18.
//  Copyright © 2018 Sean Orelli. All rights reserved.
//

import UIKit

// Declare a global var to produce a unique address as the assoc object handle
private var associatedObjectKey: UInt8 = 0
/*_____________________________________
 
                NSObject
 ____________________________________*/
extension NSObject {
    
    func associated(closure:String) -> Closure {
        if let a = associatedObjects[closure] as? Closure { return a }
        return {}
    }
    
    var associatedObjects: [String: Any] {
        get {
            if let objects = objc_getAssociatedObject(self, &associatedObjectKey) as? [String: Any] {
                return objects
            }
            let objects = [String: Any]()
            //assoicatedObjects = objects
            objc_setAssociatedObject(self, &associatedObjectKey, objects, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return objects
        }
        set {
            objc_setAssociatedObject(self, &associatedObjectKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    func observe(notification: String, selector:Selector){
        NotificationCenter.default.addObserver(self, selector: selector, name: Notification.Name(notification), object: nil)
    }
    
    func observe(notification: String, closure: @escaping NotificationClosure){
        NotificationCenter.default.addObserver(forName: Notification.Name(notification), object: self, queue: nil, using:closure)
    }
    
    func stopObserving(notification: String){
        NotificationCenter.default.removeObserver(self, name: Notification.Name(notification), object: nil)
    }
}
