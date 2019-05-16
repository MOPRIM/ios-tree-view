//
//  ViewController.swift
//  UITreeViewDemo
//
//  Created by Julien Mineraud on 15/05/2019.
//  Copyright © 2019 Moprim. All rights reserved.
//

import UIKit
import UITreeView

class ViewController: UIViewController {
    
    
    var treeView: UITreeView {
        return view as! UITreeView
    }

    override func loadView() {
        let tv = UITreeView()
        // tv.delegate = self
        view = tv
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTreeView()
    }
    
    private func setupTreeView() {
        // Setup tree adapter
        // NSLog("TreeView bounds: %@", treeView.bounds.debugDescription)
        treeView.backgroundColor = UIColor.white
        let adapter = TreeAdapter()
        let vegatables = adapter.addRootNode(label: "vegetables", weight: 1.0, color: UIColor.green, icon: UIImage(named: "vegetables"))
        let fruits = adapter.addRootNode(label: "fruits", weight: 2.0, color: UIColor.red, icon: nil)
        let _ = adapter.addChildNode(parent: vegatables, label: "carrot", weight: 1.0, color: UIColor.orange, icon: nil)
        let _ = adapter.addChildNode(parent: vegatables, label: "leek", weight: 5.0, color: UIColor.magenta, icon: nil)
        let _ = adapter.addChildNode(parent: fruits, label: "pear", weight: 2.0, color: UIColor.blue, icon: nil)
        let _ = adapter.addChildNode(parent: fruits, label: "apple", weight: 3.0, color: UIColor.cyan, icon: nil)
        let _ = adapter.addChildNode(parent: fruits, label: "banana", weight: 1.0, color: UIColor.yellow, icon: UIImage(named: "banana"))
        treeView.adapter = adapter
    }


}

