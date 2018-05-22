//
//  ViewController.swift
//  ChouetteMap
//
//  Created by Romain Quidet on 22/05/2018.
//  Copyright © 2018 Romain Quidet. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		let scrollView = NSScrollView(frame: .zero)
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(scrollView)
		scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
		scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
		scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
		scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
	}
	
	override func viewWillAppear() {
		super.viewWillAppear()
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

