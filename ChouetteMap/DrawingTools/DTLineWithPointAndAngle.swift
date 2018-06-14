//
//  PointAndAngleDrawingTool.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 30/05/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa

class DTLineWithPointAndAngle: DTLine {
	
	//MARK: DrawingTool
	
	override
	var title: String? {
		return "L=1pt+A"
	}
	
	override
	var tooltip: String {
		return "Draw a line given a point and an angle"
	}
	
	override
	func didClick(at point: NSPoint, found geometry: DrawingGeometry?) {
		super.didClick(at: point, found: nil)
		let alert = NSAlert()
		alert.messageText = "Line angle in degrees (0 to 360°)"
		alert.addButton(withTitle: "OK")
		alert.addButton(withTitle: "Cancel")
		let input = NSTextField(frame: NSMakeRect(0, 0, 200, 24))
		input.stringValue = ""
		alert.accessoryView = input
		let button = alert.runModal()
		if button == NSApplication.ModalResponse.alertFirstButtonReturn {
			let angle = input.doubleValue
			if angle >= 0 {
				debugPrint("got angle \(input.stringValue) => \(angle)")
				self.set(angle: Angle(degrees: angle))
			}
		}
	}
}
