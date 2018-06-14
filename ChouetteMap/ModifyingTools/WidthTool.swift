//
//  WidthTool.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 13/06/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa

class WidthTool: MapTool {
	var delegate: MapToolDelegate?
	
	var title: String? {
		return "Width"
	}
	
	var icon: NSImage?
	
	var tooltip: String {
		return "change line width"
	}
	
	func start(canvas: NSSize, mapScale: Double) {
		//
	}
	
	func reset() {
		//
	}
	
	func didClick(at point: NSPoint, found geometry: DrawingGeometry?) {
		geometry?.geometry.width = width
		self.delegate?.needsRedraw()
	}
	
	//MARK: Custom
	
	var width: CGFloat = 2.0
}
