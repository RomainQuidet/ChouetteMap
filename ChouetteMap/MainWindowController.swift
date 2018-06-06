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
				if let url = panel.urls.first,
					let viewController = self.window?.contentViewController as? MainViewController {
					viewController.loadMap(from: url)
				}
			}
			else {
				debugPrint("no file selected")
			}
		}
	}
	
	func didAskWorkSave() {
		let panel = NSSavePanel()
		panel.title = "Save your work"
		panel.prompt = "Save"
		panel.canCreateDirectories = true
		panel.nameFieldLabel = "ChouetteWork.json"
		panel.message = "Save your configuration, map and drawings"
		panel.allowedFileTypes = ["json"]
		panel.beginSheetModal(for: self.window!) { (response) in
			if response == NSApplication.ModalResponse.OK {
				if let url = panel.url,
					let viewController = self.window?.contentViewController as? MainViewController {
					viewController.saveModel(to: url)
				}
			}
			else {
				debugPrint("no file selected")
			}
		}
	}
	
	func didAskWorkLoad() {
		let panel = NSOpenPanel()
		panel.allowsMultipleSelection = false
		panel.canChooseDirectories = false
		panel.canCreateDirectories = false
		panel.canChooseFiles = true
		panel.allowedFileTypes = ["json"]
		panel.beginSheetModal(for: self.window!) { (response) in
			if response == NSApplication.ModalResponse.OK {
				if let url = panel.urls.first,
					let viewController = self.window?.contentViewController as? MainViewController {
					viewController.loadModel(from: url)
				}
			}
			else {
				debugPrint("no file selected")
			}
		}
	}
	
	func didSelect(_ drawingTool: DrawingTool) {
		if let viewController = self.window?.contentViewController as? MainViewController {
			viewController.select(drawingTool)
		}
	}
}
