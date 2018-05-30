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
	
	var width: CGFloat
		
	init(center: NSPoint, color: NSColor = .black, width: CGFloat = 2) {
		self.center = center
		
		let decodedColor = color.usingColorSpace(NSColorSpace.deviceRGB)!
		colorR = Int(decodedColor.redComponent * 255)
		colorG = Int(decodedColor.greenComponent * 255)
		colorB = Int(decodedColor.blueComponent * 255)
		
		self.width = width
	}
}

struct CMLayer: Codable {
	var label: String
	var geometries: [CMGeometry]
}
