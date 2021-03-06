//
//  CMLine.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 22/05/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa

class CMLine: CMGeometry {
	let angle: Double
	var half: Bool = false
	
	private enum CodingKeys : String, CodingKey {
		case angle
		case half
	}
	
	required init(center: NSPoint, angle: Angle, color: NSColor = .black, width: Float = 2) {
		self.angle = angle.radians
		super.init(center: center)
	}
	
	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		angle = try container.decode(Double.self, forKey: .angle)
		half = try container.decode(Bool.self, forKey: .half)
		try super.init(from: decoder)
	}
	
	override func encode(to encoder: Encoder) throws {
		try super.encode(to: encoder)
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(angle, forKey: .angle)
		try container.encode(half, forKey: .half)
	}
}
