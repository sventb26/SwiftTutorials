//
//  Capital.swift
//  Project19
//
//  Created by Administrator on 5/17/18.
//  Copyright © 2018 SmartApps. All rights reserved.
//

import MapKit
import UIKit

class Capital: NSObject, MKAnnotation {
	
	var title: String?
	var coordinate: CLLocationCoordinate2D
	var info: String
	var isFavorite: Bool
	
	init(title: String, coordinate: CLLocationCoordinate2D, info: String, isFavorite: Bool) {
		self.title = title
		self.coordinate = coordinate
		self.info = info
		self.isFavorite = isFavorite
	}
}
