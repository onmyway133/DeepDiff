//
//  TableNode.swift
//  DeepDiffDemo
//
//  Created by Gungor Basa on 26.02.2018.
//  Copyright © 2018 onmyway133. All rights reserved.
//

import AsyncDisplayKit

class TableCellNode: ASCellNode {
  
  var text = ASTextNode()
  
  override init() {
    super.init()
    automaticallyManagesSubnodes = true
    self.backgroundColor = .orange
    self.style.preferredSize.height = CGFloat(50)
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .center, alignItems: .stretch, children: [text])
  }
}
