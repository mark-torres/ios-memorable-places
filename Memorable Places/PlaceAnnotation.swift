//
//  PlaceAnnotation.swift
//  Memorable Places
//
//  Created by Mark Torres on 4/12/16.
//  Copyright © 2016 HSoft Inc. All rights reserved.
//

import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
	// MARK: Properties
	var coordinate: CLLocationCoordinate2D
	var name: String!
	var address: String!
	// var image: UIImage!
	
	// MARK: Methods
	init(coordinate: CLLocationCoordinate2D) {
		self.coordinate = coordinate
	}
}
