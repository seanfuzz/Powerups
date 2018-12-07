//
//  UNUserNotificationCenter.swift
//
//  Created by Sean Orelli on 8/28/18.
//  Copyright © 2018 Fuzz. All rights reserved.
//

import UIKit
import UserNotifications

extension UNUserNotificationCenter: UNUserNotificationCenterDelegate {


	//This allows the app to show the notification while in the foreground
	public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {


    	completionHandler([.alert, .sound])
	}

	static func requestAuthorization(){
		UNUserNotificationCenter.current().requestAuthorization(options: [[.alert, .sound, .badge]]) { (granted, error) in
            // Handle Error
            if let error = error{
            	print(error)
			}
        }
        UNUserNotificationCenter.current().delegate =  UNUserNotificationCenter.current()
	}

	static func sendLocalNotification(title: String? = nil, message: String? = nil) {
		self.requestAuthorization()

		let content = UNMutableNotificationContent()
		content.title = title ?? ""
		content.subtitle = "test"
		content.body = message ?? ""
		content.badge = 1

		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
		let requestIdentifier = "demoNotification"
		let request = UNNotificationRequest(identifier: requestIdentifier,
											content: content, trigger: trigger)
		UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in })
	}

}
