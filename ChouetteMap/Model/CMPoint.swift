//
//  CMPoint.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 22/05/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Foundation

class CMPoint: CMGeometry {
	
	required init(from decoder: Decoder) throws {
		try super.init(from: decoder)
	}
	
	override func encode(to encoder: Encoder) throws {
		try super.encode(to: encoder)
	}
}
