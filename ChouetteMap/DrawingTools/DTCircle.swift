//
//  DTCircle.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 14/06/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa

class DTCircle: MapTool {
	
	private var mapScale: Double = 0
	private(set) var initialPoint: NSPoint?
	
	//MARK: DrawingTool
	
	weak var delegate: MapToolDelegate?
	
	var title: String? {
		return "to override"
	}
	
	var icon: NSImage?
	
	var tooltip: String {
		return "to override"
	}
	
	func start(canvas: NSSize, mapScale: Double) {
		self.mapScale = mapScale
	}
	
	func reset() {
		self.initialPoint = nil
	}
	
	func didClick(at point: NSPoint, found geometry: DrawingGeometry?) {
		self.initialPoint = point
	}
	
	//MARK: - Specific
	
	// radius in km
	func set(radius: Double) {
		guard let point = self.initialPoint else {
				debugPrint("Error, select a point first")
				return
		}
		let radiusFloat = CGFloat(radius * 1000 / mapScale) 
		let rect = CGRect(x: point.x - radiusFloat, y: point.y - radiusFloat, width: radiusFloat * 2, height: radiusFloat * 2)
		let path = CGPath(ellipseIn: rect, transform: nil)
		
		let circle = CMCircle(center: point)
		circle.radius = radiusFloat
		let selectablePath = path.selectablePath(currentWidth: circle.width)
		
		let result = DrawingGeometry(geometry: circle, drawingPath: path, selectionPath: selectablePath)
		self.delegate?.didCreate(result)
	}
}
