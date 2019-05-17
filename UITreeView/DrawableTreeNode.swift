//
//  DrawableTreeNode.swift
//  UITreeView
//
//  Created by Julien Mineraud on 16/05/2019.
//  Copyright © 2019 Moprim. All rights reserved.
//

import Foundation

extension UIColor {
    
    var darker: UIColor {
        return darkerColorForColor(color: self)
    }
    
    func darkerColorForColor(color: UIColor) -> UIColor {
        
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
        
        if color.getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: max(r - 0.2, 0.0), green: max(g - 0.2, 0.0), blue: max(b - 0.2, 0.0), alpha: a)
        }
        
        return UIColor()
    }
}

class DrawableTreeNode {
    
    private let start: Double
    private let sweep: Double
    private let node: TreeNode
    private let innerCircle: CGRect
    private let outerCircle: CGRect
    private let iconSize: CGFloat
    
    init(node: TreeNode, innerCircle: CGRect, outerCircle: CGRect, start: Double, sweep: Double, iconSize: CGFloat) {
        self.node = node
        self.innerCircle = innerCircle
        self.outerCircle = outerCircle
        self.iconSize = iconSize
        self.start = start
        self.sweep = sweep
//        NSLog("Path: %@, start: %.0f, sweep: %.0f, innerCircle: %@, outerCircle: %@", node.getPath(), start, sweep, innerCircle.debugDescription, outerCircle.debugDescription)
    }
        
    func drawContent(in context: CGContext) {
        if self.node.getWeight() < 10e-5 {
            // Empty node
            // NSLog("Empty node %@", node.getPath())
            return
        }
        // Draw the arc
        context.saveGState()
        let bgPath = getBackgroundPath()
        context.addPath(bgPath)
        let bgColor = node.getColor() ?? UIColor.clear
        context.setLineWidth(2.0)
        context.setStrokeColor(bgColor.darker.cgColor)
        context.strokePath()
        context.addPath(bgPath)
        context.setFillColor(bgColor.cgColor)
        context.fillPath()
        context.restoreGState()
        
        let radius = (outerCircle.width - innerCircle.width) / 4.0 + innerCircle.width / 2.0
        let length = CGFloat((sweep / 360.0) * 2 * Double.pi) * radius
        if let i = self.node.getIcon() {
            if self.iconSize >= length {
                // To small to print or nothing to print
                return
            }
            let middle = getMiddlePoint()
            let iconRect = CGRect(x: middle.x - iconSize / 2.0,
                                  y: middle.y - iconSize / 2.0,
                                  width: iconSize,
                                  height: iconSize)
            i.draw(in: iconRect)
        }
    }
    
    private static func toRadians(degrees: Double) -> Double {
        return degrees * Double.pi / 180.0
    }
    
    private func getBackgroundPath() -> CGPath {
        let path = CGMutablePath()
        let arcCenter = CGPoint(
            x: outerCircle.origin.x + outerCircle.width / 2.0,
            y: outerCircle.origin.y + outerCircle.height / 2.0)
        let startAngle = CGFloat(DrawableTreeNode.toRadians(degrees: start))
        let endAngle = CGFloat(DrawableTreeNode.toRadians(degrees: start + sweep))
        // outer arc
//        NSLog("arcCenter: %@, startAngle: %f, endAngle: %f, radius: %f",
//              arcCenter.debugDescription, startAngle, endAngle, outerCircle.width / 2.0)
        path.addArc(
            center: arcCenter,
            radius: outerCircle.width / 2.0,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false)
        // inner arc
        path.addArc(
            center: arcCenter,
            radius: innerCircle.width / 2.0,
            startAngle: endAngle,
            endAngle: startAngle,
            clockwise: true)
        path.closeSubpath()
        return path.copy()!
    }
    
    private func getMiddlePoint() -> CGPoint {
        let path = CGMutablePath()
        let arcCenter = CGPoint(
            x: outerCircle.origin.x + outerCircle.width / 2.0,
            y: outerCircle.origin.y + outerCircle.height / 2.0)
        let radius = (outerCircle.width - innerCircle.width) / 4.0 + innerCircle.width / 2.0
        let startAngle = CGFloat(DrawableTreeNode.toRadians(degrees: start))
        let endAngle = CGFloat(DrawableTreeNode.toRadians(degrees: start + sweep / 2.0))
        // 3
        path.addArc(
            center: arcCenter,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false)
        // 4
        return path.currentPoint
    }
    
}
