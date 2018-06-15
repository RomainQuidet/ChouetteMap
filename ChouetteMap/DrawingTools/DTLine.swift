//
//  DTLine.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 14/06/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa

class DTLine: MapTool {
	
	private var canvasSize: NSSize?
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
		self.canvasSize = canvas
	}
	
	func reset() {
		self.initialPoint = nil
	}
	
	func didClick(at point: NSPoint, found geometry: DrawingGeometry?) {
		self.initialPoint = point
	}
	
	func reuseGeometry(_ geometry: CMGeometry) {
		guard let geo = geometry as? CMLine else {
			debugPrint("only use CMLine with line tool ;)")
			return
		}
		guard let canvas = self.canvasSize else {
				debugPrint("Error, set canvas size first")
				return
		}
		
		let path = self.getDrawingPath(canvasSize: canvas, point: geo.center, angle: Angle(radians: geo.angle))
		let selectablePath = path.selectablePath(currentWidth: geo.width)
		let result = DrawingGeometry(geometry: geo, drawingPath: path, selectionPath: selectablePath)
		self.delegate?.didCreate(result)
	}
	
	//MARK: - Specific
	
	func set(angle: Angle) {
		guard let canvas = self.canvasSize,
			let point = self.initialPoint else {
				debugPrint("Error, set canvas size and select a point first")
				return
		}
		
		let path = self.getDrawingPath(canvasSize: canvas, point: point, angle: angle)
		let line = CMLine(center: point, angle: angle)
		let selectablePath = path.selectablePath(currentWidth: line.width)
		
		let result = DrawingGeometry(geometry: line, drawingPath: path, selectionPath: selectablePath)
		self.delegate?.didCreate(result)
	}
	
	//MARK: - Private
	
	private func getDrawingPath(canvasSize: NSSize, point: NSPoint, angle: Angle) -> CGPath {
		let maxHyp = sqrt(canvasSize.width*canvasSize.width + canvasSize.height*canvasSize.height)
		let deltaX = CGFloat(angle.cos) * maxHyp
		let deltaY = CGFloat(angle.sin) * maxHyp
		
		let path = CGMutablePath()
		let topPoint = NSPoint(x: point.x + deltaX, y: point.y + deltaY)
		path.move(to: topPoint)
		let bottomPoint = NSPoint(x: point.x - deltaX, y: point.y - deltaY)
		path.addLine(to: bottomPoint)
		return path
	}
}
