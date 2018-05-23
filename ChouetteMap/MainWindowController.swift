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
	
	func didAskMapLoad() {
		let panel = NSOpenPanel()
		panel.allowsMultipleSelection = false
		panel.canChooseDirectories = false
		panel.canCreateDirectories = false
		panel.canChooseFiles = true
		panel.allowedFileTypes = ["jpg","png"]
		panel.beginSheetModal(for: self.window!) { (response) in
			if response == NSApplication.ModalResponse.OK {
				if let path = panel.urls.first?.path,
					let viewController = self.window?.contentViewController as? MainViewController {
					viewController.loadMap(from: path)
				}
			}
			else {
				debugPrint("no file selected")
			}
		}
	}

}
