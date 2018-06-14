//
//  MainToolbar.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 22/05/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa

protocol MainToolbarDelegate: class {
	func didZoom(direction: MainToolbar.ZoomDirection)
	func didAskMapLoad()
	func didSet(mapScale: UInt)
	func didAskWorkSave()
	func didAskWorkLoad()
	func didSelect(_ mapTool: MapTool)
	func didAskForColorPanel(for tool: ColorTool)
}

fileprivate extension MainToolbar.ZoomDirection {
	var string: String {
		get {
			switch self {
			case .minus:
				return "-"
			case .plus:
				return "+"
			}
		}
	}
}

fileprivate extension MainToolbar.MapFileItem {
	var string: String {
		get {
			switch self {
			case .map:
				return "Map"
			case .ratio:
				return "Scale"
			}
		}
	}
}

fileprivate extension MainToolbar.WorkFileItem {
	var string: String {
		get {
			switch self {
			case .load:
				return "Load"
			case .save:
				return "Save"
			}
		}
	}
}

class MainToolbar: NSToolbar, NSToolbarDelegate {
	
	var mainDelegate: MainToolbarDelegate?
	enum ZoomDirection: Int {
		case minus = 0, plus
	}
	enum MapFileItem: Int {
		case map = 0, ratio
	}
	
	enum WorkFileItem: Int {
		case load = 0, save
	}
	
	private enum ItemsIdentifiers: String {
		case Drawingtems, MeasureItems, ZoomItems, SpaceItem, MapFileItem, WorkFileItem, ModifyingItems
	}
	
	private let availableItemsIdentifiers: [NSToolbarItem.Identifier]
	private let allowedItemIds = [ItemsIdentifiers.Drawingtems,
								  ItemsIdentifiers.MeasureItems,
								  ItemsIdentifiers.ZoomItems,
								  ItemsIdentifiers.MapFileItem,
								  ItemsIdentifiers.WorkFileItem,
								  ItemsIdentifiers.ModifyingItems]
	
	private let drawingTools: [MapTool] = [DTLineWithPointAndAngle(),
											   DTLineWithPointAndPoint(),
											   DTLinePerpendicular(),
											   DTLineVertical(),
											   DTLineHorizontal(),
											   DTCircleWithPointAndRadius()]
	
	private let measureTools: [MapTool] = [MTPointToPoint()]
	
	private let modifyingTools: [MapTool] = [ColorTool(),
											 WidthTool(),
											 DeleteTool()]

	override init(identifier: NSToolbar.Identifier) {
		self.availableItemsIdentifiers = allowedItemIds.map({ (itemIdentifier) -> NSToolbarItem.Identifier in
			return NSToolbarItem.Identifier(itemIdentifier.rawValue)
		})
		
		super.init(identifier: identifier)
		
		self.displayMode = .iconOnly
		self.showsBaselineSeparator = true
		self.delegate = self
	}
	
	//MARK: - NSToolbarDelegate
	
	func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
		if let identifier = ItemsIdentifiers(rawValue: itemIdentifier.rawValue) {
			switch identifier {
			case .Drawingtems:
				let labels = self.drawingTools.map { (drawingTool) -> String in
					return drawingTool.title!
				}
				let segmentedControl = NSSegmentedControl(labels: labels, trackingMode: .selectOne, target: self, action: #selector(didSelectGeometryItem))
				let item = NSToolbarItem(itemIdentifier: .init(itemIdentifier.rawValue))
				item.view = segmentedControl
				return item
			case .MeasureItems:
				let labels = self.measureTools.map { (measureTool) -> String in
					return measureTool.title!
				}
				let segmentedControl = NSSegmentedControl(labels: labels, trackingMode: .selectOne, target: self, action: #selector(didSelectMeasureItem))
				let item = NSToolbarItem(itemIdentifier: .init(itemIdentifier.rawValue))
				item.view = segmentedControl
				return item
			case .ZoomItems:
				let segmentedControl = NSSegmentedControl(labels: [ZoomDirection.minus.string, ZoomDirection.plus.string],
														  trackingMode: .momentary,
														  target: self,
														  action: #selector(didSelectZoomItem))
				let item = NSToolbarItem(itemIdentifier: .init(itemIdentifier.rawValue))
				item.view = segmentedControl
				return item
			case .MapFileItem:
				let segmentedControl = NSSegmentedControl(labels: [MapFileItem.map.string, MapFileItem.ratio.string],
														  trackingMode: .momentary,
														  target: self,
														  action: #selector(didSelectMapFileItem))
				let item = NSToolbarItem(itemIdentifier: .init(itemIdentifier.rawValue))
				item.view = segmentedControl
				return item
			case .WorkFileItem:
				let segmentedControl = NSSegmentedControl(labels: [WorkFileItem.load.string, WorkFileItem.save.string],
														  trackingMode: .momentary,
														  target: self,
														  action: #selector(didSelectWorkFileItem))
				let item = NSToolbarItem(itemIdentifier: .init(itemIdentifier.rawValue))
				item.view = segmentedControl
				return item
			case .ModifyingItems:
				let labels = self.modifyingTools.map { (tool) -> String in
					return tool.title!
				}
				let segmentedControl = NSSegmentedControl(labels: labels, trackingMode: .selectOne, target: self, action: #selector(didSelectModifyingItem))
				let item = NSToolbarItem(itemIdentifier: .init(itemIdentifier.rawValue))
				item.view = segmentedControl
				return item
			default:
				break
			}
		}
		
		return nil
	}
	
	func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return self.availableItemsIdentifiers
	}
	
	func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return self.availableItemsIdentifiers
	}
	
	func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return self.availableItemsIdentifiers
	}
	
	// MARK: - Items actions
	
	@objc
	func didSelectGeometryItem(segmentedControl: NSSegmentedControl) {
		self.deselectToolsSegments(except: segmentedControl)
		let drawingTool = self.drawingTools[segmentedControl.selectedSegment]
		DispatchQueue.main.async { [weak self] in
			self?.mainDelegate?.didSelect(drawingTool)
		}
	}
	
	@objc
	func didSelectMeasureItem(segmentedControl: NSSegmentedControl) {
		self.deselectToolsSegments(except: segmentedControl)
		let measureTool = self.measureTools[segmentedControl.selectedSegment]
		DispatchQueue.main.async { [weak self] in
			self?.mainDelegate?.didSelect(measureTool)
		}
	}
	
	@objc
	func didSelectModifyingItem(segmentedControl: NSSegmentedControl) {
		self.deselectToolsSegments(except: segmentedControl)
		let modifyingTool = self.modifyingTools[segmentedControl.selectedSegment]
		
		if let colorTool = modifyingTool as? ColorTool {
			self.mainDelegate?.didAskForColorPanel(for: colorTool)
		}
		else if let widthTool = modifyingTool as? WidthTool {
			let alert = NSAlert()
			alert.messageText = "Line width"
			alert.addButton(withTitle: "OK")
			alert.addButton(withTitle: "Cancel")
			let input = NSTextField(frame: NSMakeRect(0, 0, 200, 24))
			input.stringValue = ""
			alert.accessoryView = input
			let button = alert.runModal()
			if button == NSApplication.ModalResponse.alertFirstButtonReturn {
				let width = input.floatValue
				if width > 0 {
					debugPrint("got width \(input.stringValue) => \(width)")
					widthTool.width = CGFloat(width)
					self.mainDelegate?.didSelect(widthTool)
				}
			}
		}
		else {
			DispatchQueue.main.async { [weak self] in
				self?.mainDelegate?.didSelect(modifyingTool)
			}
		}
	}
	
	@objc
	func didSelectZoomItem(segmentedControl: NSSegmentedControl) {
		if let zoomDirection = ZoomDirection(rawValue: segmentedControl.indexOfSelectedItem) {
			DispatchQueue.main.async { [weak self] in
				self?.mainDelegate?.didZoom(direction: zoomDirection)
			}
		}
	}
	
	@objc
	func didSelectMapFileItem(segmentedControl: NSSegmentedControl) {
		if let item = MapFileItem(rawValue: segmentedControl.selectedSegment) {
			DispatchQueue.main.async { [weak self] in
				switch item {
				case .map:
					self?.mainDelegate?.didAskMapLoad()
				case .ratio:
					let alert = NSAlert()
					alert.messageText = "Map scale (meters/pixel)\r989Maxi: 169\r989Mini: 500\rtestMap: 1744"
					alert.addButton(withTitle: "OK")
					alert.addButton(withTitle: "Cancel")
					let input = NSTextField(frame: NSMakeRect(0, 0, 200, 24))
					input.stringValue = ""
					alert.accessoryView = input
					let button = alert.runModal()
					if button == NSApplication.ModalResponse.alertFirstButtonReturn {
						let scale = input.integerValue
						if scale > 0 {
							debugPrint("got scale \(input.stringValue) => \(scale)")
							self?.mainDelegate?.didSet(mapScale: UInt(scale))
						}
					}
				}
			}
		}
	}
	
	@objc
	func didSelectWorkFileItem(segmentedControl: NSSegmentedControl) {
		if let item = WorkFileItem(rawValue: segmentedControl.selectedSegment) {
			DispatchQueue.main.async { [weak self] in
				switch item {
				case .load:
					self?.mainDelegate?.didAskWorkLoad()
				case .save:
					self?.mainDelegate?.didAskWorkSave()
				}
			}
		}
	}
	
	//MARK: - Private
	
	private func deselectToolsSegments(except activatedSegment: NSSegmentedControl) {
		self.visibleItems?.forEach({ (toolbarItem) in
			if let view = toolbarItem.view as? NSSegmentedControl,
				view != activatedSegment {
				view.selectedSegment = -1
			}
		})
	}
}
