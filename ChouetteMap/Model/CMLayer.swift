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
	
	private enum CodingKeys : String, CodingKey {
		case center
		case colorR
		case colorG
		case colorB
		case width
	}
	
	//MARK: - Lifecycle
	
	init(center: NSPoint, color: NSColor = .black, width: CGFloat = 2) {
		self.center = center
		
		let decodedColor = color.usingColorSpace(NSColorSpace.deviceRGB)!
		colorR = Int(decodedColor.redComponent * 255)
		colorG = Int(decodedColor.greenComponent * 255)
		colorB = Int(decodedColor.blueComponent * 255)
		
		self.width = width
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(center, forKey: .center)
		try container.encode(colorR, forKey: .colorR)
		try container.encode(colorG, forKey: .colorG)
		try container.encode(colorB, forKey: .colorB)
		try container.encode(width, forKey: .width)
	}
	
	//MARK: - Public
	
	func updateColor(_ color: NSColor) {
		let decodedColor = color.usingColorSpace(NSColorSpace.deviceRGB)!
		colorR = Int(decodedColor.redComponent * 255)
		colorG = Int(decodedColor.greenComponent * 255)
		colorB = Int(decodedColor.blueComponent * 255)
	}
}

struct CMLayer: Codable {
	var label: String
	var geometries: [CMGeometry]
}
