//
//  TreeViewLayer.swift
//  UITreeView
//
//  Created by Julien Mineraud on 15/05/2019.
//  Copyright © 2019 Moprim. All rights reserved.
//

import UIKit

class UITreeViewLayer: CALayer, TreeNodeChangeListener {
    
    private var drawableTreeNodes = [String : DrawableTreeNode]()
    
    /// Tells if the view is radial or not.
    /// FIXME currently not in use, only radial view has been implemented
    @objc open var radialView: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// Tells if we use animations when weights are updated.
    /// TODO implement the animation when weights are modifieds
    @objc open var doAnimate: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The inner radius weight.
    @objc open var innerRadiusWeight: CGFloat = 2.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The skip length.
    @objc open var skipLength: Double = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The layer height.
    @objc open var layerHeight: CGFloat = 50.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// the adapter
    var adapter: TreeAdapter? = nil {
        didSet {
            if let a = adapter {
                a.delegate = self
            }
            setNeedsDisplay()
        }
    }
    
    private var calculatedLayerHeight: CGFloat = 0
    private var depth: Int = 0
    
    private func getInnerCircleForDepth(depth: Int) -> CGRect {
        let centerX = bounds.width / 2;
        let centerY = bounds.height / 2;
        // NSLog("calculatedLayerHeight: %f", self.calculatedLayerHeight)
        let offset = depth == 1 ? 0 : (CGFloat(depth - 1) * self.calculatedLayerHeight + self.calculatedLayerHeight * 0.05);
        let innerRadius = self.innerRadiusWeight * calculatedLayerHeight;
        return CGRect(
            x: centerX - innerRadius - offset,
            y: centerY - innerRadius - offset,
            width: 2 * (innerRadius + offset),
            height: 2 * (innerRadius + offset)
        )
    }
    
    private func getOuterCircleForDepth(depth: Int) -> CGRect {
        let centerX = bounds.width / 2;
        let centerY = bounds.height / 2;
        let offset = CGFloat(depth) * self.calculatedLayerHeight;
        let innerRadius = self.innerRadiusWeight * calculatedLayerHeight;
        return CGRect(
            x: centerX - innerRadius - offset,
            y: centerY - innerRadius - offset,
            width: 2 * (innerRadius + offset),
            height: 2 * (innerRadius + offset)
        )
    }
    
    private func setDrawableTreeNodes() {
        self.drawableTreeNodes = [:]
        if let adt = adapter {
            makeDrawableTreeNodes(nodes: adt.getRootNodes(), parentStart: 0, parentSweep: 360, parentWeight: -1)
        }
    }
    
    private func makeDrawableTreeNodes(nodes: [TreeNode], parentStart: Double, parentSweep: Double, parentWeight: Double) {
        
        var totalWeight: Double = 0
        var depth: Int = -1
        var nonZeroNodeCounter: Int = 0;
        
        for node in nodes {
            totalWeight += node.getWeight()
            if node.getWeight() > 0 {
                nonZeroNodeCounter += 1
            }
            if depth == -1 {
                depth = node.getDepth()
            }
            else if depth != node.getDepth() {
                NSLog("The depth of the nodes are not all equal")
            }
        }
    
        if parentWeight > 0 {
            if parentWeight < totalWeight {
                NSLog("Given weight is smaller than total weight, dismissed")
            }
            else {
                totalWeight = parentWeight;
            }
        }
    
        var nodeStart = parentStart
    
        // We just want to remove skipLength between nodes
        var parentSweep = parentSweep
        // NSLog("parent sweep: %f, nzc: %d", parentSweep, nonZeroNodeCounter)
        if nonZeroNodeCounter > 1 {
            parentSweep -= Double(nonZeroNodeCounter - (depth <= 1 ? 0 : 1)) * skipLength
        }
    
        var nonZeroWeightIndex: Int = 0
    
        for node in nodes {
            // For the radial view, I need to create the inner and outer circle
            let innerCircle = getInnerCircleForDepth(depth: depth)
            let outerCircle = getOuterCircleForDepth(depth: depth)
    
            var nodeSweep = 0.0;
            if node.getWeight() > 0 {
                if nonZeroWeightIndex > 0 {
                    nodeStart += 1;  // Adding some offset to separate the drawables
                }
                nodeSweep = (node.getWeight() / totalWeight) * parentSweep
                nonZeroWeightIndex += 1
            }
            // FIXME, dirty fix because the maximum sweep is 360 degrees
            if nodeStart + nodeSweep > 360 {
                nodeSweep = 360 - nodeStart
            }
            // NSLog("Drawable node %@, start=%f, sweep=%f", node.getPath(), nodeStart, nodeSweep)
            drawableTreeNodes[node.getPath()] = DrawableTreeNode(node: node,
                                                                 innerCircle: innerCircle,
                                                                 outerCircle: outerCircle,
                                                                 start: nodeStart,
                                                                 sweep: nodeSweep,
                                                                 iconSize: 0.75 * self.calculatedLayerHeight)

            if node.getChildren().count > 0 {
                makeDrawableTreeNodes(nodes: node.getChildren(),
                                      parentStart: nodeStart,
                                      parentSweep: nodeSweep,
                                      parentWeight: node.getWeight())
            }
            nodeStart += nodeSweep;
        }
    }
    
    private func drawContent(in context: CGContext) {
        // NSLog("drawContent")
        if let adt = self.adapter {
            let layers = CGFloat(adt.getDepth()) + self.innerRadiusWeight;
            let squareSize = min(bounds.width, bounds.height)
            // NSLog("squareSize = %f", squareSize)
            self.calculatedLayerHeight = squareSize
            self.calculatedLayerHeight -= CGFloat(Double(self.depth) * self.skipLength);
            self.calculatedLayerHeight /= layers * 2;
            setDrawableTreeNodes()
            for (_, dn) in drawableTreeNodes {
                // print("Drawing \(path)")
                dn.drawContent(in: context)
            }
        }
        
    }
    
    open override func display() {
        // NSLog("Display")
        contents = contentImage()
    }
    
    func contentImage() -> CGImage? {
        let size = bounds.size
        if #available(iOS 10.0, tvOS 10.0, *) {
            let format = UIGraphicsImageRendererFormat.default()
            let image = UIGraphicsImageRenderer(size: size, format: format).image { ctx in
                drawContent(in: ctx.cgContext)
            }
            return image.cgImage
        } else {
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            guard let ctx = UIGraphicsGetCurrentContext() else {
                return nil
            }
            drawContent(in: ctx)
            let image = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
            UIGraphicsEndImageContext()
            return image
        }
    }
    
    func onDataSetChanged() {
        setNeedsDisplay()
    }
    
    func onWeightsChanged() {
        // FIXME at the moment we reload all the time, but normally we should not have to reset everything when only weights change
        self.onDataSetChanged()
    }
    
}
