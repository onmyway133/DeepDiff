//
//  RootNode.swift
//  DeepDiffDemo
//
//  Created by Gungor Basa on 26.02.2018.
//  Copyright © 2018 onmyway133. All rights reserved.
//

import AsyncDisplayKit

class RootNode: ASDisplayNode {
  
  let tableNode: ASTableNode = {
    let node = ASTableNode()
    let full = ASDimension(unit: .fraction, value: 1.0)
    node.style.preferredLayoutSize = ASLayoutSize(width: full, height: full)
    
    return node
  }()
  
  override init() {
    super.init()
    automaticallyManagesSubnodes = true
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASAbsoluteLayoutSpec(children: [tableNode])
  }
}
