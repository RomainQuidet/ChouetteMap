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
	func didAskWorkSave()
	func didAskWorkLoad()
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
				return "Ratio"
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
	enum Geometry: Int {
		case pointSingle = 0, pointSymetric, circleFromCenterRadius
	}
	enum MapFileItem: Int {
		case map = 0, ratio
	}
	
	enum WorkFileItem: Int {
		case load = 0, save
	}
	
	private enum ItemsIdentifiers: String {
		case GeometryItems, ZoomItems, SpaceItem, MapFileItem, WorkFileItem
	}
	
	private let availableItemsIdentifiers: [NSToolbarItem.Identifier]
	private let allowedItemIds = [ItemsIdentifiers.GeometryItems,
								  ItemsIdentifiers.ZoomItems,
								  ItemsIdentifiers.MapFileItem,
								  ItemsIdentifiers.WorkFileItem]

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
			case .GeometryItems:
				let segmentedControl = NSSegmentedControl(labels: ["Point1", "Point2", "Circle1", "Circle2"], trackingMode: .selectOne, target: self, action: #selector(didSelectGeometryItem))
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
		debugPrint("didSelectPointItem")
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
					debugPrint("TODO ratio")
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
}
