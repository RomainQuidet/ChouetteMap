//
//  CMCircle.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 22/05/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Foundation

class CMCircle: CMGeometry {
	var radius: Double = 5	// km
	
	private enum CodingKeys : String, CodingKey {
		case radius
	}
	
	override func encode(to encoder: Encoder) throws {
		try super.encode(to: encoder)
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(radius, forKey: .radius)
	}
}
