//
//  DrawingGeometry.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 30/05/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa

struct DrawingGeometry: Equatable {
	var geometry: CMGeometry
	var drawingPath: CGPath
	var selectionPath: CGPath
	
	static func ==(lhs: DrawingGeometry, rhs: DrawingGeometry) -> Bool {
		return lhs.geometry === rhs.geometry
	}

	var currentColor: NSColor {
		return NSColor(calibratedRed: CGFloat(geometry.colorR) / 255.0,
					   green: CGFloat(geometry.colorG) / 255.0,
					   blue: CGFloat(geometry.colorB) / 255.0,
					   alpha: 1)
	}
}

extension CGPath {
	func selectablePath(currentWidth: CGFloat) -> CGPath {
		let result = self.copy(strokingWithWidth: max(currentWidth, 20.0), lineCap: .square, lineJoin: .round, miterLimit: 200)
		return result
	}
}
