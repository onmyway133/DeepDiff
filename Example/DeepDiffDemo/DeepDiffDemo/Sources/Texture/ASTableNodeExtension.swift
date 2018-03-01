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
  ///   - insertionAnimation: The animation for insert rows
  ///   - deletionAnimation: The animation for delete rows
  ///   - replacementAnimation: The animation for reload rows
  ///   - completion: Called when operation completes
  public func reload<T: Hashable>(
    changes: [Change<T>],
    section: Int = 0,
    insertionAnimation: UITableViewRowAnimation = .automatic,
    deletionAnimation: UITableViewRowAnimation = .automatic,
    replacementAnimation: UITableViewRowAnimation = .automatic,
    completion: @escaping (Bool) -> Void) {
    
    let changesWithIndexPath = IndexPathConverter().convert(changes: changes, section: section)
    
    // reloadRows needs to be called outside the batch
    performBatchUpdates({
      internalBatchUpdates(changesWithIndexPath: changesWithIndexPath,
                           insertionAnimation: insertionAnimation,
                           deletionAnimation: deletionAnimation)
    }, completion: completion)
    
    changesWithIndexPath.replaces.executeIfPresent {
      self.reloadRows(at: $0, with: replacementAnimation)
    }
  }
  
  // MARK: - Helper
  
  private func internalBatchUpdates(changesWithIndexPath: ChangeWithIndexPath,
                                    insertionAnimation: UITableViewRowAnimation,
                                    deletionAnimation: UITableViewRowAnimation) {
    changesWithIndexPath.deletes.executeIfPresent {
      deleteRows(at: $0, with: deletionAnimation)
    }
    
    changesWithIndexPath.inserts.executeIfPresent {
      insertRows(at: $0, with: insertionAnimation)
    }
    
    changesWithIndexPath.moves.executeIfPresent {
      $0.forEach { move in
        moveRow(at: move.from, to: move.to)
      }
    }
  }
}

