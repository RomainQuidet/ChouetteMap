//
//  MapTool.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 13/06/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa

protocol MapToolDelegate: class {
	func didCreate(_ geometry: DrawingGeometry)
	func showUserText(value: String)
}

protocol MapTool {
	var delegate: MapToolDelegate? { get set }
	var title: String? { get }
	var icon: NSImage? { get }
	var tooltip: String { get }
	
	func start(canvas: NSSize, mapScale: Double)
	func reset()
	func didClick(at point: NSPoint, found geometry: DrawingGeometry?)
}
