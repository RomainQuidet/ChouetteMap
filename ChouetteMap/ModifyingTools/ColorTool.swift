//
//  ColorTool.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 13/06/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa

class ColorTool: MapTool {
	
	var delegate: MapToolDelegate?
	
	var title: String? {
		return "Color"
	}
	
	var icon: NSImage?
	
	var tooltip: String {
		return "pick up a drawing color"
	}
	
	func start(canvas: NSSize, mapScale: Double) {
		//
	}
	
	func reset() {
		//
	}
	
	func didClick(at point: NSPoint, found geometry: DrawingGeometry?) {
		geometry?.geometry.updateColor(self.color)
		self.delegate?.needsRedraw()
	}
	
	//MARK: - Custom
	
	var color: NSColor = .black
}
