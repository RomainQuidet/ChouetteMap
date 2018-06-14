//
//  DTLineWithPointAndPoint.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 06/06/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa

class DTLineWithPointAndPoint: DTLine {

	override var title: String? {
		return "L=1pt+1pt"
	}
	
	override var tooltip: String {
		return "Draw a line given a point and another point"
	}
	
	override func didClick(at point: NSPoint, found geometry: DrawingGeometry?) {
		if self.initialPoint == nil {
			super.didClick(at: point, found: geometry)
		}
		else {
			let angle = self.initialPoint!.direction(to: point)
			self.set(angle: angle)
		}
	}
}
