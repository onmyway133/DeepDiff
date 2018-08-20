//
//  UICollectionView+Extensions.swift
//  DeepDiff
//
//  Created by Khoa Pham.
//  Copyright © 2018 Khoa Pham. All rights reserved.
//

import UIKit

public extension UICollectionView {
  
  /// Animate reload in a batch update
  ///
  /// - Parameters:
  ///   - changes: The changes from diff
  ///   - section: The section that all calculated IndexPath belong
  ///   - completion: Called when operation completes
  public func reload<T: Hashable>(
    changes: [Change<T>],
    section: Int = 0,
    completion: ((Bool) -> Void)? = nil) {
    
    let changesWithIndexPath = IndexPathConverter().convert(changes: changes, section: section)
    
    // reloadRows needs to be called outside the batch
    
    performBatchUpdates({
      internalBatchUpdates(changesWithIndexPath: changesWithIndexPath)
    }, completion: { finished in
      completion?(finished)
    })
    
    changesWithIndexPath.replaces.executeIfPresent {
      self.reloadItems(at: $0)
    }
  }
  
  // MARK: - Helper
  
  private func internalBatchUpdates(changesWithIndexPath: ChangeWithIndexPath) {
    changesWithIndexPath.deletes.executeIfPresent {
      deleteItems(at: $0)
    }
    
    changesWithIndexPath.inserts.executeIfPresent {
      insertItems(at: $0)
    }
    
    changesWithIndexPath.moves.executeIfPresent {
      $0.forEach { move in
        moveItem(at: move.from, to: move.to)
      }
    }
  }
}

