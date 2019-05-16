//
//  TreeView.swift
//  TreeView
//
//  Created by Julien Mineraud on 15/05/2019.
//  Copyright © 2019 Moprim. All rights reserved.
//

import UIKit

@IBDesignable
open class UITreeView: UIView {

    /// The inner radius weight.
    @IBInspectable open var innerRadiusWeight: CGFloat {
        get {
            return self.treeViewLayer.innerRadiusWeight
            // innerRadiusWeight
        }
        set {
            self.treeViewLayer.innerRadiusWeight = newValue
        }
    }
    
    /// The inner radius weight.
    open var adapter: TreeAdapter? {
        get {
            return self.treeViewLayer.adapter
            // innerRadiusWeight
        }
        set {
            self.treeViewLayer.adapter = newValue
        }
    }
    
    open override class var layerClass: AnyClass {
        // NSLog("layerClass")
        return UITreeViewLayer.self
    }
    
    private var treeViewLayer: UITreeViewLayer {
        return layer as! UITreeViewLayer
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    init() {
        super.init(frame: .zero)
        // NSLog("init frame zero")
        setup()
    }
    
    private func setup() {
        // NSLog("setup")
        layer.drawsAsynchronously = true
        layer.contentsScale = UIScreen.main.scale
        isAccessibilityElement = true
        #if swift(>=4.2)
        accessibilityTraits = UIAccessibilityTraits.updatesFrequently
        #else
        accessibilityTraits = UIAccessibilityTraitUpdatesFrequently
        #endif
        accessibilityLabel = "UITreeView"
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
//    // MARK: Accessibility
//    private var overriddenAccessibilityValue: String?
//
//    open override var accessibilityValue: String? {
//        get {
//            if let override = overriddenAccessibilityValue {
//                return override
//            }
//            return String(format: "%.f%%", progress * 100)
//        }
//        set {
//            overriddenAccessibilityValue = newValue
//        }
//    }
}
