//
//  ViewController.swift
//  Project19
//
//  Created by Administrator on 5/17/18.
//  Copyright © 2018 SmartApps. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
	
	//MARK: IBOutlets
	@IBOutlet var mapView: MKMapView!
	
	
	//MARK: Functions
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		
		//Define a reuse identifier.  This is a string that will be used to ensure we reuse annotation views as much as possible.
		let identifier = "Capital"
		
		//Check whether the annotation we're creating a view for is one of our "Capital" objects.
		if annotation is Capital {
			
			//Try to dequeue an annotation view from the map view's pool of unused views.
			var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
			
			if annotationView == nil {
				
				//If it isn't able to find a reusable view, create a new one using MKPinAnnotationView and set its canShowCallout property to true.  This triggers the popup with the city name.
				annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
				annotationView!.canShowCallout = true
				
				//Create a new UIButton using the built-in .detailDisclosure type.  this is a small lue "i" symbol with a circle around it.
				let btn = UIButton(type: .detailDisclosure)
				annotationView!.rightCalloutAccessoryView = btn
				
			} else {
				
				//If it can reuse a view, update that view to use a different annotation.
				annotationView!.annotation = annotation
				
			}
			
			return annotationView
		}
		
		//If the annotation isn't from a capital city, it must return nil, so iOS uses a default view.
		return nil
	}
	
	
	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		
		let capital = view.annotation as! Capital
		let placeName = capital.title
		let placeInfo = capital.info
		
		let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .default))
		present(ac, animated: true)
		
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
		let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
		let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
		let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
		let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
		
		mapView.addAnnotation(london)
		mapView.addAnnotation(oslo)
		mapView.addAnnotation(paris)
		mapView.addAnnotation(rome)
		mapView.addAnnotation(washington)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

