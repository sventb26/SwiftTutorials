//
//  ViewController.swift
//  Project28
//
//  Created by Administrator on 6/14/18.
//  Copyright © 2018 SmartApps. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

	
	//MARK: Outlets
	
	@IBOutlet var secret: UITextView!
	
	
	//MARK: Actions
	
	@IBAction func authenticateTapped(_ sender: Any) {
		
		let context = LAContext()
		var error: NSError?
		
		if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
			
			let reason = "Identify yourself!"
			
			context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
				[unowned self] (success, authenticationError) in
				
				DispatchQueue.main.async {
					
					if success {
						self.unlockSecretMessage()
					} else {
						let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
						ac.addAction(UIAlertAction(title: "OK", style: .default))
						self.present(ac, animated: true)
					}
				}
			}
		} else {
			let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "OK", style: .default))
			self.present(ac, animated: true)
		}
	}
	
	
	//MARK: Functions
	func unlockSecretMessage() {
		secret.isHidden = false
		title = "Secret stuff!"
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(lockSecretMessage))
		
		
		if let text = KeychainWrapper.standard.string(forKey: "SecretMessage") {
			
			secret.text = text
		}
	}
	
	
	@objc func lockSecretMessage() {
		
		secret.endEditing(true)
		secret.isHidden = true
		title = "Nothing to see here"
		
		navigationItem.rightBarButtonItem = nil
		
	}
	
	
	@objc func saveSecretmessage() {
		
		if !secret.isHidden {
			
			_ = KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
			secret.resignFirstResponder()
			secret.isHidden = true
			
			title = "Nothing to see here"
			
		}
		
	}
	
	
	
	//MARK: Methods
	@objc func adjustForKeyboard(notification: Notification) {
		
		let userInfo = notification.userInfo!
		
		let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
		let keyboardViewendFrame = view.convert(keyboardScreenEndFrame, from: view.window)
		
		if notification.name == Notification.Name.UIKeyboardWillHide {
			secret.contentInset = UIEdgeInsets.zero
			
		} else {
			secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewendFrame.height, right: 0)
			
		}
		
		secret.scrollIndicatorInsets = secret.contentInset
		
		let selectedRange = secret.selectedRange
		secret.scrollRangeToVisible(selectedRange)
		
	}
	
	
	//MARK: Override Functions
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardDidChangeFrame, object: nil)
		notificationCenter.addObserver(self, selector: #selector(saveSecretmessage), name: Notification.Name.UIApplicationWillResignActive, object: nil)
		
		title = "Nothing to see here"
		
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

