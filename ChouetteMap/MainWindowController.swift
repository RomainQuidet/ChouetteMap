//
//  MainWindowController.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 22/05/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, MainToolbarDelegate {
	
	//MARK: - Lifecycle
	
	override init(window: NSWindow?) {
		super.init(window: window)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
    override func windowDidLoad() {
        super.windowDidLoad()
		if let window = self.window {
			window.title = "Chouette Map"
			let toolbar = MainToolbar(identifier: NSToolbar.Identifier("MainToolbar"))
			toolbar.mainDelegate = self
			window.toolbar = toolbar
		}
    }
	
	//MARK: - MainToolbarDelegate
	
	func didZoom(direction: MainToolbar.ZoomDirection) {
		if let viewController = self.window?.contentViewController as? MainViewController {
			viewController.zoom(direction)
		}
	}

}
