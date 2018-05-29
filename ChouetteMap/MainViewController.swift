//
//  ViewController.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 22/05/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
	
	private let mapView = MapView(frame: .zero)
	private var model: MainModel {
		didSet {
			self.loadModel()
		}
	}
	
	let lastWorkConfigSavePathUserDefaultKey = "lastWorkConfigSavePathUserDefaultKey"
	
	//MARK: - Lifecycle
	
	override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
		let path = Bundle.main.pathForImageResource(NSImage.Name("defaultMap.jpg"))!
		self.model = MainModel(mapPath: path)!
		
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	required init?(coder: NSCoder) {
		let path = Bundle.main.pathForImageResource(NSImage.Name("defaultMap.jpg"))!
		self.model = MainModel(mapPath: path)!
		
		super.init(coder: coder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		mapView.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(mapView)
		mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
		mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
		mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
		mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
		
		if let url = UserDefaults.standard.url(forKey: lastWorkConfigSavePathUserDefaultKey) {
			self.loadModel(from: url)
		}
		else {
			self.loadModel()
		}
	}
	
	override func viewWillAppear() {
		super.viewWillAppear()
	}
	
	override func viewDidAppear() {
		mapView.flashScrollers()
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	//MARK: - Public
	
	func loadMap(from url: URL) {
		if let model = MainModel(mapPath: url.path) {
			self.model = model
		}
	}
	
	func loadModel(from url: URL) {
		do {
			let data = try Data(contentsOf: url)
			if let model = MainModel(json: data) {
				self.model = model
			}
		}
		catch {
			debugPrint("read config failed \(error)")
		}
	}
	
	func saveModel(to url: URL) {
		if let data = self.model.asJSON() {
			try? data.write(to: url)
			UserDefaults.standard.set(url, forKey: lastWorkConfigSavePathUserDefaultKey)
		}
	}
	
	func zoom(_ direction: MainToolbar.ZoomDirection) {
		let step: CGFloat = 0.3
		if direction == .plus {
			self.model.lastZoom += step
		}
		else
		{
			self.model.lastZoom -= step
		}
		
		mapView.magnification = self.model.lastZoom
	}
	
	//MARK: - Private
	
	private func loadModel() {
		guard let image = NSImage(contentsOfFile: self.model.mapPath) else {
			debugPrint("map load fails \(self.model.mapPath)")
			return
		}
		mapView.loadMap(image)
		mapView.magnification = self.model.lastZoom
	}
}

