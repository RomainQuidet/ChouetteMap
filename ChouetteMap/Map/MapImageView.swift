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
	
	private let geo = PointAndAngleDrawingTool()
	private var geometries = [DrawingGeometry]()
	
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		geo.delegate = self
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
	
	//MARK: - Mouse Events
	
	override func mouseDown(with event: NSEvent) {
		let eventLocation = event.locationInWindow
		let localLocation = self.convert(eventLocation, from: nil)
		debugPrint("mouse down at \(eventLocation) - \(localLocation)")
		self.geo.start(with: self.bounds.size)
		self.geo.didClick(at: localLocation, found: nil)
		DispatchQueue.main.asyncAfter(deadline: .now()+1) {
			self.geo.set(angle: Angle(degrees: 12))
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
	}
}
