//
//  DeleteTool.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 13/06/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa

class DeleteTool: MapTool {
	var delegate: MapToolDelegate?
	
	var title: String? {
		return "Delete"
	}
	
	var icon: NSImage?
	
	var tooltip: String {
		return "Delete an item"
	}
	
	func start(canvas: NSSize, mapScale: Double) {
		//
	}
	
	func reset() {
		//
	}
	
	func didClick(at point: NSPoint, found geometry: DrawingGeometry?) {
		if let geo = geometry {
			self.delegate?.delete(geo)
		}
	}
}
