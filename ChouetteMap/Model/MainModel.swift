//
//  MainModel.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 22/05/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa


struct MainModel: Codable {
	let mapPath: String
	var mapScale: UInt = 0
	var lastZoom: CGFloat = 1
	let originalMapSize: NSSize
	var layers = [CMLayer]()
	
	private var lastSelectedLayerIndex: Int = 0
	
	init?(mapPath: String) {
		guard FileManager.default.fileExists(atPath: mapPath) == true else {
			return nil
		}
		
		self.mapPath = mapPath
		
		guard let image = NSImage(contentsOfFile: mapPath) else {
			return nil
		}
		
		self.originalMapSize = image.size
		let firstLayer = CMLayer("Layer 1")
		self.layers.append(firstLayer)
	}
	
	init?(json: Data) {
		let decoder = JSONDecoder()
		if let model = try? decoder.decode(MainModel.self, from: json) {
			guard FileManager.default.fileExists(atPath: model.mapPath) == true else {
				return nil
			}
			self = model
		}
		else {
			return nil
		}
	}
	
	func asJSON() -> Data? {
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		let data = try? encoder.encode(self)
		return data
	}
	
	mutating
	func appendToCurrentLayer(_ geometry: CMGeometry) {
		self.layers[0].geometries.append(geometry)
	}
	
	mutating
	func removeFromCurrentLayer(_ geometry: CMGeometry) {
		if let index = self.layers[0].geometries.firstIndex(where: { (geoInList) -> Bool in
			return geometry === geoInList
		}) {
			self.layers[0].geometries.remove(at: index)
		}
		
	}
}
