//
//  MeasureTool.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 10/06/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa

protocol MeasureToolDelegate: class {
	func showUserText(value: String)
}

protocol MeasureTool {
	var delegate: MeasureToolDelegate? { get set }
	var title: String? { get }
	var icon: NSImage? { get }
	var tooltip: String { get }
	
	func start(with mapScale: Double)
	func reset()
	func didClick(at point: NSPoint)
}
