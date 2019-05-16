//
//  TreeNode.swift
//  UITreeView
//
//  Created by Julien Mineraud on 15/05/2019.
// Copyright 2019 Moprim
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at:
//     http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
// either express or implied.
// See the License for the specific language governing permissions
// and limitations under the License.
//

import Foundation

public class TreeNode {
    
    private let parent: TreeNode?
    private var children: [TreeNode]
    private let label: String
    private let depth: Int
    private var weight: Double
    private let color: UIColor?
    private let icon: UIImage?
    
    required init?(parent: TreeNode?, children: [TreeNode], label: String, depth: Int, weight: Double, color: UIColor?, icon: UIImage?) {
        self.parent = parent
        self.children = children
        self.label = label
        self.depth = depth
        self.weight = weight
        self.color = color
        self.icon = icon
    }
    
    public static func rootNode(label: String, weight: Double, color: UIColor?, icon: UIImage?) -> TreeNode {
        return TreeNode(parent: nil, children: [TreeNode](),
                        label: label, depth: 1, weight: weight, color: color, icon: icon)!
    }
    
    public static func childNode(parent: TreeNode, label: String, weight: Double, color: UIColor?, icon: UIImage?) -> TreeNode {
        let childNode = TreeNode(parent: parent, children: [TreeNode](),
                                 label: label, depth: parent.depth + 1,
                                 weight: weight, color: color, icon: icon)
        parent.children.append(childNode!)
        return childNode!
    }
    
    public func getParent() -> TreeNode? {
        return parent
    }
    
    public func getChildren() -> [TreeNode] {
        return children
    }
    
    public func getLabel() -> String {
        return label
    }
    
    public func getDepth() -> Int {
        return depth
    }
    
    public func getWeight() -> Double {
        return weight
    }
    
    public func setWeight(weight: Double) {
        self.weight = weight
    }
    
    public func getColor() -> UIColor? {
        return color
    }
    
    public func getIcon() -> UIImage? {
        return icon
    }
    
    public func getPath() -> String {
        if let p = parent {
            return p.getPath() + "/" + self.label
        }
        else {
            return self.label
        }
    }
    
    var description: String {
        var d = "TreeNode{"
        d += "label='" + label + "'"
        d += ", depth=" + depth.description
        d += ", weight=" + weight.description
        d += ", color=" + (color?.description ?? "None")
        d += ", icon=" + (icon?.description ?? "None") + "}"
        return d
    }
    
}
