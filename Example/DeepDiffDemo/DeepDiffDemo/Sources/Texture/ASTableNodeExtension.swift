//
//  ASTableNodeExtension.swift
//  DeepDiffDemo
//
//  Created by Gungor Basa on 26.02.2018.
//  Copyright © 2018 Hyper Interaktiv AS. All rights reserved.
//

import AsyncDisplayKit
import DeepDiff

extension ASTableNode {
  
  /// Animate reload in a batch update
  ///
  /// - Parameters:
  ///   - changes: The changes from diff
  ///   - section: The section that all calculated IndexPath belong
  ///   - completion: Called when operation completes
  public func reload<T: Hashable>(
    changes: [Change<T>],
    section: Int = 0,
    completion: @escaping (Bool) -> Void) {
    
    let changesWithIndexPath = IndexPathConverter().convert(changes: changes, section: section)
    
    // reloadRows needs to be called outside the batch
    performBatchUpdates({
      internalBatchUpdates(changesWithIndexPath: changesWithIndexPath)
    }, completion: completion)
    
    changesWithIndexPath.replaces.executeIfPresent {
      self.reloadRows(at: $0, with: .automatic)
    }
  }
  
  // MARK: - Helper
  
  private func internalBatchUpdates(changesWithIndexPath: ChangeWithIndexPath) {
    changesWithIndexPath.deletes.executeIfPresent {
      deleteRows(at: $0, with: .automatic)
    }
    
    changesWithIndexPath.inserts.executeIfPresent {
      insertRows(at: $0, with: .automatic)
    }
    
    changesWithIndexPath.moves.executeIfPresent {
      $0.forEach { move in
        moveRow(at: move.from, to: move.to)
      }
    }
  }
}

