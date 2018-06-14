//
//  DTLineHorizontal.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 14/06/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa

class DTLineHorizontal: DTLine {
	
	override
	var title: String? {
		return "L=H"
	}
	
	override
	var tooltip: String {
		return "Draw an horizontal line"
	}
	
	override
	func didClick(at point: NSPoint, found geometry: DrawingGeometry?) {
		super.didClick(at: point, found: nil)
		let angle = Angle(radians: 0)
		self.set(angle: angle)
	}
}
