//
//  ViewController.swift
//  Project22
//
//  Created by Administrator on 5/23/18.
//  Copyright © 2018 SmartApps. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {

	//MARK: IB Outlets
	@IBOutlet var distanceReading: UILabel!
	
	//MARK: Properties
	var locationManager: CLLocationManager!  //This is the Core Location class that lets us configure how we want to be notified about location, and will also deliver locaiton updates to us.
	
	
	//MARK: Functions
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedAlways {
			if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
				if CLLocationManager.isRangingAvailable() {
					startScanning()
				}
			}
		}
	}
	
	
	func startScanning() {
		let uuid = UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!
		let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 45, identifier: "My Beacon")
		
		locationManager.startMonitoring(for: beaconRegion)
		locationManager.startRangingBeacons(in: beaconRegion)
	}
	
	
	func update(distance: CLProximity) {
		UIView.animate(withDuration: 0.8) { [unowned self] in
			switch distance {
			case .unknown:
				self.view.backgroundColor = UIColor.gray
				self.distanceReading.text = "UNKNOWN"
				
			case .far:
				self.view.backgroundColor = UIColor.blue
				self.distanceReading.text = "FAR"
				
			case .near:
				self.view.backgroundColor = UIColor.orange
				self.distanceReading.text = "NEAR"
				
			case .immediate:
				self.view.backgroundColor = UIColor.red
				self.distanceReading.text = "RIGHT HERE"
			}
		}
	}
	
	
	func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
		
		if beacons.count > 0 {
			let beacon = beacons[0]
			update(distance: beacon.proximity)
		} else {
		
			update(distance: .unknown)
			
		}
	}
	
	
	//MARK: Load Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		
		locationManager = CLLocationManager()
		locationManager.delegate = self
		locationManager.requestAlwaysAuthorization()
		
		view.backgroundColor = UIColor.blue
		view.addSubview(distanceReading)
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

