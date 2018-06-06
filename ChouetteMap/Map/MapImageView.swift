//
//  MapImageView.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 22/05/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa
import QuartzCore

class MapImageView: NSImageView, DrawingToolDelegate {
	
	var zoom: CGFloat = 1
	
	private var geometries = [DrawingGeometry]()
	private var currentDrawingTool: DrawingTool?
	
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
	
	//MARK: - Mouse Events
	
	override func mouseDown(with event: NSEvent) {
		let eventLocation = event.locationInWindow
		let localLocation = self.convert(eventLocation, from: nil)
		debugPrint("mouse down at \(eventLocation) - \(localLocation)")
		if let drawingTool = self.currentDrawingTool {
			drawingTool.didClick(at: localLocation, found: nil)
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
}
