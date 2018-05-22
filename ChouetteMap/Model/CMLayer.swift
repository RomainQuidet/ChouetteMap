//
//  CMLayer.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 22/05/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa


class CMGeometry: Codable {
	let center: NSPoint
	
	var colorR: Int
	var colorG: Int
	var colorB: Int
	
	var width: Float
		
	init(center: NSPoint, color: NSColor = .black, width: Float = 2) {
		self.center = center
		
		colorR = Int(color.redComponent * 255)
		colorG = Int(color.greenComponent * 255)
		colorB = Int(color.blueComponent * 255)
		
		self.width = width
	}
}

struct CMLayer: Codable {
	var label: String
	var geometries: [CMGeometry]
}
