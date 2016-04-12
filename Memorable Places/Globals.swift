//
//  Globals.swift
//  Memorable Places
//
//  Created by Mark Torres on 4/5/16.
//  Copyright © 2016 HSoft Inc. All rights reserved.
//

import UIKit

let stdUserDefaults = NSUserDefaults.standardUserDefaults()

let sampleData = [
	Place(name: "Tha Office", latitude: 19.6870724, longitude: -101.1895772, address: "", city: ""),
	Place(name: "Cactux", latitude: 19.7075624, longitude: -101.1884239, address: "", city: "")
]

var places: [Place] = []

var mapPlace: Place = Place()

var activePlaceIndex: Int = -1
