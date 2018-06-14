//
//  DTLineVertical.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 14/06/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa

class DTLineVertical: DTLine {
	override
	var title: String? {
		return "L=V"
	}
	
	override
	var tooltip: String {
		return "Draw a vertical line"
	}
	
	override
	func didClick(at point: NSPoint, found geometry: DrawingGeometry?) {
		super.didClick(at: point, found: nil)
		let angle = Angle(radians: Angle.pi / 2)
		self.set(angle: angle)
	}
}
