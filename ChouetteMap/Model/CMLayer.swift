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
	
	private enum CodingKeys : String, CodingKey {
		case label
		case geometries
	}
	
	init(_ label: String) {
		self.label = label
		self.geometries = []
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CMLayer.CodingKeys.self)
		label = try container.decode(String.self, forKey: .label)
		geometries = []
		var geometriesToDecode = try container.nestedUnkeyedContainer(forKey: .geometries)
		while geometriesToDecode.isAtEnd == false {
			if let line = try? geometriesToDecode.decode(CMLine.self) {
				geometries.append(line)
				debugPrint("INFO: Loaded a line")
			}
			else if let circle = try? geometriesToDecode.decode(CMCircle.self) {
				geometries.append(circle)
				debugPrint("INFO: Loaded a circle")
			}
			else {
				debugPrint("ERROR: can't decode geometry")
				break
			}
		}
	}
}
