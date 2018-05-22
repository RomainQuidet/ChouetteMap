//
//  MapImageView.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 22/05/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa
import QuartzCore

class MapImageView: NSImageView {
	
	var point: NSPoint?

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
		self.point = localLocation
		self.setNeedsDisplay()
	}
	
	//MARK: - Drawing
	
	private func drawLine(inContext context: CGContext) {
		if let point = self.point {
			let path = CGMutablePath()
			path.move(to: point)
			let endpoint = NSPoint(x: point.x + 100, y: point.y + 55)
			path.addLine(to: endpoint)
			context.addPath(path)
			context.setStrokeColor(.black)
			context.setLineWidth(2)
			context.strokePath()
		}
		
	}
    
}
