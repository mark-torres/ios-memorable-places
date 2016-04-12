//
//  ViewController.swift
//  Memorable Places
//
//  Created by Mark Torres on 4/5/16.
//  Copyright © 2016 HSoft Inc. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
	
	@IBOutlet weak var mapView: MKMapView!
	
	var locationManager = CLLocationManager()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		// setup location manager
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		
		mapView.delegate = self
		
		// setup long press recognizer
		let mapLongPress = UILongPressGestureRecognizer(target: self, action: "mapLongPressAction:")
		mapLongPress.minimumPressDuration = 1
		
		// remove all annotations
		mapView.removeAnnotations(mapView.annotations)
		
		// set user location as start location for the map
		if (mapPlace.name == "") {
			getUserLocation()
			mapView.addGestureRecognizer(mapLongPress)
		} else {
			setMapLocation(mapPlace)
			mapAddPlaceAnnotation(mapPlace)
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func tapLocate(sender: AnyObject) {
		if (mapPlace.name == "") {
			getUserLocation()
		} else {
			setMapLocation(mapPlace)
		}
	}
	
	func getUserLocation() {
		print("getting user location...")
		locationManager.requestWhenInUseAuthorization()
		locationManager.startUpdatingLocation()
	}
	
	func setMapLocation(location: Place) {
		// set map region
		mapView.setRegion(
			MKCoordinateRegionMake(
				CLLocationCoordinate2DMake(location.latitude, location.longitude),
				MKCoordinateSpanMake(0.002, 0.002)),
			animated: false
		)
	}
	
	func mapLongPressAction(gestureRecognizer: UIGestureRecognizer) {
		if (gestureRecognizer.state == UIGestureRecognizerState.Began) {
			print("Long press detected")
			
			// get touch location
			let touchPoint = gestureRecognizer.locationInView(self.mapView)
			let newCoordinate: CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
			mapPlace.latitude = newCoordinate.latitude
			mapPlace.longitude = newCoordinate.longitude
			
			// alert
			let alertInput = UIAlertController(title: "New place", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
			// text fields
			alertInput.addTextFieldWithConfigurationHandler { (textField: UITextField) -> Void in
				//
				textField.placeholder = "Name for the place"
			}
			// buttons
			let btnSave = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (alert: UIAlertAction) -> Void in
				let inputTextField = alertInput.textFields![0] as UITextField
				// save map location
				mapPlace.name = inputTextField.text!
				places.append(mapPlace)
				self.getPlaceAddress(places.count - 1)
				self.mapAddAnnotation(newCoordinate, title: inputTextField.text!)
				self.save()
			}
			let btnCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive) { (alert: UIAlertAction) -> Void in
				print("Cancel")
			}
			alertInput.addAction(btnSave)
			alertInput.addAction(btnCancel)
			// show alert
			self.presentViewController(alertInput, animated: true, completion: nil)
		}
	}
	
	func getPlaceAddress(placeIndex: Int) {
		if placeIndex >= places.count {
			return
		}
		let place = places[placeIndex]
		// Class reference: https://developer.apple.com/library/ios/documentation/CoreLocation/Reference/CLPlacemark_class/
		let touchLocation = CLLocation(latitude: place.latitude, longitude: place.longitude)
		CLGeocoder().reverseGeocodeLocation(touchLocation) { (placemarks, error) -> Void in
			if error != nil {
				print("Error in reverse geocoding")
				// self.showAlert("Error", aMessage: "Error in reverse geocoding")
			} else {
				if placemarks!.count > 0 {
					let placemark = placemarks![0] as CLPlacemark
					let street = placemark.thoroughfare! as String
					let streetNum = placemark.subThoroughfare! as String
					let city = placemark.locality! as String
					let state = placemark.administrativeArea! as String
					let country = placemark.ISOcountryCode! as String
					place.address = "\(street) \(streetNum)"
					place.city = "\(city), \(state), \(country)" as String
					places[placeIndex] = place
					print(place.address, place.city)
					self.save()
				}
			}
		}
	}

	func mapAddAnnotation(location: CLLocationCoordinate2D, title: String) {
		let annotation = MKPointAnnotation()
		annotation.coordinate = location
		annotation.title = title
		mapView.addAnnotation(annotation)
	}
	
	func mapAddPlaceAnnotation(place: Place) {
		let annotation = MKPointAnnotation()
		annotation.coordinate = CLLocationCoordinate2DMake(place.latitude, place.longitude)
		annotation.title = place.name
		annotation.subtitle = place.address
		mapView.addAnnotation(annotation)
	}
	
	func clearMap() {
		mapView.removeAnnotations(mapView.annotations)
	}
	
	func showAlert(aTitle: String, aMessage: String) {
		let alert = UIAlertController(title: aTitle, message: aMessage, preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil) )
		presentViewController(alert, animated: true, completion: nil)
	}
	
	// MARK: Save to storage
	
	func save() {
		let savedData = NSKeyedArchiver.archivedDataWithRootObject(places)
		stdUserDefaults.setObject(savedData, forKey: "places")
	}
	
	// MARK: MapView Delegates
	
	func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
		// mapView
		// https://www.hackingwithswift.com/read/19/3/annotations-and-accessory-views-mkpinannotationview
		// pin color:
		// http://stackoverflow.com/questions/32815367/change-color-pin-ios-9-mapkit
		// UIColor
		// https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIColor_Class/index.html#//apple_ref/occ/cl/UIColor
		print("viewForAnnotation called")
		
		let annotationView = MKPinAnnotationView()
		// set pin color
		annotationView.pinTintColor = UIColor(red:0.093,  green:0.501,  blue:0.982, alpha:1)
		// show bubble on tap
		annotationView.canShowCallout = true
		// set bubble offset
		annotationView.calloutOffset = CGPoint(x: -8, y: -2)
		
		return annotationView
	}
	
	// Customize map annotations
	// http://sweettutos.com/2016/03/16/how-to-completely-customise-your-map-annotations-callout-views/
	func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
		if view is MKUserLocation {
			return
		}
		
		
	}

	// MARK: LocationManager Delegates
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		let locationData = locations[0]
		print(locationData)
		mapPlace.latitude = locationData.coordinate.latitude
		mapPlace.longitude = locationData.coordinate.longitude
		setMapLocation(mapPlace)
		locationManager.stopUpdatingLocation()
	}

}

