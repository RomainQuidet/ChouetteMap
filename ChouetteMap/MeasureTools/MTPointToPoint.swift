//
//  MTPointToPoint.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 10/06/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa
import MapKit

class MTPointToPoint: MeasureTool {
	
	private var mapScale: Double = 0
	private(set) var initialPoint: NSPoint?
	
	//MARK: DrawingTool
	
	weak var delegate: MeasureToolDelegate?
	
	var title: String? {
		return "M=1pt+1pt"
	}
	
	var icon: NSImage?
	
	var tooltip: String {
		return "Measure distance between two points"
	}
	
	func start(with mapScale: Double) {
		self.mapScale = mapScale
	}
	
	func reset() {
		self.initialPoint = nil
	}
	
	func didClick(at point: NSPoint) {
		if self.initialPoint == nil {
			self.initialPoint = point
		}
		else {
			let distance = self.initialPoint!.distance(to: point)
			debugPrint("found \(distance) points at \(self.mapScale) scale")
			let meters = distance * mapScale
			let formatter = MKDistanceFormatter()
			formatter.unitStyle = .abbreviated
			formatter.units = .metric
			let text = formatter.string(fromDistance: meters)
			self.delegate?.showUserText(value: text)
			self.reset()
		}
	}
}
