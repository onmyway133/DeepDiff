//
//  UITableView+Extensions.swift
//  DeepDiff
//
//  Created by Khoa Pham.
//  Copyright © 2018 Khoa Pham. All rights reserved.
//

import UIKit

public extension UITableView {
  
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
    insertionAnimation: UITableView.RowAnimation = .automatic,
    deletionAnimation: UITableView.RowAnimation = .automatic,
    replacementAnimation: UITableView.RowAnimation = .automatic,
    completion: ((Bool) -> Void)? = nil) {
    
    let changesWithIndexPath = IndexPathConverter().convert(changes: changes, section: section)
    
    // reloadRows needs to be called outside the batch
    
    if #available(iOS 11, tvOS 11, *) {
      performBatchUpdates({
        internalBatchUpdates(changesWithIndexPath: changesWithIndexPath,
                             insertionAnimation: insertionAnimation,
                             deletionAnimation: deletionAnimation)
      }, completion: { finished in
        completion?(finished)
      })
      
      changesWithIndexPath.replaces.executeIfPresent {
        self.reloadRows(at: $0, with: replacementAnimation)
      }
    } else {
      beginUpdates()
      internalBatchUpdates(changesWithIndexPath: changesWithIndexPath,
                           insertionAnimation: insertionAnimation,
                           deletionAnimation: deletionAnimation)
      endUpdates()
      
      changesWithIndexPath.replaces.executeIfPresent {
        reloadRows(at: $0, with: replacementAnimation)
      }
      
      completion?(true)
    }
  }
  
  // MARK: - Helper
  
  private func internalBatchUpdates(changesWithIndexPath: ChangeWithIndexPath,
                                    insertionAnimation: UITableView.RowAnimation,
                                    deletionAnimation: UITableView.RowAnimation) {
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
