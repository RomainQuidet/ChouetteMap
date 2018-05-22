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

class MainToolbar: NSToolbar, NSToolbarDelegate {
	
	var mainDelegate: MainToolbarDelegate?
	enum ZoomDirection: Int {
		case minus = 0, plus
	}
	enum Geometry: Int {
		case pointSingle = 0, pointSymetric, circleFromCenterRadius
	}
	
	private enum ItemsIdentifiers: String {
		case GeometryItems, ZoomItems
	}
	
	private let availableItemsIdentifiers: [NSToolbarItem.Identifier]
	private let allowedItemIds = [ItemsIdentifiers.GeometryItems, ItemsIdentifiers.ZoomItems]

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
				let pointsItem = NSToolbarItem(itemIdentifier: .init(itemIdentifier.rawValue))
				pointsItem.view = segmentedControl
				return pointsItem
			case .ZoomItems:
				let segmentedControl = NSSegmentedControl(labels: [ZoomDirection.minus.string, ZoomDirection.plus.string],
														  trackingMode: .momentary,
														  target: self,
														  action: #selector(didSelectZoomItem))
				let zoomsItem = NSToolbarItem(itemIdentifier: .init(itemIdentifier.rawValue))
				zoomsItem.view = segmentedControl
				return zoomsItem
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
}
