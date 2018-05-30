//
//  DrawingTool.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 30/05/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa

protocol DrawingToolDelegate: class {
	func didCreate(_ geometry: DrawingGeometry)
}

protocol DrawingTool {
	var delegate: DrawingToolDelegate? { get set }
	var title: String? { get }
	var icon: NSImage? { get }
	var tooltip: String { get }
	
	func start(with canvas: NSSize)
	func reset()
	func didClick(at point: NSPoint, found geometry: DrawingGeometry?)
}
