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
	private var model: MainModel
	
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
		
		self.loadModel()
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
	
	func loadModel(from path: String) {
		
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
			return
		}
		mapView.loadMap(image)
		mapView.magnification = self.model.lastZoom
	}
}

