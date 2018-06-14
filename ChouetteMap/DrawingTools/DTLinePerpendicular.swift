//
//  DTLinePerpendicular.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 14/06/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa

class DTLinePerpendicular: DTLine {
	
	override
	var title: String? {
		return "L=-|-"
	}
	
	override
	var tooltip: String {
		return "Draw a line perpendicular to another one"
	}
	
	override
	func didClick(at point: NSPoint, found geometry: DrawingGeometry?) {
		guard let line = geometry?.geometry as? CMLine else {
			debugPrint("need a line too!")
			return
		}
		if self.initialPoint == nil {
			super.didClick(at: point, found: geometry)
		}
		let angle = Angle(radians: line.angle.radians + Angle.pi / 2)
		self.set(angle: angle)
	}
}
