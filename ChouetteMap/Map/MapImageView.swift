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
	}

	//MARK: - Mouse Events
	
	override func mouseDown(with event: NSEvent) {
		let eventLocation = event.locationInWindow
		let localLocation = self.convert(eventLocation, from: nil)
		debugPrint("mouse down at \(eventLocation) - \(localLocation)")
		if let mapTool = self.currentMapTool {
			mapTool.didClick(at: localLocation, found: nil)
		}
	}
	
	//MARK: - Drawing
	
	private func drawGeometries(inContext context: CGContext) {
		self.geometries.forEach({ (geometry) in
			context.addPath(geometry.drawingPath)
			context.setStrokeColor(.black)
			context.setLineWidth(geometry.geometry.width / zoom)
			context.strokePath()
		})
	}
	
	//MARK: - MapToolDelegate
	
	func didCreate(_ geometry: DrawingGeometry) {
		self.geometries.append(geometry)
		self.setNeedsDisplay()
		self.currentMapTool?.reset()
	}

	func showUserText(value: String) {
		let alert = NSAlert()
		alert.messageText = "Measure: \(value)"
		alert.addButton(withTitle: "OK")
		let _ = alert.runModal()
	}
}
