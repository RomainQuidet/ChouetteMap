//
//  ViewController.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 22/05/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
	
	private let scrollView = NSScrollView(frame: .zero)
	private let model: MainModel
	
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
		scrollView.backgroundColor = .black
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.borderType = .bezelBorder
		scrollView.usesPredominantAxisScrolling = true
		scrollView.hasVerticalScroller = true
		scrollView.hasHorizontalScroller = true
		self.view.addSubview(scrollView)
		scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
		scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
		scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
		scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
		
		self.loadModel()
	}
	
	override func viewWillAppear() {
		super.viewWillAppear()
		
	}
	
	override func viewDidAppear() {
		scrollView.flashScrollers()
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
		debugPrint("zoom !!")
	}
	
	//MARK: - Private
	
	private func loadModel() {
		guard let image = NSImage(contentsOfFile: self.model.mapPath) else {
			return
		}
		let size = image.size
		let imageView = NSImageView(image: image)
		imageView.frame = NSMakeRect(0, 0, size.width, size.height)
		scrollView.documentView = imageView
	}
}

