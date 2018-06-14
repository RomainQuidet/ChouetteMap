//
//  DTCircleWithPointAndRadius.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 14/06/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa

class DTCircleWithPointAndRadius: DTCircle {
	
	//MARK: DrawingTool
	
	override
	var title: String? {
		return "C=1pt+R"
	}
	
	override
	var tooltip: String {
		return "Draw a circle given a point and a radius"
	}
	
	override
	func didClick(at point: NSPoint, found geometry: DrawingGeometry?) {
		super.didClick(at: point, found: nil)
		let alert = NSAlert()
		alert.messageText = "Circle radius in km"
		alert.addButton(withTitle: "OK")
		alert.addButton(withTitle: "Cancel")
		let input = NSTextField(frame: NSMakeRect(0, 0, 200, 24))
		input.stringValue = ""
		alert.accessoryView = input
		let button = alert.runModal()
		if button == NSApplication.ModalResponse.alertFirstButtonReturn {
			let radius = input.doubleValue
			if radius > 0 {
				debugPrint("got radius \(input.stringValue) => \(radius)")
				self.set(radius: radius)
			}
		}
	}
}
