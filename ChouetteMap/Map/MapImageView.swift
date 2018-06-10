//
//  MapImageView.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 22/05/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa
import QuartzCore

class MapImageView: NSImageView, DrawingToolDelegate, MeasureToolDelegate {
	
	var zoom: CGFloat = 1
	var mapScale: Double = 1
	
	private var geometries = [DrawingGeometry]()
	private var currentDrawingTool: DrawingTool?
	private var currentMeasureTool: MeasureTool?
	
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
		
		drawLine(inContext: context)
    }
	
	//MARK: - Public
	
	func set(_ drawingTool: DrawingTool) {
		self.currentDrawingTool?.delegate = nil
		self.currentDrawingTool?.reset()
		self.currentDrawingTool = drawingTool
		self.currentDrawingTool?.delegate = self
		self.currentDrawingTool?.reset()
		self.currentDrawingTool?.start(with: self.bounds.size)
	}
	
	func set(_ measureTool: MeasureTool) {
		self.currentDrawingTool?.delegate = nil
		self.currentDrawingTool?.reset()
		self.currentDrawingTool = nil
		
		self.currentMeasureTool?.delegate = nil
		self.currentMeasureTool?.reset()
		
		self.currentMeasureTool = measureTool
		self.currentMeasureTool?.delegate = self
		self.currentMeasureTool?.reset()
		self.currentMeasureTool?.start(with: mapScale)
	}
	
	//MARK: - Mouse Events
	
	override func mouseDown(with event: NSEvent) {
		let eventLocation = event.locationInWindow
		let localLocation = self.convert(eventLocation, from: nil)
		debugPrint("mouse down at \(eventLocation) - \(localLocation)")
		if let drawingTool = self.currentDrawingTool {
			drawingTool.didClick(at: localLocation, found: nil)
		}
		else if let measureTool = self.currentMeasureTool {
			measureTool.didClick(at: localLocation)
		}
	}
	
	//MARK: - Drawing
	
	private func drawLine(inContext context: CGContext) {
		for geometry in self.geometries {
			context.addPath(geometry.drawingPath)
			context.setStrokeColor(.black)
			context.setLineWidth(geometry.geometry.width / zoom)
			context.strokePath()
		}
	}
	
	//MARK: - DrawingToolDelegate
	
	func didCreate(_ geometry: DrawingGeometry) {
		self.geometries.append(geometry)
		self.setNeedsDisplay()
		self.currentDrawingTool?.reset()
	}
	
	//MARK: - MeasureToolDelegate
	
	func showUserText(value: String) {
		let alert = NSAlert()
		alert.messageText = "Measure: \(value)"
		alert.addButton(withTitle: "OK")
		let _ = alert.runModal()
	}
}
