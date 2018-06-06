//
//  PointAndAngleDrawingTool.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 30/05/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa

class DTLineWithPointAndAngle: DrawingTool {
	
	private var canvasSize: NSSize?
	private(set) var initialPoint: NSPoint?
	
	//MARK: DrawingTool
	
	weak var delegate: DrawingToolDelegate?
	
	var title: String? {
		return "L=1pt+A"
	}
	
	var icon: NSImage?
	
	var tooltip: String {
		return "Draw a line given a point and an angle"
	}
	
	func start(with canvas: NSSize) {
		self.canvasSize = canvas
	}
	
	func reset() {
		self.initialPoint = nil
	}
	
	func didClick(at point: NSPoint, found geometry: DrawingGeometry?) {
		self.initialPoint = point
	}
	
	//MARK: - Specific
	
	func set(angle: Angle) {
		guard let canvas = self.canvasSize,
			let point = self.initialPoint else {
			debugPrint("Error, set canvas size and select a point first")
			return
		}
		let maxHyp = sqrt(canvas.width*canvas.width + canvas.height*canvas.height)
		let deltaX = CGFloat(angle.cos) * maxHyp
		let deltaY = CGFloat(angle.sin) * maxHyp
		
		let path = CGMutablePath()
		path.move(to: point)
		let endpoint = NSPoint(x: point.x + deltaX, y: point.y + deltaY)
		path.addLine(to: endpoint)
		
		let line = CMLine(center: point, angle: angle)
		
		let result = DrawingGeometry(geometry: line, drawingPath: path, selectionPath: path)
		
		self.delegate?.didCreate(result)
	}
}
