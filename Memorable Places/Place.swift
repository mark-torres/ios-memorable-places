//
//  Place.swift
//  Memorable Places
//
//  Created by Mark Torres on 4/5/16.
//  Copyright © 2016 HSoft Inc. All rights reserved.
//

import UIKit

// Persist data
// https://developer.apple.com/library/ios/referencelibrary/GettingStarted/DevelopiOSAppsSwift/Lesson10.html

// class
// https://developer.apple.com/library/ios/referencelibrary/GettingStarted/DevelopiOSAppsSwift/Lesson6.html

// Storage
// https://www.hackingwithswift.com/read/12/3/fixing-project-10-nscoding

class Place: NSObject, NSCoding {
	// MARK: Properties
	var name: String
	var latitude: Double
	var longitude: Double
	var address: String?
	var city: String?
	
	// MARK: Types
	struct PropertyKey {
		static let nameKey = "name"
		static let latitudeKey = "latitude"
		static let longitudeKey = "longitude"
		static let addressKey = "address"
		static let cityKey = "city"
	}
	
	// constructor
	init(name: String, latitude: Double, longitude: Double, address: String, city: String) {
		self.name = name
		self.latitude = latitude
		self.longitude = longitude
		self.address = address
		self.city = city
	}
	
	override init() {
		self.name = ""
		self.latitude = 0
		self.longitude = 0
	}
	
	// MARK: NSCoding
	func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
		aCoder.encodeDouble(latitude, forKey: PropertyKey.latitudeKey)
		aCoder.encodeDouble(longitude, forKey: PropertyKey.longitudeKey)
		aCoder.encodeObject(address, forKey: PropertyKey.addressKey)
		aCoder.encodeObject(city, forKey: PropertyKey.cityKey)
	}
	
	required convenience init?(coder aDecoder: NSCoder) {
		// required
		let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
		let latitude = aDecoder.decodeDoubleForKey(PropertyKey.latitudeKey) 
		let longitude = aDecoder.decodeDoubleForKey(PropertyKey.longitudeKey)
		// optional
		let address = aDecoder.decodeObjectForKey(PropertyKey.addressKey) as? String ?? ""
		let city = aDecoder.decodeObjectForKey(PropertyKey.cityKey) as? String ?? ""
		
		// Must call designated initializer.
		self.init(name: name, latitude: latitude, longitude: longitude, address: address, city: city)
	}
	
}
