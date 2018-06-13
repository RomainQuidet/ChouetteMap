//
//  MapImageView.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 22/05/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa
import QuartzCore

class MapImageView: NSImageView, MapToolDelegate {
	
	var zoom: CGFloat = 1
	var mapScale: Double = 1
	var currentColor: NSColor?
	var currentWidth: CGFloat?
	
	private var geometries = [DrawingGeometry]()
	private var currentMapTool: MapTool?
	
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

		guard let context = NSGraphicsContext.current?.cgContext else {
			return
		}
		
		drawGeometries(inContext: context)
    }
	
	//MARK: - Public
	
	func set(_ mapTool: MapTool) {
		self.currentMapTool?.delegate = nil
		self.currentMapTool?.reset()
		
		self.currentMapTool = mapTool
		self.currentMapTool?.delegate = self
		self.currentMapTool?.reset()
		self.currentMapTool?.start(canvas: self.bounds.size, mapScale: self.mapScale)
		
		if let colorTool = mapTool as? ColorTool {
			self.currentColor = colorTool.color
		}
		else if let widthTool = mapTool as? WidthTool {
			self.currentWidth = widthTool.width
		}
	}

	//MARK: - Mouse Events
	
	override func mouseDown(with event: NSEvent) {
		let eventLocation = event.locationInWindow
		let localLocation = self.convert(eventLocation, from: nil)
		debugPrint("mouse down at \(eventLocation) - \(localLocation)")
		var hitGeometry: DrawingGeometry?
		for geometry in self.geometries {
			if geometry.selectionPath.contains(localLocation) {
				debugPrint("yee mouse hit !")
				hitGeometry = geometry
				break
			}
		}
		if let mapTool = self.currentMapTool {
			mapTool.didClick(at: localLocation, found: hitGeometry)
		}
	}
	
	//MARK: - Drawing
	
	private func drawGeometries(inContext context: CGContext) {
		self.geometries.forEach({ (geometry) in
			context.addPath(geometry.drawingPath)
			context.setStrokeColor(geometry.currentColor.cgColor)
			context.setLineWidth(geometry.geometry.width / zoom)
			context.strokePath()
		})
	}
	
	//MARK: - MapToolDelegate
	
	func didCreate(_ geometry: DrawingGeometry) {
		self.geometries.append(geometry)
		if let color = self.currentColor {
			geometry.geometry.updateColor(color)
		}
		if let width = self.currentWidth {
			geometry.geometry.width = width
		}
		self.setNeedsDisplay()
		self.currentMapTool?.reset()
	}

	func showUserText(value: String) {
		let alert = NSAlert()
		alert.messageText = "Measure: \(value)"
		alert.addButton(withTitle: "OK")
		let _ = alert.runModal()
	}
	
	func delete(_ geometry: DrawingGeometry) {
		let index = self.geometries.index { (geometryInList) -> Bool in
			if geometry == geometryInList { return true}
			return false
		}
		if let index = index {
			self.geometries.remove(at: index)
			self.setNeedsDisplay()
		}
	}
}
