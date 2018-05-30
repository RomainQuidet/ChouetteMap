//
//  CMLine.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 22/05/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa

class CMLine: CMGeometry {
	let angle: Angle
	var half: Bool = false
	
	required init(center: NSPoint, angle: Angle, color: NSColor = .black, width: Float = 2) {
		self.angle = angle
		super.init(center: center, color: color, width: width)
	}
	
	required init(from decoder: Decoder) throws {
		fatalError("init(from:) has not been implemented")
	}
}
