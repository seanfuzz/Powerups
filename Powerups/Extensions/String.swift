//
//  String.swift
//  Powerups
//
//  Created by Sean Orelli on 11/29/18.
//  Copyright © 2018 Sean Orelli. All rights reserved.
//

import UIKit
import UserNotifications

extension String
{

    static func todaysDate() -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from: Date())
    }

    func notify()
    {
        NotificationCenter.default.post(name: Notification.Name(self), object: nil)
    }
    
    func alert()
    {
        UIAlertController.alert(title: self)
    }
    
    func sendLocalNotification()
    {
        UNUserNotificationCenter.sendLocalNotification(message:self)
    }
    
    func stringByAddingPercentEncodingForRFC3986() -> String?
    {
        let unreserved = "-._~/?"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        return self.addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
    }
    
    static func read(_ path:String) -> String?
    {
        if let s = try? String.init(contentsOfFile: path)
        {
            return s
        }else{
            print("no string at \(path)")
        }

        return nil
    }
}

