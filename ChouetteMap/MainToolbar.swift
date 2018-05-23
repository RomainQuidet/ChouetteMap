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

fileprivate extension MainToolbar.FileItem {
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

class MainToolbar: NSToolbar, NSToolbarDelegate {
	
	var mainDelegate: MainToolbarDelegate?
	enum ZoomDirection: Int {
		case minus = 0, plus
	}
	enum Geometry: Int {
		case pointSingle = 0, pointSymetric, circleFromCenterRadius
	}
	enum FileItem: Int {
		case map = 0, ratio
	}
	
	private enum ItemsIdentifiers: String {
		case GeometryItems, ZoomItems, SpaceItem, FileItems
	}
	
	private let availableItemsIdentifiers: [NSToolbarItem.Identifier]
	private let allowedItemIds = [ItemsIdentifiers.GeometryItems,
								  ItemsIdentifiers.ZoomItems,
								  ItemsIdentifiers.FileItems]

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
			case .FileItems:
				let segmentedControl = NSSegmentedControl(labels: [FileItem.map.string, FileItem.ratio.string],
														  trackingMode: .momentary,
														  target: self,
														  action: #selector(didSelectFileItem))
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
			debugPrint("didSelectZoomItem \(zoomDirection.string)")
			DispatchQueue.main.async { [weak self] in
				self?.mainDelegate?.didZoom(direction: zoomDirection)
			}
		}
	}
	
	@objc
	func didSelectFileItem(segmentedControl: NSSegmentedControl) {
		if let item = FileItem(rawValue: segmentedControl.selectedSegment) {
			debugPrint("did select file item \(item.string)")
			DispatchQueue.main.async { [weak self] in
				self?.mainDelegate?.didAskMapLoad()
			}
		}
	}
}
