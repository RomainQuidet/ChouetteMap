//
//  MainWindowController.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 22/05/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, MainToolbarDelegate {
	
	weak var pendingColorTool: ColorTool?
	
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
			let toolbar = MainToolbar(identifier: "MainToolbar")
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
	
	func didSelect(_ mapTool: MapTool) {
		if let viewController = self.window?.contentViewController as? MainViewController {
			viewController.select(mapTool)
		}
	}
	
	func didSet(mapScale: UInt) {
		if let viewController = self.window?.contentViewController as? MainViewController {
			viewController.setMapScale(mapScale)
		}
	}
	
	func didAskForColorPanel(for tool: ColorTool) {
		self.pendingColorTool = tool
		let panel = NSColorPanel.shared
		panel.styleMask = [.titled, .closable, .miniaturizable, .resizable]
		panel.title = "Chouette colors"
		panel.showsAlpha = false
		panel.isFloatingPanel = true
		panel.hidesOnDeactivate = true
		panel.setTarget(self)
		panel.setAction(#selector(colorChanged))
		panel.maxSize = NSSize(width: 300, height: 600)
		panel.center()
		panel.makeKeyAndOrderFront(nil)
		self.showWindow(panel)
	}
	
	//MARK: - Color panel
	
	@objc
	func colorChanged(_ sender: NSColorPanel) {
		if let tool = self.pendingColorTool,
			let viewController = self.window?.contentViewController as? MainViewController {
			tool.color = sender.color
			viewController.select(tool)
		}
	}
}
