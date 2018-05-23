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
	var lastZoom: CGFloat = 1
	let originalMapSize: NSSize
	var layers = [CMLayer]()
	
	init?(mapPath: String) {
		guard FileManager.default.fileExists(atPath: mapPath) == true else {
			return nil
		}
		
		self.mapPath = mapPath
		
		guard let image = NSImage(contentsOfFile: mapPath) else {
			return nil
		}
		
		self.originalMapSize = image.size
		let firstLayer = CMLayer(label: "Layer 1", geometries: [])
		self.layers.append(firstLayer)
	}
	
	init?(json: Data) {
		let decoder = JSONDecoder()
		if let model = try? decoder.decode(MainModel.self, from: json) {
			self = model
		}
		else {
			return nil
		}
	}
	
	func asJSON() -> Data? {
		let encoder = JSONEncoder()
		let data = try? encoder.encode(self)
		return data
	}
}
