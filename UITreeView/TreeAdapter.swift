//
//  TreeAdapter.swift
//  UITreeView
//
//  Created by Julien Mineraud on 15/05/2019.
//  Copyright © 2019 Moprim. All rights reserved.
//

import Foundation

protocol TreeNodeChangeListener {
    // protocol definition goes here
    func onDataSetChanged()
    func onWeightsChanged()
}

public class TreeAdapter {
    
    enum TreeViewError: Error {
        case noSuchElement(path: [String])
    }
    
    public init() {}
    
    private var rootNodes = [TreeNode]()
    private var depth: Int = 0
    private var minimumDepth = 1
    
    public func addRootNode(label: String, weight: Double, color: UIColor?, icon: UIImage?) -> TreeNode {
        let rootNode = TreeNode.rootNode(label: label, weight: weight, color: color, icon: icon)
        if rootNode.getDepth() > self.depth {
            self.depth = rootNode.getDepth()
        }
        self.rootNodes.append(rootNode)
        return rootNode;
    }
    
    public func addChildNode(parent: TreeNode, label: String, weight: Double,
                             color: UIColor?, icon: UIImage?) -> TreeNode {
        let childNode = TreeNode.childNode(parent: parent, label: label, weight: weight, color: color, icon: icon)
        if childNode.getDepth() > self.depth {
            self.depth = childNode.getDepth()
        }
        return childNode
    }
    
    public func addChildNode(parent: TreeNode, label: String,
                             color: UIColor?, icon: UIImage?) -> TreeNode {
        return addChildNode(parent: parent, label: label, weight: 0.0, color: color, icon: icon)
    }
    
    public func updateWeight(weight: Double, path: [String], accumulate: Bool) throws {
        var possibleNodes = rootNodes
        for i in 0 ..< path.count {
            var foundIt = false
            for node in possibleNodes {
                if path[i] == node.getLabel() {
                    foundIt = true
                    if i == path.count - 1 {
                        if accumulate {
                            node.setWeight(weight: weight + node.getWeight())
                        }
                        else {
                            node.setWeight(weight: weight)
                        }
                        return
                    }
                    else {
                        possibleNodes = node.getChildren()
                    }
                    break
                }
            }
            if !foundIt {
                throw TreeViewError.noSuchElement(path: path)
            }
        }
        throw TreeViewError.noSuchElement(path: path)
    }
    
    public func getRootNodes() -> [TreeNode] {
        return rootNodes
    }
    
    private func resetWeights(nodes: [TreeNode]) {
        for node in nodes {
            node.setWeight(weight: 0)
            self.resetWeights(nodes: node.getChildren())
        }
    }
    
    public func resetWeights() {
        self.resetWeights(nodes: self.rootNodes)
    }
    
    public func setMinimumDepth(depth: Int) {
        self.minimumDepth = depth
    }
    
    public func getDepth() -> Int {
        return self.depth
    }

}
