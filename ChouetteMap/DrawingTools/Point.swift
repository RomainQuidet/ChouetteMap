//
//  Point.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 06/06/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa

extension NSPoint {
	
	func direction(to point: NSPoint) -> Angle {
		let deltaX = Double(point.x - self.x)
		let deltaY = Double(point.y - self.y)

		// DeltaX = Hyp x cos alpha
		// DeltaY = Hyp x sin alpha
		
		let alpha = atan2(deltaY, deltaX)
		let result = Angle(radians: alpha)
		return result
	}
	
	func distance(to point: NSPoint) -> Double {
		let deltaX = Double(point.x - self.x)
		let deltaY = Double(point.y - self.y)
		return sqrt(pow(deltaX, 2) + pow(deltaY, 2))
	}
}
