//
//  ViewController.swift
//  Project21
//
//  Created by Administrator on 5/22/18.
//  Copyright © 2018 SmartApps. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

	
	//MARK: Methods
	@objc func registerLocal() {
		
		let center = UNUserNotificationCenter.current()
		
		center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
			
			if granted {
				print("Yay!")
			} else {
				print("D/oh!")
			}
		}
	}
	
	
	@objc func scheduleLocal() {
		//Once we have user permission, this method will configure all the data needed to schedule a notification, which is three things:  content (what to show), a trigger (when to show it), and a request ( the combination of content and trigger).
		registerCategories()
		
		let center = UNUserNotificationCenter.current()
		
		let content = UNMutableNotificationContent()
		content.title = "Late wake up call."
		content.body = "The early bird catches the worm, but the second mouse gets the cheese."
		content.categoryIdentifier = "alarm"
		content.userInfo = ["customeData" : "fizzbuzz"]
		content.sound = UNNotificationSound.default()
		
		var dateComponents = DateComponents()
		dateComponents.hour = 16
		dateComponents.minute = 40
		
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
		
		let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
		center.add(request)
	}
	
	
	func registerCategories() {
		let center = UNUserNotificationCenter.current()
		center.delegate = self
		
		let show = UNNotificationAction(identifier: "show", title: "Tell me more…", options: .foreground)
		let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
		
		center.setNotificationCategories([category])
	}
	
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		// pull out the buried userInfo dictionary
		let userInfo = response.notification.request.content.userInfo
		
		if let customData = userInfo["customData"] as? String {
			print("Custom data received: \(customData)")
			
			switch response.actionIdentifier {
			case UNNotificationDefaultActionIdentifier:
				// the user swiped to unlock
				print("Default identifier")
				
			case "show":
				// the user tapped our "show more info…" button
				print("Show more information…")
				
			default:
				break
			}
		}
		
		// you must call the completion handler when you're done
		completionHandler()
	}
	
	
	
	//MARK: View Load Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

