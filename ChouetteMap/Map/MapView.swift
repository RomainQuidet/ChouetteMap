//
//  MapView.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 22/05/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa

class MapView: NSScrollView {
	
	//MARK: - Lifecycle
	
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		self.backgroundColor = .black
		self.borderType = .bezelBorder
		self.usesPredominantAxisScrolling = true
		self.hasVerticalScroller = true
		self.hasHorizontalScroller = true
		self.allowsMagnification = true
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
	
	//MARK: - Public
	
	func loadMap(_ image: NSImage) {
		let size = image.size
		let imageView = MapImageView(image: image)
		imageView.frame = NSMakeRect(0, 0, size.width, size.height)
		self.documentView = imageView
		self.needsDisplay = true
	}
	
	func setZoom(_ zoom: CGFloat) {
		self.magnification = zoom
		if let imageView = self.documentView as? MapImageView {
			imageView.zoom = zoom
		}
	}
	
	func setCurrentDrawingTool(_ tool: DrawingTool) {
		if let imageView = self.documentView as? MapImageView {
			imageView.set(tool)
		}
	}
	
	func setCurrentMeasureTool(_ tool: MeasureTool) {
		if let imageView = self.documentView as? MapImageView {
			imageView.set(tool)
		}
	}
	
	func setMapScale(_ mapScale: UInt) {
		if let screen = self.window?.screen,
			let imageView = self.documentView as? MapImageView,
			let image = imageView.image {
			let scaleFactor = screen.backingScaleFactor
			let localScale = Double(mapScale) * Double(scaleFactor)
			debugPrint("INFO: loaded image is \(image.size) size")
			let rep = image.representations.first!
			debugPrint("INFO: raw image is \(rep.pixelsWide) x \(rep.pixelsHigh)")
			let pixelsPerPoints = Double(rep.pixelsWide) / Double(image.size.width)
			imageView.mapScale = localScale * pixelsPerPoints
		}
	}
}
