//
//  MainWindowController.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 22/05/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
		if let window = self.window {
			window.title = "Chouette Map"
		}
    }

}
